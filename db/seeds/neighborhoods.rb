require "csv"
require "./db/seeds/progressbar"

module Seeds
  module Neighborhoods
    def self.call
      neighbourhoods = CSV.read("db/csv/neighbourhoods.csv", headers: true)
        .by_row!
        .sort_by { |row| row["name"] }

      progressbar = Seeds::Progressbar.create(
        title: "Neighborhoods",
        total: neighbourhoods.count
      )

      neighbourhoods.each do |neighbourhood|
        Decidim::Ine::Neighbourhood.find_or_create_by!(neighbourhood.to_hash)
        progressbar.increment
      end
    end
  end
end
