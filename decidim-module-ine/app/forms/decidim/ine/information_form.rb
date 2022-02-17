# frozen_string_literal: true

module Decidim
  module Ine

    class InformationForm < AuthorizationHandler

      mimic :ine_information

      NEIGHBOURHOODS = Decidim::Ine::Neighbourhood.all.map{|n| n.id}

      attribute :street, String
      attribute :street_number, String
      attribute :postal_code, String
      attribute :neighbourhood, Integer

      validates :street,
                presence: true

      validates :street_number,
                format: { with: /\A[0-9]*\z/, message: I18n.t("errors.messages.number") },
                presence: true

      validates :postal_code,
                format: { with: /\A[0-9]{5}\z/, message: I18n.t("errors.messages.postal_code") },
                presence: true

      validates :neighbourhood,
                inclusion: { in: NEIGHBOURHOODS },
                presence: true

      def handler_name
        "ine"
      end

      def map_model(model)
        self.street = model.verification_metadata["street"]
        self.street_number = model.verification_metadata["street_number"]
        self.postal_code = model.verification_metadata["postal_code"]
        self.neighbourhood = model.verification_metadata["neighbourhood"]
      end

      def verification_metadata
        {
          "street" => street,
          "street_number" => street_number,
          "postal_code" => postal_code,
          "neighbourhood" => neighbourhood
        }
      end

      def metadata
        {
          "district_id" => neighbourhood_by_id(neighbourhood).district_id
        }
      end

      def unique_id
        # ToDo crear una cadena de texto única para cada usuario, por ejemplo con el nombre y email
        "#{street}|#{street_number}|#{postal_code}|#{neighbourhood}"
      end

      def neighbourhoods_for_select
        Decidim::Ine::Neighbourhood.all.order('name').map do |n|
          [
            n.name,
            n.id
          ]
        end
      end

      def neighbourhood_by_id(neighbourhood_id)
        Decidim::Ine::Neighbourhood.find(neighbourhood_id)
      end

      def district_by_id(district_id)
        district_id
      end

    end
  end
end
