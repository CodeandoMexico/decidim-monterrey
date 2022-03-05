module Extensions
  module Decidim
    module CreateRegistration
      def create_user
        @user = ::Decidim::User.create!(
          email: form.email,
          name: form.name,
          nickname: form.nickname,
          password: form.password,
          password_confirmation: form.password_confirmation,
          organization: form.current_organization,
          tos_agreement: form.tos_agreement,
          newsletter_notifications_at: form.newsletter_at,
          email_on_notification: true,
          accepted_tos_version: form.current_organization.tos_version,
          locale: form.current_locale,
          phone: form.phone
        )
      end
    end
  end
end

Decidim::CreateRegistration.prepend Extensions::Decidim::CreateRegistration
