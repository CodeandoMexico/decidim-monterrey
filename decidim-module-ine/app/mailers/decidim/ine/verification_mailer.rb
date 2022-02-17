module Decidim
  module Ine

    class VerificationMailer < Decidim::ApplicationMailer
      include Decidim::TranslationsHelper
      include Decidim::SanitizeHelper

      helper Decidim::TranslationsHelper

      def verification_rejected(user)
        with_user(user) do
          @user = user
          @organization = user.organization
          subject = I18n.t(
            "verification_rejected.subject",
            scope: "decidim.ine.verification_mailer"
          )
          mail(to: user.email, subject: subject)
        end
      end

      def verification_accepted(user)
        with_user(user) do
          @user = user
          @organization = user.organization
          subject = I18n.t(
            "verification_accepted.subject",
            scope: "decidim.ine.verification_mailer"
          )
          mail(to: user.email, subject: subject)
        end
      end

    end

  end
end