require "csv"

csv_file = File.read("neighbourhoods.csv")
csv = CSV.parse(csv_file, headers: true)
csv.each do |neighbourhood|
  puts neighbourhood
end
