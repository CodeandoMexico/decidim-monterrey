
if Rails.application.secrets.dig(:omniauth, :juanita).present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :juanita,
      setup: ->(env) {
          
          request = Rack::Request.new(env)
          organization = Decidim::Organization.find_by(host: request.host)
          
          provider_config = organization.enabled_omniauth_providers[:juanita]
          env["omniauth.strategy"].options[:client_options] = {
            identifier: provider_config[:client_id],
            secret: provider_config[:client_secret],
            host: provider_config[:site_url],
            redirect_uri: provider_config[:redirect_uri],
            scheme: 'https',
            port: 443,
          }
        }
    )
  end
end