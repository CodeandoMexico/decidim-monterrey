# frozen_string_literal: true

module Decidim
  module Ine

    class UploadForm < InformationForm

      mimic :ine_upload

      attribute :verification_attachment, String

      validates :verification_attachment,
                passthru: { to: Decidim::Authorization },
                presence: true

      alias organization current_organization

    end
  end
end
