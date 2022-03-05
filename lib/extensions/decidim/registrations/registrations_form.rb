module Extensions
  module Decidim
    module RegistrationsForm
      extend ActiveSupport::Concern

      included do
        attribute :phone, String
      end
    end
  end
end

Decidim::RegistrationForm.include Extensions::Decidim::RegistrationsForm
