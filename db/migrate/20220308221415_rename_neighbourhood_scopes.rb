class RenameNeighbourhoodScopes < ActiveRecord::Migration[6.0]
  def change
    rename_column :decidim_ine_neighbourhoods, :delegation_code, :district_code
    rename_column :decidim_ine_neighbourhoods, :sector_code, :zone_code
  end
end
