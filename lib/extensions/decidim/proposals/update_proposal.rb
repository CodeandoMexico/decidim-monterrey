# frozen_string_literal: true

module Extensions
  module Decidim
    module Proposals
      module UpdateProposal
        include Extensions::Decidim::Proposals::CurrentUserScope

        def update_proposal
          @proposal = ::Decidim.traceability.update!(
            @proposal,
            current_user,
            attributes,
            visibility: "public-only"
          )
          @proposal.coauthorships.clear
          @proposal.add_coauthor(current_user, user_group: user_group)
          Decidim::GeographicScopeMatcher.call(proposal, @current_user) do
            on(:ok) {|matcher| @proposal.scope = matcher}
          end
          @proposal.save!
        end
      end
    end
  end
end

Decidim::Proposals::UpdateProposal.prepend Extensions::Decidim::Proposals::UpdateProposal
