if Rails.application.secrets.dig(:omniauth, :juanita).present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :juanita,
      setup: ->(env) {
          request = Rack::Request.new(env)
          organization = Decidim::Organization.find_by(host: request.host)
          provider_config = organization.enabled_omniauth_providers[:juanita]
          env["omniauth.strategy"].options[:client_id] = provider_config[:client_id]
          env["omniauth.strategy"].options[:client_secret] = provider_config[:client_secret]
          env["omniauth.strategy"].options[:site] = provider_config[:site_url]
        },
      scope: :public
    )
  end
end