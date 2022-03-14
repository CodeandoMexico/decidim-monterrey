Rails.application.config.to_prepare do
  require "./lib/extensions/decidim/budgets/workflows"
end
