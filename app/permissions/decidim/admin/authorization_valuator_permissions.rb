# frozen_string_literal: true

module Decidim
  module Admin
    class AuthorizationValuatorPermissions < Decidim::DefaultPermissions
      delegate :subject, :action, to: :permission_action
      def permissions
        return permission_action unless authorization_valuator? || user.admin?
        allow! if subject == :admin_dashboard && action == :read
        allow! if subject == :admin_user && action == :read
        allow! if subject == :authorization && action == :index
        allow! if subject == :authorization && action == :update
        disallow! if subject == :global_moderation && action == :read

        permission_action
      end

      private

      def authorization_valuator?
        user && !user.admin? && user.role?("authorization_valuator")
      end

      def organization
        @organization ||= context.fetch(:organization, nil) || context.fetch(:current_organization, nil)
      end

      def available_authorization_handlers?
        user.organization.available_authorization_handlers.any?
      end
    end
  end
end
