module ProposalHelper
  PROPOSALS_COMPONENT_SCOPE_VOTE_MESSAGE_KEY = {
    "DISTRITOS" => "decidim.proposals.proposals.voting_rules.proposal_scope.district",
    "SECTORES" => "decidim.proposals.proposals.voting_rules.proposal_scope.sector"
  }

  PROPOSALS_COMPONENT_SCOPE_CREATE_MESSAGE_KEY = {
    "DISTRITOS" => "decidim.proposals.proposals.create_proposal_rules.proposal_scope.district",
    "SECTORES" => "decidim.proposals.proposals.create_proposal_rules.proposal_scope.sector"
  }

  USER_SCOPE_METADATA_KEY = {
    "DISTRITOS" => "district_code",
    "SECTORES" => "sector_code"
  }

  def user_can_vote_district_proposal?(user, proposal)
    authorization = user_authorization(user)
    return false unless authorization && proposal.scope

    proposal.scope.code == authorization.metadata["district_code"]
  end

  def user_can_vote_sector_proposal?(user, proposal)
    authorization = user_authorization(user)
    return false unless authorization && proposal.scope

    proposal.scope.code == authorization.metadata["sector_code"]
  end

  def get_proposals_component_scope_vote_message_key(component_settings)
    component_scope = Decidim::Scope.find component_settings.scope_id
    PROPOSALS_COMPONENT_SCOPE_VOTE_MESSAGE_KEY[component_scope.code]
  end

  def get_proposals_component_scope_create_message_key(component_settings)
    component_scope = Decidim::Scope.find component_settings.scope_id
    PROPOSALS_COMPONENT_SCOPE_CREATE_MESSAGE_KEY[component_scope.code]
  end

  def is_component_scope_district?(component)
    Decidim::Scope.find(component.settings.scope_id).code == "DISTRITOS" 
  end

  def is_component_scope_sector?(component)
    Decidim::Scope.find(component.settings.scope_id).code == "SECTORES"
  end

  def user_scope_name(user, component_settings)
    authorization = user_authorization(user)

    return "" unless authorization
    component_scope = Decidim::Scope.find component_settings.scope_id
    Decidim::Scope.find_by(code: authorization.metadata[USER_SCOPE_METADATA_KEY[component_scope.code]]).name
  end

  def user_authorization(user)
    ine_authorization = ::Decidim::Authorization.where
      .not(granted_at: nil)
      .find_by(user: user, name: "ine")

    managed_user_authorization = ::Decidim::Authorization.where
      .not(granted_at: nil)
      .find_by(user: user, name: "managed_user_authorization_handler")

    ine_authorization || managed_user_authorization
  end

  def user_has_monterrey_authorization?(user)
    return false unless user_authorization(user)
    true
  end

  def remaining_proposals_count_for(user)
    return 0 unless proposal_limit_enabled?

    proposals_count = Decidim::Proposals::Proposal.where(component: current_component)
      .where.not(published_at: nil)
      .joins(:coauthorships)
      .where(decidim_coauthorships: {
        decidim_author_type: ["Decidim::UserBaseEntity"],
        decidim_author_id: user.id
      })
      .except_withdrawn
      .to_a
      .size

    component_settings.proposal_limit - proposals_count
  end
end
