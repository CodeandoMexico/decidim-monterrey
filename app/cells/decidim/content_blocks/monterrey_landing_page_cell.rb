# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class MonterreyLandingPageCell < Decidim::ViewModel
      include Decidim::IconHelper
      include Decidim::SanitizeHelper

      def show
        get_proposals(2)
        return if translated_attribute(current_organization.description).blank?

        render
      end

      def get_proposals(limit)
        proposals = ::Decidim::Proposals::Proposal.all
        return false if proposals.length.nil?
        return proposals.reverse if proposals.length < limit

        proposals = proposals.reverse
        proposals_return = []
        (limit - 1).times do |i|
          proposals_return.push(proposals[i])
        end

        proposals_return
      end

      private

      def organization_description
        desc = decidim_sanitize(translated_attribute(current_organization.description))
        # Strip the surrounding paragraph tag because it is not allowed within
        # a <hN> element.
        desc.gsub(%r{</p>\s+<p>}, "<br><br>").gsub(%r{<p>(((?!</p>).)*)</p>}mi, "\\1")
      end
    end
  end
end
