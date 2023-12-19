# frozen_string_literal: true

module Decidim
  module Ine
    class InformationRejectionForm < InformationForm
      def metadata
        {}
      end

      def verification_metadata
        super.merge("rejected" => true)
      end
    end
  end
end
