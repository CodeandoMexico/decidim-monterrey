# frozen_string_literal: true

module Decidim
  module Ine
    module Admin
      class RejectionsController < Decidim::Admin::ApplicationController
        layout "decidim/admin/users"

        before_action :load_pending_authorization

        def create
          enforce_permission_to :update, :authorization, authorization: @pending_authorization

          @form = InformationRejectionForm.from_model(@pending_authorization)

          # Explicitly reject
          @pending_authorization.granted_at = nil

          Decidim::Verifications::PerformAuthorizationStep.call(@pending_authorization, @form) do
            on(:ok) do
              SendVerificationRejectedJob.perform_now(@authorization.user)
              flash[:notice] = t("rejections.create.success", scope: "decidim.verifications.ine.admin")
              redirect_to root_path
            end
          end
        end

        private

        def load_pending_authorization
          @pending_authorization = Authorization.find(params[:pending_authorization_id])
        end
      end
    end
  end
end
