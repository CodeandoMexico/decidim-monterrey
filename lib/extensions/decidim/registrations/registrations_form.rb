module Extensions
  module Decidim
    module RegistrationsForm
      extend ActiveSupport::Concern

      included do
        attribute :phone, String
        validates :phone, allow_nil: true, allow_blank: true, format: /\A[\+]?[0-9]{10,13}\z/
        validate :phone_unique_in_organization

        def phone_unique_in_organization
          return unless phone && phone.length >= 10
          user_with_same_phone = ::Decidim::User.no_active_invitation
            .find_by(phone: phone, organization: current_organization)

          errors.add :phone, :taken if user_with_same_phone.present?
        end
      end
    end
  end
end

Decidim::RegistrationForm.include Extensions::Decidim::RegistrationsForm
