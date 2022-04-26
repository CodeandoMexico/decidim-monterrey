module Extensions
  module Decidim
    module Proposals
      module CurrentUserScope
        PARTICIPATORY_PROCESS_TYPE = {
          "DISTRITOS" => "district_code",
          "SECTORES" => "sector_code"
        }

        def current_user_scope(proposal)
          # El usuario puede ser un usuario verificado con ine o con impersonacion (managed_user_authorization_handler)

          # autorizacion ine
          ine_authorization = ::Decidim::Authorization.where
            .not(granted_at: nil)
            .find_by!(user: @current_user, name: "ine")

          # autorizacion por impersonacion
          managed_user_authorization = ::Decidim::Authorization.where
            .not(granted_at: nil)
            .find_by(user: @current_user, name: "managed_user_authorization_handler")

          # si el usuario no está verificado regresamos null
          authorization = ine_authorization || managed_user_authorization
          return null unless authorization

          scope_type = PARTICIPATORY_PROCESS_TYPE[proposal.component.scope.code]

          ::Decidim::Scope.find_by! code: authorization.metadata[scope_type]
        end
      end
    end
  end
end
