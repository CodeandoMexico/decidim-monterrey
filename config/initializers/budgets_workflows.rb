Rails.application.config.to_prepare do
  require "./lib/decidim/budgets/workflows"
end
