module Extensions
  module Decidim
    module Admin
      module Permissions
        def permissions
          return permission_action if managed_user_action?
  
          unless permission_action.scope == :admin
            read_admin_dashboard_action?
            return permission_action
          end
  
          unless user
            disallow!
            return permission_action
          end
  
          if user_manager?
            begin
              allow! if user_manager_permissions.allowed?
            rescue ::Decidim::PermissionAction::PermissionNotSetError
              nil
            end
          end
  
          allow! if user_can_enter_space_area?(require_admin_terms_accepted: true)
  
          read_admin_dashboard_action?
          allow! if permission_action.subject == :global_moderation
          apply_newsletter_permissions_for_admin!

          if authorization_valuator?
            begin
              allow! if authorization_valuator_permissions.allowed?
            rescue ::Decidim::PermissionAction::PermissionNotSetError
              nil
            end
          end
  
          if user.admin? && admin_terms_accepted?
            allow! if read_admin_log_action?
            allow! if read_metrics_action?
            allow! if static_page_action?
            allow! if organization_action?
            allow! if user_action?
  
            allow! if permission_action.subject == :category
            allow! if permission_action.subject == :component
            allow! if permission_action.subject == :admin_user
            allow! if permission_action.subject == :attachment
            allow! if permission_action.subject == :attachment_collection
            allow! if permission_action.subject == :scope
            allow! if permission_action.subject == :scope_type
            allow! if permission_action.subject == :area
            allow! if permission_action.subject == :area_type
            allow! if permission_action.subject == :user_group
            allow! if permission_action.subject == :officialization
            allow! if permission_action.subject == :moderate_users
            allow! if permission_action.subject == :authorization
            allow! if permission_action.subject == :authorization_workflow
            allow! if permission_action.subject == :static_page_topic
            allow! if permission_action.subject == :help_sections
            allow! if permission_action.subject == :share_token
          end
  
          permission_action
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
