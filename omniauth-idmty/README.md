# omniauth-idmty 

Gema que permite hacer log-in a tu aplicación utilizando el servicio IDMty, de identificación digital de la ciudad de Monterrey, México.

## Instalación

En tu Gemfile:

```
gem 'omniauth-idmty'
```
Después corre `bundle install` en tu terminal.

## Configuración

Necesitarás un client_id y un client_secret para este servicio. Deberás escribir a la dirección de informática de [Monterrey SIGA](monterrey.gob.mx/siga) para obtener tu registro. Deberás proporcionar la url de tu servicio y la url de callback (por ejemplo: http://tuurl.com/users/auth/idmty/callback).

Se requieren las siguientes variables:

- client_id
- client_secret
- redirect_uri
- client_url


Para activarlo, recomiendo utilizar OmniAuth::Builder en un initializer, por ejemplo:

```ruby
# config/initializers/idmty.rb
if Rails.application.secrets.dig(:omniauth, :idmty).present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :idmty,
      setup: ->(env) {
          
          request = Rack::Request.new(env)
          organization = Decidim::Organization.find_by(host: request.host)
          
          provider_config = organization.enabled_omniauth_providers[:idmty]
          secrets_config = Rails.application.secrets[:omniauth][:idmty]
          env["omniauth.strategy"].options[:client_options] = {
            identifier: provider_config[:client_id],
            secret: provider_config[:client_secret],
            host: provider_config[:site_url],
            redirect_uri: secrets_config[:redirect_uri],
            scheme: secrets_config[:scheme],
            port: secrets_config[:port],
          }
        }
    )
  end
end
```

## Atribuciones

Esta gema está basada en la gema [omniauth_openid_connect](https://github.com/omniauth/omniauth_openid_connect) con algunas actualizaciones, en particular a usar como dependencia la versión 2 de la gema 'openid_connect'. La gema tiene mayor documentación sobre las variables que utiliza.

