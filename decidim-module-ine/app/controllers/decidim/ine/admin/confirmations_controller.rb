# frozen_string_literal: true

module Decidim
  module Ine
    module Admin

      class ConfirmationsController < Decidim::Admin::ApplicationController
        layout "decidim/admin/users"

        before_action :load_pending_authorization

        def new
          enforce_permission_to :update, :authorization, authorization: @pending_authorization

          @form = InformationForm.new
        end

        def create
          enforce_permission_to :update, :authorization, authorization: @pending_authorization

          @pending_authorization.grant!
          flash[:notice] = t("confirmations.create.success", scope: "decidim.verifications.ine.admin")
          redirect_to pending_authorizations_path
        end

        private

        def load_pending_authorization
          @pending_authorization = Authorization.find(params[:pending_authorization_id])
        end

      end
    end
  end
end
