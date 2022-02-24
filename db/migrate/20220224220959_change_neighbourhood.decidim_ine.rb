# This migration comes from decidim_ine (originally 20220224220534)
class ChangeNeighbourhood < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_ine_neighbourhoods, :code, :string
    add_column :decidim_ine_neighbourhoods, :parent_code, :string
    remove_column :decidim_ine_neighbourhoods, :district_id
    remove_column :decidim_ine_neighbourhoods, :district_name
  end
end
