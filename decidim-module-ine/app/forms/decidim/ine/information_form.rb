# frozen_string_literal: true

module Decidim
  module Ine
    class InformationForm < AuthorizationHandler
      mimic :ine_information

      attribute :street, String
      attribute :street_number, String
      attribute :postal_code, String
      attribute :neighbourhood_code, String

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

      def handler_name
        "ine"
      end

      def map_model(model)
        self.street = model.verification_metadata["street"]
        self.street_number = model.verification_metadata["street_number"]
        self.postal_code = model.verification_metadata["postal_code"]
        self.neighbourhood_code = model.verification_metadata["neighbourhood_code"]
      end

      def verification_metadata
        {
          "street" => street,
          "street_number" => street_number,
          "postal_code" => postal_code,
          "neighbourhood_code" => neighbourhood_code
        }
      end

      def metadata
        neighbourhood_scope = Decidim::Scope.find_by(code: neighbourhood_code)
        sector_scope = Decidim::Scope.find(neighbourhood_scope.parent_id)
        delegation_scope = Decidim::Scope.find(sector_scope.parent_id)
        municipality_scope = Decidim::Scope.find(delegation_scope.parent_id)
        {
          "neighbourhood_code" => neighbourhood_scope.code,
          "sector_code" => sector_scope.code,
          "delegation_code" => delegation_scope.code,
          "municipality_code" => municipality_scope.code
        }
      end

      def unique_id
        # ToDo crear una cadena de texto única para cada usuario, por ejemplo con el nombre y email
        "#{street}|#{street_number}|#{postal_code}|#{neighbourhood_code}"
      end

      def neighbourhoods_for_select
        scope_type = Decidim::ScopeType.find_by(name: {'es': 'Colonia'})
        Decidim::Scope.where(scope_type_id: scope_type.id).order("name").map do |n|
          [
            n.name['es'],
            n.code
          ]
        end
      end

      def neighbourhoods_codes
        scope_type = Decidim::ScopeType.find_by(name: {'es': 'Colonia'})
        Decidim::Scope.where(scope_type_id: scope_type.id).map { |n| n.code }
      end

      def scope_by_code(code)
        Decidim::Scope.find_by(code: code)
      end

    end
  end
end
