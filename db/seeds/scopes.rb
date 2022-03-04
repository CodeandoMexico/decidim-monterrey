require "csv"
require "./db/seeds/progressbar"

module Seeds
  module Scopes
    SCOPE_TYPES = {
      "delegations" => {name: "Delegación", plural_name: "Delegaciones"},
      "sectors" => {name: "Sector", plural_name: "Sectores"}
    }.freeze

    def self.call(organization)
      @organization = organization

      create_scopes_for("delegations")
      create_scopes_for("sectors")
    end

    def self.create_scopes_for(type)
      scope_type = Decidim::ScopeType.find_or_create_by!(
        decidim_organization_id: @organization.id,
        name: {'es': SCOPE_TYPES[type][:name]},
        plural: {'es': SCOPE_TYPES[type][:plural_name]}
      )

      root_scope = Decidim::Scope.find_or_create_by!(
        decidim_organization_id: @organization.id,
        scope_type_id: nil,
        name: {'es': SCOPE_TYPES[type][:plural_name]},
        code: SCOPE_TYPES[type][:plural_name].upcase,
        parent_id: nil
      )

      scopes = CSV.read("./db/csv/#{type}.csv", headers: true)
        .by_row!
        .sort_by { |row| row["name"] }

      progressbar = Seeds::Progressbar.create(title: type, total: scopes.count)

      scopes.each do |scope|
        parent_scope = Decidim::Scope.find_by(code: scope["parent_code"])
        scope = Decidim::Scope.new(
          decidim_organization_id: @organization.id,
          scope_type: scope_type,
          name: {'es': scope["name"]},
          code: scope["code"],
          parent_id: root_scope.id
        )

        # TODO: Refactor
        scope.update(part_of: [scope.id] + (!parent_scope ? [] : parent_scope.part_of))

        sleep 0.05
        progressbar.increment
      end
    end
  end
end
