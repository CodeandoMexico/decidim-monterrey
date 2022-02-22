# frozen_string_literal: true

module Extensions
  module Decidim
    module Proposals
      module CreateProposal
        def create_proposal
          PaperTrail.request(enabled: false) do
            @proposal = ::Decidim.traceability.perform_action!(
              :create,
              ::Decidim::Proposals::Proposal,
              @current_user,
              visibility: "public-only"
            ) do
              proposal = ::Decidim::Proposals::Proposal.new(
                title: {
                  I18n.locale => title_with_hashtags
                },
                body: {
                  I18n.locale => body_with_hashtags
                },
                component: form.component
              )
              proposal.add_coauthor(@current_user, user_group: user_group)
              proposal.scope = current_user_scope
              binding.irb
              proposal.save!
              proposal
            end
          end
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

Decidim::Proposals::CreateProposal.prepend Extensions::Decidim::Proposals::CreateProposal
