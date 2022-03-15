# frozen_string_literal: true

module Decidim
  module Ine
    class InformationForm < AuthorizationHandler
      mimic :ine_information

      attribute :street, String
      attribute :street_number, String
      attribute :postal_code, String
      attribute :neighbourhood_code, String
      attribute :curp, String

      validates :street,
        presence: true

      validates :street_number,
        format: {with: /\A[0-9]*\z/, message: I18n.t("errors.messages.number")},
        presence: true

      validates :postal_code,
        format: {with: /\A[0-9]{5}\z/, message: I18n.t("errors.messages.postal_code")},
        presence: true

      validates :neighbourhood_code,
        inclusion: {in: :neighbourhoods_codes},
        presence: true

      validates :curp,
        format: {with: /\A([A-Z][AEIOUX][A-Z]{2}\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])[HM](?:AS|B[CS]|C[CLMSH]|D[FG]|G[TR]|HG|JC|M[CNS]|N[ETL]|OC|PL|Q[TR]|S[PLR]|T[CSL]|VZ|YN|ZS)[B-DF-HJ-NP-TV-Z]{3}[A-Z\d])(\d)\z/, message: I18n.t("errors.messages.curp")},
        presence: true

      def handler_name
        "ine"
      end

      def map_model(model)
        self.street = model.verification_metadata["street"]
        self.street_number = model.verification_metadata["street_number"]
        self.postal_code = model.verification_metadata["postal_code"]
        self.neighbourhood_code = model.verification_metadata["neighbourhood_code"]
        self.curp = model.verification_metadata["curp"]
      end

      def verification_metadata
        {
          "street" => street,
          "street_number" => street_number,
          "postal_code" => postal_code,
          "neighbourhood_code" => neighbourhood_code,
          "curp" => curp
        }
      end

      def metadata
        neighbourhood = Decidim::Ine::Neighbourhood.find_by(code: neighbourhood_code)
        zone_scope = scope_by_code(neighbourhood.zone_code)
        district_scope = scope_by_code(neighbourhood.district_code)
        {
          "neighbourhood_code" => neighbourhood.code,
          "zone_code" => zone_scope.code,
          "district_code" => district_scope.code
        }
      end

      def unique_id
        # ToDo crear una cadena de texto única para cada usuario, por ejemplo con el nombre y email
        hash_curp(curp).to_s
      end

      def neighbourhoods_for_select
        Decidim::Ine::Neighbourhood.all.order("name").map do |n|
          [
            n.name,
            n.code
          ]
        end
      end

      def neighbourhoods_codes
        Decidim::Ine::Neighbourhood.all.map { |n| n.code }
      end

      def scope_by_code(code)
        Decidim::Scope.find_by(code: code)
      end

      def neighbourhood_by_code(code)
        Decidim::Ine::Neighbourhood.find_by(code: code)
      end

      def hash_curp(curp)
        Digest::MD5.hexdigest(curp)
      end
    end
  end
end
