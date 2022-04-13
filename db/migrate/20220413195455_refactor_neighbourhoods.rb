class RefactorNeighbourhoods < ActiveRecord::Migration[6.0]
  def change
    rename_column :decidim_ine_neighbourhoods, :zone_code, :sector_code
  end
end
