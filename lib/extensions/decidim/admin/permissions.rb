module Extensions
  module Decidim
    module Admin
      module Permissions
        def permissions

          read_admin_dashboard_action?

          if authorization_valuator?
            begin
              allow! if authorization_valuator_permissions.allowed?
            rescue ::Decidim::PermissionAction::PermissionNotSetError
              nil
            end
          end

          super
        end

        private

        def authorization_valuator?
          user && !user.admin? && user.role?("authorization_valuator")
        end

        def read_admin_dashboard_action?
          return unless permission_action.subject == :admin_dashboard &&
            permission_action.action == :read

          return user_manager_permissions if user_manager?
          return authorization_valuator_permissions if authorization_valuator?

          toggle_allow(user.admin? || space_allows_admin_access_to_current_action?)
        end

        def authorization_valuator_permissions
          ::Decidim::Admin::AuthorizationValuatorPermissions.new(user, permission_action, context).permissions
        end
      end
    end
  end
end

Decidim::Admin::Permissions.prepend Extensions::Decidim::Admin::Permissions
