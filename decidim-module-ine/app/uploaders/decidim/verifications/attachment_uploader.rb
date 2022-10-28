# frozen_string_literal: true

module Decidim
  module Verifications
    # This class deals with uploading attachments to a participatory space.
    class AttachmentUploader < ApplicationUploader
      def max_image_height_or_width
        800000
      end
    end
  end
end
