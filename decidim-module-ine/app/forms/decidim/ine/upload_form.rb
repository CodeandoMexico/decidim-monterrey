# frozen_string_literal: true

module Decidim
  module Ine
    class UploadForm < InformationForm
      mimic :ine_upload

      attribute :verification_attachment, String
      attribute :component_id, String
      attribute :redirect_url, String

      validates :verification_attachment,
        passthru: {to: Decidim::Authorization},
        presence: true

      alias_method :organization, :current_organization
    end
  end
end
