# frozen_string_literal: true

module Extensions
  module Decidim
    module Budgets
      module ProjectsHelper
        def budget_to_currency(budget)
          number_to_currency budget, locale: "es-MX"
        end
      end
    end
  end
end

Decidim::Budgets::ProjectsHelper.prepend Extensions::Decidim::Budgets::ProjectsHelper
