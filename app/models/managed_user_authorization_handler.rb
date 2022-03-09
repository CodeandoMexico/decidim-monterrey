# frozen_string_literal: true

class ManagedUserAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :street, String
  attribute :street_number, String
  attribute :postal_code, String
  attribute :neighbourhood_code, Decidim::Ine::Neighbourhood

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
    # TODO: TBD
    "#{street}|#{street_number}|#{postal_code}|#{neighbourhood_code}"
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
end
