module ProposalHelper
  PROPOSALS_COMPONENT_SCOPE_VOTE_MESSAGE_KEY = {
    "DELEGACIONES" => "decidim.proposals.proposals.voting_rules.proposal_scope.delegation",
    "SECTORES" => "decidim.proposals.proposals.voting_rules.proposal_scope.sector"
  }

  PROPOSALS_COMPONENT_SCOPE_CREATE_MESSAGE_KEY = {
    "DELEGACIONES" => "decidim.proposals.proposals.create_proposal_rules.proposal_scope.delegation",
    "SECTORES" => "decidim.proposals.proposals.create_proposal_rules.proposal_scope.sector"
  }

  USER_SCOPE_METADATA_KEY = {
    "DELEGACIONES" => "delegation_code",
    "SECTORES" => "sector_code"
  }

  def user_can_vote_delegation_proposal?(user, proposal)
    authorization = ::Decidim::Authorization.where
      .not(granted_at: nil)
      .find_by!(user: user, name: "ine")

    !authorization.nil? && proposal.scope.code == authorization.metadata["delegation_code"]
  end

  def user_can_vote_sector_proposal?(user, proposal)
    authorization = ::Decidim::Authorization.where
      .not(granted_at: nil)
      .find_by!(user: user, name: "ine")

    !authorization.nil? && proposal.scope.code == authorization.metadata["sector_code"]
  end

  def get_proposals_component_scope_vote_message_key(component_settings)
    component_scope = Decidim::Scope.find component_settings.scope_id
    PROPOSALS_COMPONENT_SCOPE_VOTE_MESSAGE_KEY[component_scope.code]
  end

  def get_proposals_component_scope_create_message_key(component_settings)
    component_scope = Decidim::Scope.find component_settings.scope_id
    PROPOSALS_COMPONENT_SCOPE_CREATE_MESSAGE_KEY[component_scope.code]
  end

  def is_component_scope_delegation?(component)
    Decidim::Scope.find(component.settings.scope_id).code == "DELEGACIONES"
  end

  def is_component_scope_sector?(component)
    Decidim::Scope.find(component.settings.scope_id).code == "SECTORES"
  end

  def user_scope_name(user, component_settings)
    authorization = ::Decidim::Authorization.where
      .not(granted_at: nil)
      .find_by!(user: user, name: "ine")
    component_scope = Decidim::Scope.find component_settings.scope_id
    Decidim::Scope.find_by(code: authorization.metadata[USER_SCOPE_METADATA_KEY[component_scope.code]]).name
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
