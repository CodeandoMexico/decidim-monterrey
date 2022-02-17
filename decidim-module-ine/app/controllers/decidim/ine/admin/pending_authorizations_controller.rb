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
          Decidim::Verifications::Authorizations
            .new(organization: current_organization, name: "ine", granted: false)
            .query
            .where("verification_metadata->'rejected' IS NULL")

        end


      end

    end
  end
end
