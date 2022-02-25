class AddDelegationCode < ActiveRecord::Migration[6.0]
  def change
    rename_column :decidim_ine_neighbourhoods, :parent_code, :sector_code
    add_column :decidim_ine_neighbourhoods, :delegation_code, :string
  end
end
