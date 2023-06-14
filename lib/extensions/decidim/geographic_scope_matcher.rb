module Decidim
  class GeographicScopeMatcher < Rectify::Command
    # This extension helps associate user's district or sector to their participation in a component. If the component has a scope, and the scope is permissions' associated, this extension will find the corresponding user's scope, and match it to the component's needs.

    GEO_SCOPES = {
      "DISTRITOS" => "district_code",
      "SECTORES" => "sector_code"
    }

    def initialize(item, current_user)
      @item = item
      @component = item.component
      @current_user = current_user
    end

    def call
      return broadcast(:nil) if @component.scope.nil?

      component_scope_type = scope_type_checker
      return broadcast(:nil) if component_scope_type.nil?

      authorizations = user_authorization_checker
      return broadcast(:nil) if authorizations.nil?

      matcher = component_scope_matcher(component_scope_type, authorizations)

      broadcast(:ok, matcher)
    end

    private

    def scope_type_checker
      GEO_SCOPES[@component.scope.code]
    end

    def user_authorization_checker
      authorizations = Decidim::Authorization.where.not(granted_at: nil).where(user: @current_user, name: ["ine", "managed_user_authorization_handler"])

      authorizations.nil? || authorizations
    end

    def item_scope_matcher(scope_type, authorization)
      Decidim::Scope.find_by! code: authorizations.last.metadata[scope_type]
    end
  end
end
