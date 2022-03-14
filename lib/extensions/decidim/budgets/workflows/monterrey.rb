module Extensions
  module Decidim
    module Budgets
      module Workflows
        # This Workflow allows users to vote in the correspondent budgets according
        # to their scope
        class Monterrey < ::Decidim::Budgets::Workflows::Base
          PARTICIPATORY_PROCESS_TYPE = {
            "DISTRITOS" => "district_code",
            "ZONAS" => "zone_code"
          }

          def highlighted?(_resource)
            false
          end

          # Users can vote in any budget that is into their scope
          def vote_allowed?(budget, consider_progress: true)
            return false unless current_user_scope(budget) == budget.scope

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

            ::Decidim::Scope.find_by! code: user_authorization.metadata[scope_type]
          end

          def user_authorization
            ::Decidim::Authorization.where
              .not(granted_at: nil)
              .find_by!(user: user, name: "ine")
          end
        end
      end
    end
  end
end
