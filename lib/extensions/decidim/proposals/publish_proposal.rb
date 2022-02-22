# frozen_string_literal: true

module Extensions
  module Decidim
    module Proposals
      module PublishProposal
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
            @proposal.scope = current_user_scope
            @proposal.save!
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

Decidim::Proposals::PublishProposal.prepend Extensions::Decidim::Proposals::PublishProposal