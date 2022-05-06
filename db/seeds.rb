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

puts "----------------------------------------------------------------------"
puts "¿Procesar ámbitos? (s/n)"
puts "----------------------------------------------------------------------"
procesar_ambitos = STDIN.gets.strip

if procesar_ambitos == "s"
  puts "\n\n"
  puts "Selecciona la organización para la que quieres cargar los ámbitos y colonias:"
  organizations = Decidim::Organization.all
  organizations.each do |org|
    puts "----------"
    puts "Id: #{org.id}"
    puts "Organización: #{org.name}"
    puts "Host: #{org.host}"
  end
  puts "----------"

  puts "Teclea el Id (número):"
  org_id = STDIN.gets.strip
  organization = nil
  begin
    organization = Decidim::Organization.find org_id
  rescue => e
    puts "No existe una organización con ese Id"
    puts e.to_s
  end

  if organization
    begin
      puts "La organizacion tiene:"
      puts "#{Decidim::Scope.where(organization: organization).to_a.size} ámbitos"
      puts "#{Decidim::ScopeType.where(organization: organization).to_a.size} tipos de ámbito"

      puts "Intentando borrar ámbitos"
      Decidim::Scope.where(organization: organization).destroy_all
      puts "Intentando borrar tipos de ámbito"
      Decidim::ScopeType.where(organization: organization).destroy_all
      puts "Creando Distritos"
      create_scopes(organization, "Distrito", "Distritos", "districts")
      puts "Creando Sectores"
      create_scopes(organization, "Sector", "Sectores", "sectors")
    rescue => e
      puts "ERROR: Hubo un error al borrar o crear los ámbitos"
      puts e.to_s
    end
  end
end

# --------------------------------------------------------------------------------
# Neighborhoods
# --------------------------------------------------------------------------------
puts "----------------------------------------------------------------------"
puts "¿Procesar colonias? (s/n)"
puts "----------------------------------------------------------------------"
procesar_colonias = STDIN.gets.strip

if procesar_colonias == "s"
  begin
    puts "Hay #{Decidim::Ine::Neighbourhood.all.to_a.size} colonias"
    puts "Intentando borrar colonias"
    Decidim::Ine::Neighbourhood.destroy_all
    puts "Creando Colonias"
    neighbourhoods_csv = File.read("db/csv/neighbourhoods.csv")
    neighbourhoods = CSV.parse(neighbourhoods_csv, headers: true)
    neighbourhoods = sort_csv(neighbourhoods, "name")
    neighbourhoods.each do |neighbourhood|
      n = Decidim::Ine::Neighbourhood.new(neighbourhood.to_hash)
      n.save!
      puts "Colonia: #{n.name} | #{n.code} | #{n.sector_code} | #{n.district_code}"
    end
  rescue => e
    puts "ERROR: Hubo un error al borrar o crear las colonias"
    puts e.to_s
  end
end
