# frozen_string_literal: true

module Extensions
  module Decidim
    module Proposals
      module UpdateProposal
        def update_proposal
          @proposal = ::Decidim.traceability.update!(
            @proposal,
            current_user,
            attributes,
            visibility: "public-only"
          )
          @proposal.coauthorships.clear
          @proposal.add_coauthor(current_user, user_group: user_group)
          @proposal.scope = current_user_scope
          @proposal.save!
        end
  
        private

        def current_user_scope
          authorization = ::Decidim::Authorization.where
                                                  .not(granted_at: nil)
                                                  .find_by!(user: @current_user, name: "ine")

          ::Decidim::Scope.find_by! code: authorization.metadata["district_id"].to_s
        end
      end
    end
  end
end

Decidim::Proposals::UpdateProposal.prepend Extensions::Decidim::Proposals::UpdateProposal