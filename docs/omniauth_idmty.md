# Integración Decidim con omniauth-idmty

Para integrar el servicio de omniauth-idmty con Decidim, bastan los siguientes 5 pasos:

1. Instalar la gema
2. Agregar un inicializador en config/initializers utilizando Omniauth::Builder
3. Activar idmty como proveedor en secrets.yml
4. Proporcionar las credenciales en el panel de sistema de decidim, y agregar el logotipo
5. Compilar los assets

## Instalar la gema

En el gemfile, basta con agregar:

```
gem "omniauth-idmty", path: "/path-de-la-gema/omniauth-idmty"
```

Después: `bundle install`

## Agregar un inicializador

En agrega un archivo: `config/initializers/idmty.rb` con la siguiente información:

```ruby
if Rails.application.secrets.dig(:omniauth, :idmty).present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :idmty,
      setup: ->(env) {
          
          request = Rack::Request.new(env)
          organization = Decidim::Organization.find_by(host: request.host)
          
          provider_config = organization.enabled_omniauth_providers[:idmty]
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
```

## Activa el proveedor idmty en secrets.yml

En el entorno correspondiente, agrega el siguiente código. Asegúrate de dejar en `nil` los valores como aparecen abajo. Cada valor, creará un campo editable en el panel de system, y le delegaremos la habilidad de insertar y cambiar los valores a ese panel, y a la base de datos en el siguiente paso.

```yaml
  omniauth:
    idmty:
      enabled: true
      site_url: nil
      client_id: nil
      client_secret: nil
      redirect_uri: nil
      icon_path: nil
```

## Proporcionar las credenciales en el panel de sistema

En la aplicación, entra a `urldelaaplicacion.com/system` y entra con tus credenciales de administrador de sistema. Da click al botón de "Editar" de tu organización, y entra a "Mostrar configuración avanzada". En la pantalla verás que "IDMty" ya aparece como proveedor de OAuth2. Deberás poner los siguientes campos de configuración:

- site_url: el sitio base del servicio de oauth. En nuestro caso: iam.monterrey.gob.mx
- client_id: proporcionado por el equipo de Monterrey SIGA
- client_secret: proporcionado por el equipo de Monterrey SIGA
- redirect_uri: el sitio al que ocurrirá la redirección. En el caso de decidim, es `http://urldelaaplicacion.com/users/auth/idmty/callback`. Asegúrate de registrarlo tal cual como aparece en el servidor de SIGA, incluyendo el protocolo http o https.
- icon_path: Es el logotipo que aparece en los botoes de oauth. Sólo acepta SVG's y estos deberán estar guardados en el directorio `/app/packs/images`. Sin embargo, los archivos en este folder se compilan, por lo que el icon_path deberá guardarse como: `media/images/nombredelarchivo.svg`. 

## Compilar los assets

Para que el ícono pueda mostrarse es necesario compilar los assets cada vez que se cambia el archivo. Para hacerlo basta con executar `bundle exec rails webpacker:compile`. En caso de que webpacker no haya detectado el cambio, puede correrse el servidor `bin/webpacker` para regenerar el `manifest.json` y tras ello, ejecutar de nuevo `bundle exec rails webpacker:compile`.