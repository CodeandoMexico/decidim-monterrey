module Extensions
  module Decidim
    module Budgets
      module Workflows
        # This Workflow allows users to vote in the correspondent budgets according
        # to their scope (district or sector)
        class Monterrey < ::Decidim::Budgets::Workflows::Base
          PARTICIPATORY_PROCESS_TYPE = {
            "DISTRITOS" => "district_code",
            "SECTORES" => "sector_code"
          }

          def highlighted?(_resource)
            false
          end

          # Users can vote in any budget that is into their scope
          def vote_allowed?(budget, consider_progress: true)
            return false unless budget.scope == current_user_scope(budget)

            if consider_progress
              progress?(budget) || progress.none?
            else
              true
            end
          end

          # Public: Returns a list of budgets where the user can discard their order to vote in another.
          #
          # Returns Array.
          def discardable
            progress + voted
          end

          private

          def current_user_scope(budget)
            scope_type = PARTICIPATORY_PROCESS_TYPE[budget.scope.parent.code]
            current_user_authorization = user_authorization
            return nil unless current_user_authorization
            ::Decidim::Scope.find_by! code: current_user_authorization.metadata[scope_type]
          end

          # We search for ine authorization first, because it has more priority than
          # managed user authorization, and both are exclusive, a user can't have both.
          def user_authorization
            ine_authorization = ::Decidim::Authorization.where
              .not(granted_at: nil)
              .find_by(user: user, name: "ine")

            managed_user_authorization = ::Decidim::Authorization.where
              .not(granted_at: nil)
              .find_by(user: user, name: "managed_user_authorization_handler")

            ine_authorization || managed_user_authorization
          end
        end
      end
    end
  end
end
