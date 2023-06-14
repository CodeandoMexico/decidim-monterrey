# frozen_string_literal: true

module Extensions
  module Decidim
    module Core
      module Permissions
        def permissions
          return permission_action unless permission_action.scope == :public

          read_public_pages_action?
          locales_action?
          component_public_action?
          search_scope_action?

          # This was introduced on this commit: https://github.com/decidim/decidim/commit/053d40b8b4a0db4d8d3abb7574ab3d95042c3ae9
          public_report_content_action?

          return permission_action unless user

          user_manager_permissions
          authorization_valuator_permissions
          manage_self_user_action?
          authorization_action?
          follow_action?
          amend_action?
          notification_action?
          conversation_action?
          user_group_action?
          user_group_invitations_action?
          apply_endorsement_permissions if permission_action.subject == :endorsement

          permission_action
        end

        private

        def public_report_content_action?
          return unless permission_action.action == :create &&
            permission_action.subject == :moderation

          allow!
        end

        def authorization_valuator_permissions
          ::Decidim::AuthorizationValuatorPermissions.new(user, permission_action, context).permissions
        end
      end
    end
  end
end

Decidim::Permissions.prepend Extensions::Decidim::Core::Permissions
