# frozen_string_literal: true

module Decidim
  module Budgets
    # This cell renders information when current user can't create more budgets orders.
    class LimitAnnouncementCell < BaseCell
      alias budget model
      delegate :voted?, :vote_allowed?, :discardable, :limit_reached?, to: :current_workflow
      delegate :voting_open?, to: :controller

      USER_SCOPE_METADATA_KEY = {
        "DISTRITOS" => "district_code",
        "SECTORES" => "sector_code"
      }

      def show
        cell("decidim/announcement", announcement_message, callout_class: "warning") if announce?
      end

      private

      def announce?
        return unless voting_open?
        return unless current_user
        return if vote_allowed?(budget)
        return if voted?(budget)

        discardable.any? || !vote_allowed?(budget, consider_progress: false)
      end

      def announcement_message
        if discardable.any?
          t(:limit_reached, scope: i18n_scope,
                            links: budgets_link_list(discardable),
                            landing_path: budgets_path)
        else
          sector_name = current_user_sector_scope_name
          t(:cant_vote, scope: i18n_scope, landing_path: budgets_path, sector_name: sector_name['es'])
        end
      end

      def should_discard_to_vote?
        limit_reached? && discardable.any?
      end

      def i18n_scope
        "decidim.budgets.limit_announcement"
      end

      # Pedido ex-profeso por MTY
      def current_user_sector_scope_name

        # Obtenemos primero el objeto autorizacion
        ine_authorization = ::Decidim::Authorization.where
          .not(granted_at: nil)
          .find_by(user: current_user, name: "ine")

        managed_user_authorization = ::Decidim::Authorization.where
          .not(granted_at: nil)
          .find_by(user: current_user, name: "managed_user_authorization_handler")

        authorization = ine_authorization || managed_user_authorization

        return "" unless authorization
        component_scope = current_workflow.budgets_component.scope
        Decidim::Scope.find_by(code: authorization.metadata[USER_SCOPE_METADATA_KEY[component_scope.code]]).name

      end
    end
  end
end
