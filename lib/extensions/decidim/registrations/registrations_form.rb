module Extensions
  module Decidim
    module RegistrationsForm
      extend ActiveSupport::Concern

      included do
        attribute :phone, String
        validates :phone, allow_nil: true, format: /[0-9]{10}/
        validate :mobile_phone_number_unique_in_organization

        def mobile_phone_number_unique_in_organization
          existing_user = ::Decidim::User.no_active_invitation
            .find_by(phone: phone, organization: current_organization)
            .present?

          errors.add :phone, :taken if existing_user.present?
        end
      end
    end
  end
end

Decidim::RegistrationForm.include Extensions::Decidim::RegistrationsForm
