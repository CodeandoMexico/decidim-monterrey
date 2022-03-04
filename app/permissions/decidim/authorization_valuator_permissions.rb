# frozen_string_literal: true

module Decidim
  class AuthorizationValuatorPermissions < DefaultPermissions
    def permissions
      if authorization_valuator?
        allow! if read_admin_dashboard_action?
      end

      permission_action
    end

    private

    def read_admin_dashboard_action?
      permission_action.subject == :admin_dashboard &&
        permission_action.action == :read
    end

    # Whether the user has the authorization_valuator role or not.
    def authorization_valuator?
      user && !user.admin? && user.role?("authorization_valuator")
    end
  end
end
