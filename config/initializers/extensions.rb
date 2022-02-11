Rails.application.config.to_prepare do
  Dir[Rails.root.join("lib/extensions/**/*.rb")].each { |f| require f }
end
