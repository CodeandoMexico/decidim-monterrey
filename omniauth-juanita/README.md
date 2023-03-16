# omniauth-juanita 

Gema que permite hacer log-in a tu aplicación utilizando el servicio Juanita, de identificación digital de la ciudad de Monterrey, México.

## Instalación

En tu Gemfile:

```
gem 'omniauth-juanita'
```
Después corre `bundle install` en tu terminal.

## Configuración

Necesitarás un client_id y un client_secret para este servicio. Deberás escribir a la dirección de informática de [Monterrey SIGA](monterrey.gob.mx/siga) para obtener tu registro. Deberás proporcionar la url de tu servicio y la url de callback (por ejemplo: http://tuurl.com/users/auth/juanita/callback).

Pon dichas variables en tu .env o lo que utilices para administrar las variables de entorno, y referencíalos en tu `secrets.yml`:

```yaml
omniauth:
  juanita:
    enabled: true
    redirect_uri: <%= ENV['JUANITA_CALLBACK'] %>
    scheme: 'https'
    port: 443
```

Para activarlo, recomiendo utilizar OmniAuth::Builder en un initializer, por ejemplo:

```ruby
# config/initializers/juanita.rb
if Rails.application.secrets.dig(:omniauth, :juanita).present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :juanita,
      setup: ->(env) {
          
          request = Rack::Request.new(env)
          organization = Decidim::Organization.find_by(host: request.host)
          
          provider_config = organization.enabled_omniauth_providers[:juanita]
          secrets_config = Rails.application.secrets[:omniauth][:juanita]
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

