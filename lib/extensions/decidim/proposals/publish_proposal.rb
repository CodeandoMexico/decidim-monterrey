# frozen_string_literal: true

module Extensions
  module Decidim
    module Proposals
      module PublishProposal
        include Extensions::Decidim::Proposals::CurrentUserScope

        def publish_proposal
          title = reset(:title)
          body = reset(:body)

          ::Decidim.traceability.perform_action!(
            "publish",
            @proposal,
            @current_user,
            visibility: "public-only"
          ) do
            Decidim::GeographicScopeMatcher.call(@proposal, @current_user) do
              on(:ok) { |matcher| publisher(title, body, matcher) }
              on(:nil) { publisher(title, body, false) }
            end
            @proposal.save!
          end
        end

        def publisher(title, body, match)
          if match == false
            @proposal.update title: title, body: body, published_at: Time.current
          else
            @proposal.update title: title, body: body, published_at: Time.current, scope: match
          end
        end
      end
    end
  end
end

Decidim::Proposals::PublishProposal.prepend Extensions::Decidim::Proposals::PublishProposal
