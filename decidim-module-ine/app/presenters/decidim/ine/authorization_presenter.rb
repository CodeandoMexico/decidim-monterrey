# frozen_string_literal: true

module Decidim
  module Ine
    class AuthorizationPresenter < SimpleDelegator
      def rejected?
        verification_metadata["rejected"] == true
      end
    end
  end
end
