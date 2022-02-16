# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# You can remove the 'faker' gem if you don't want Decidim seeds.
# Decidim.seed!


require 'csv'

# --------------------------------------------------
# Neighbourhoods

csv_file = File.read('db/neighbourhoods.csv')
csv = CSV.parse(csv_file, :headers => true)

Decidim::Ine::Neighbourhood.destroy_all
csv.each do |neighbourhood|
  n = Decidim::Ine::Neighbourhood.new(neighbourhood.to_hash)
  puts "Creating neighbourhood: #{n.name} | District: #{n.district_id} - #{n.district_name}"
  n.save!
end

# --------------------------------------------------
# Scopes & Scope Types

scope_type_name = {
  'es': 'DistritoX'
}

scope_type_plural = {
  'es': 'DistritosX'
}

Decidim::ScopeType.new(
  decidim_organization_id: 1,
  name: scope_type_name,
  plural: scope_type_plural,
)

