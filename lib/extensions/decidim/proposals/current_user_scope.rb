module Extensions
  module Decidim
    module Proposals
      module CurrentUserScope
        PARTICIPATORY_PROCESS_TYPE = {
          "alcance-delegacion" => "delegation_code",
          "alcance-sector" => "sector_code"
        }

        def current_user_scope(proposal)
          participatory_process = ::Decidim::ParticipatoryProcess.find proposal.component.participatory_space_id
          authorization = ::Decidim::Authorization.where
            .not(granted_at: nil)
            .find_by!(user: @current_user, name: "ine")
          scope_type = PARTICIPATORY_PROCESS_TYPE[participatory_process.scope.code]

          ::Decidim::Scope.find_by! code: authorization.metadata[scope_type]
        end
      end
    end
  end
end
