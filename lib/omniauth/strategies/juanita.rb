require "oauth2"
require "omniauth"
require "timeout"      # for Timeout::Error

module OmniAuth
  module Strategies
    # Authentication strategy for connecting with APIs constructed using
    # the [OAuth 2.0 Specification](http://tools.ietf.org/html/draft-ietf-oauth-v2-10).
    # You must generally register your application with the provider and
    # utilize an application id and secret in order to authenticate using
    # OAuth 2.0.
    class Juanita < OmniAuth::Strategies::OAuth2
      include OmniAuth::Strategy
      
      args %i[client_id client_secret]
      
      option name:, 'juanita'
      option :client_options, {
        site: ENV['SITE_URL'],
        authorize_url: ENV['AUTHORIZE_URL'],
        token: ENV['TOKEN_URL']
      }
      option :authorize_options # TODO: Personalizar, %i[scope state]


      uid { raw_info["id"] }

      attr_accessor :access_token

      info do
        # TODO: aquí va el mapping de la respuesta de juanita 
        {
          name: raw_info["name"],
          email: raw_info["name"],
          nickname: raw_info["username"],
          image: raw_info["profile_image_url"],
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get(
          # TODO: es necesario especificar el URL y el verbo con en el que requerimos el access token.
        ).parsed || {}
      end

      # TODO: personalizar según opciones del token de acceso
      credentials do
        hash = {"token" => access_token.token}
        hash["refresh_token"] = access_token.refresh_token if access_token.expires? && access_token.refresh_token
        hash["expires_at"] = access_token.expires_at if access_token.expires?
        hash["expires"] = access_token.expires?
        hash
      end
    end
  end
end

