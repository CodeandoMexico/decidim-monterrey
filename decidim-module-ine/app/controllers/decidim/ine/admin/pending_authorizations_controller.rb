# frozen_string_literal: true

module Decidim
  module Ine
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      #
      # Note that it inherits from `Decidim::Admin::Components::BaseController`, which
      # override its layout and provide all kinds of useful methods.
      class PendingAuthorizationsController < Decidim::Admin::ApplicationController
        layout "decidim/admin/users"

        def index
          enforce_permission_to :index, :authorization
          @pending_online_authorizations = pending_online_authorizations
        end

        private

        def pending_online_authorizations
          # > Why relying on `verification_metadata` instead of `granted: false`?
          #
          # There's a work-around which allows users to vote without being
          # registered or verified (but requiring their CURP & INE first).
          #
          # This is implemented with a patched version of the gem:
          # `decidim-verify_wo_registration` which grants authorization without
          # deleting data (a side-effect of using `Authorization.grant!`).
          #
          # Thus, listing pending authorizations will include the ones granted
          # but not verified.
          #
          Decidim::Verifications::Authorizations
            .new(organization: current_organization, name: "ine")
            .query
            .where.not(verification_metadata: {})                           # Not authorized
            .where.not("verification_metadata ->> 'rejected' is not null")  # Not rejected
        end
      end
    end
  end
end
