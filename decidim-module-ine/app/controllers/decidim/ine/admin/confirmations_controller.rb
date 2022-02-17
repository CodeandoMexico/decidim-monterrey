module Decidim
  module Ine
    module Admin
      class ConfirmationsController < Decidim::Admin::ApplicationController
        layout "decidim/admin/users"

        before_action :load_pending_authorization

        def new
          enforce_permission_to :update, :authorization, authorization: @pending_authorization
          @form = InformationForm.from_params(@pending_authorization[:verification_metadata])
        end

        def create
          enforce_permission_to :update, :authorization, authorization: @pending_authorization

          @form = InformationForm.from_params(params)

          ConfirmUserAuthorization.call(@pending_authorization, @form, session) do
            on(:ok) do
              flash[:notice] = t("confirmations.create.success", scope: "decidim.verifications.id_documents.admin")
              redirect_to pending_authorizations_path
            end

            on(:invalid) do
              flash.now[:alert] = t("confirmations.create.error", scope: "decidim.verifications.id_documents.admin")
              render action: :new
            end
          end
        end

        private

        def load_pending_authorization
          @pending_authorization = Decidim::Authorization.find(params[:pending_authorization_id])
        end
      end
    end
  end
end