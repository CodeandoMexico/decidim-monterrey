# frozen_string_literal: true

module Decidim
  module Ine

    class SendVerificationRejectedJob < ApplicationJob
      queue_as :default

      def perform(user)
        return if user&.email.blank?

        VerificationMailer.verification_rejected(user).deliver_now
      end
    end

  end
end