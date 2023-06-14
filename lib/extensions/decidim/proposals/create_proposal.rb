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
            ) {
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
              Decidim::GeographicScopeMatcher.call(proposal, @current_user) do
                on(:ok) { |matcher| proposal.scope = matcher }
              end
              proposal.save!
              proposal
            }
          end
        end
      end
    end
  end
end

Decidim::Proposals::CreateProposal.prepend Extensions::Decidim::Proposals::CreateProposal
