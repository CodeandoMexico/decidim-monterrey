module Extensions
  module Decidim
    module Proposals
      module CurrentUserScope

        PARTICIPATORY_PROCESS_TYPE = {
          "DELEGACIONES" => "delegation_code",
          "SECTORES" => "sector_code"
        }

        def current_user_scope(proposal)
          authorization = ::Decidim::Authorization.where
            .not(granted_at: nil)
            .find_by!(user: @current_user, name: "ine")
          scope_type = PARTICIPATORY_PROCESS_TYPE[proposal.component.scope.code]
          ::Decidim::Scope.find_by! code: authorization.metadata[scope_type]
        end
      end
    end
  end
end
