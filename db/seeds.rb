require 'csv'

# --------------------------------------------------
# Neighbourhoods

neighbourhoods_csv = File.read('db/neighbourhoods.csv')
neighbourhoods = CSV.parse(neighbourhoods_csv, :headers => true)

Decidim::Ine::Neighbourhood.destroy_all
neighbourhoods.each do |neighbourhood|
  n = Decidim::Ine::Neighbourhood.new(neighbourhood.to_hash)
  puts "Creating neighbourhood: #{n.name} | District: #{n.district_id} - #{n.district_name}"
  n.save!
end

# --------------------------------------------------
# Scopes & Scope Types

Decidim::Scope.destroy_all
Decidim::ScopeType.destroy_all

o = Decidim::Organization.first

scope_type = Decidim::ScopeType.new(
  decidim_organization_id: o.id,
  name: { 'es': 'Distrito' },
  plural: { 'es': 'Distritos' },
)
scope_type.save!

districts_csv = File.read('db/districts.csv')
districts = CSV.parse(districts_csv, :headers => true)
districts.each do |district|
  dh = district.to_hash
  d = Decidim::Scope.new(
    decidim_organization_id: o.id,
    scope_type_id: scope_type.id,
    name: { 'es': "#{dh['id']} - #{dh['name']}" },
    code: { 'es': dh['id'] }
  )
  puts "Creating district: #{d.name}"
  d.save!
end

