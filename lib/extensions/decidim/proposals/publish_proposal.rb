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
            @proposal.update title: title, body: body, published_at: Time.current
            @proposal.scope = current_user_scope(@proposal)
            @proposal.save!
          end
        end
      end
    end
  end
end

Decidim::Proposals::PublishProposal.prepend Extensions::Decidim::Proposals::PublishProposal
