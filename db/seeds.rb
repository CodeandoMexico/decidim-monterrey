# frozen_string_literal: true

require "csv"

def create_scopes(organization, scope_type_name, scope_type_plural, scopes_csv_name)
  scope_type = Decidim::ScopeType.new(
    decidim_organization_id: organization.id,
    name: {'es': scope_type_name},
    plural: {'es': scope_type_plural}
  )
  scope_type.save!
  puts "Creating Scope Type: #{scope_type.id} | #{scope_type.name} | #{scope_type.plural}"

  scopes_csv = File.read("./db/csv/#{scopes_csv_name}.csv")
  scopes = CSV.parse(scopes_csv, headers: true)
  scopes = scopes.sort_by{|s| s[:name]}
  scopes.each do |s|
    hash = s.to_hash
    parent_scope = Decidim::Scope.find_by(code: hash["parent_code"])
    scope = Decidim::Scope.new(
      decidim_organization_id: organization.id,
      scope_type_id: scope_type.id,
      name: {'es': hash["name"]},
      code: hash["code"],
      parent_id: !parent_scope ? nil : parent_scope.id
    )
    scope.save!
    scope.update(part_of: [scope.id] + (!parent_scope ? [] : parent_scope.part_of))
    puts "Creating Scope: #{scope.id} | #{scope.name} | #{scope.code} | #{scope.parent_id} | #{scope.part_of}"
  end

end

Decidim::Scope.destroy_all
Decidim::ScopeType.destroy_all

organization = Decidim::Organization.first

create_scopes(organization, "Municipio", "Municipios", "municipalities")
create_scopes(organization, "Delegación", "Delegaciones", "delegations")
create_scopes(organization, "Sector", "Sectores", "sectors")
create_scopes(organization, "Colonia", "Colonias", "neighbourhoods")
