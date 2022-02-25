# frozen_string_literal: true

require "csv"

def sort_csv(csv_rows, sort_column)
  rows = []
  csv_rows.each do |row|
    rows << row.to_h
  end
  rows.sort_by { |row| row[sort_column] }
end

def create_scopes(organization, scope_type_name, scope_type_plural, scopes_csv_name)
  scope_type = Decidim::ScopeType.new(
    decidim_organization_id: organization.id,
    name: {'es': scope_type_name},
    plural: {'es': scope_type_plural}
  )
  scope_type.save!
  puts "Creating Scope Type: #{scope_type.id} | #{scope_type.name} | #{scope_type.plural}"

  scope_root = Decidim::Scope.new(
    decidim_organization_id: organization.id,
    scope_type_id: nil,
    name: {'es': scope_type_plural},
    code: scope_type_plural.upcase,
    parent_id: nil
  )
  scope_root.save!
  puts "Creating Scope: #{scope_root.id} | #{scope_root.name} | #{scope_root.code} | #{scope_root.parent_id} | #{scope_root.part_of}"

  scopes_csv = File.read("./db/csv/#{scopes_csv_name}.csv")
  scopes = CSV.parse(scopes_csv, headers: true)
  scopes = sort_csv(scopes, "name")
  scopes.each do |s|
    hash = s.to_hash
    parent_scope = Decidim::Scope.find_by(code: hash["parent_code"])
    scope = Decidim::Scope.new(
      decidim_organization_id: organization.id,
      scope_type_id: scope_type.id,
      name: {'es': hash["name"]},
      code: hash["code"],
      parent_id: scope_root.id
    )
    scope.save!
    scope.update(part_of: [scope.id] + (!parent_scope ? [] : parent_scope.part_of))
    puts "Creating Scope: #{scope.id} | #{scope.name} | #{scope.code} | #{scope.parent_id} | #{scope.part_of}"
  end
end

Decidim::Scope.destroy_all
Decidim::ScopeType.destroy_all
organization = Decidim::Organization.first
create_scopes(organization, "Delegación", "Delegaciones", "delegations")
create_scopes(organization, "Sector", "Sectores", "sectors")

# --------------------------------------------------------------------------------
# Neighborhoods
# --------------------------------------------------------------------------------
Decidim::Ine::Neighbourhood.destroy_all
neighbourhoods_csv = File.read("db/csv/neighbourhoods.csv")
neighbourhoods = CSV.parse(neighbourhoods_csv, headers: true)
neighbourhoods = sort_csv(neighbourhoods, "name")
neighbourhoods.each do |neighbourhood|
  n = Decidim::Ine::Neighbourhood.new(neighbourhood.to_hash)
  n.save!
  puts "Creating neighbourhood: #{n.name} | #{n.code} | #{n.sector_code} | #{n.delegation_code}"
end
