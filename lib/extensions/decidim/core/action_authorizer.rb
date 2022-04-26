module Extensions
  module Decidim
    module ActionAuthorizer
      module AuthorizationStatusCollection
        def ok?
          return true if statuses.blank?
          statuses.any?(&:ok?)
        end
      end
    end
  end
end

Decidim::ActionAuthorizer::AuthorizationStatusCollection.prepend Extensions::Decidim::ActionAuthorizer::AuthorizationStatusCollection
