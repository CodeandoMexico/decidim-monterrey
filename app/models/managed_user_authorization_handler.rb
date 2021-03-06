# frozen_string_literal: true

class ManagedUserAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :neighbourhood_code, Decidim::Ine::Neighbourhood
  attribute :curp, String

  validates :neighbourhood_code,
    inclusion: {in: :neighbourhoods_codes},
    presence: true

  validates :curp,
    format: {with: /\A([A-Z][AEIOUX][A-Z]{2}\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])[HM](?:AS|B[CS]|C[CLMSH]|D[FG]|G[TR]|HG|JC|M[CNS]|N[ETL]|OC|PL|Q[TR]|S[PLR]|T[CSL]|VZ|YN|ZS)[B-DF-HJ-NP-TV-Z]{3}[A-Z\d])(\d)\z/, message: I18n.t("errors.messages.curp")},
    presence: true

  def metadata
    neighbourhood = Decidim::Ine::Neighbourhood.find_by(code: neighbourhood_code)
    sector_scope = scope_by_code(neighbourhood.sector_code)
    district_scope = scope_by_code(neighbourhood.district_code)
    {
      "neighbourhood_code" => neighbourhood.code,
      "sector_code" => sector_scope.code,
      "district_code" => district_scope.code
    }
  end

  def unique_id
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

  def hash_curp(curp)
    return "" unless curp
    Digest::MD5.hexdigest(curp)
  end
end
