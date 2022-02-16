# This migration comes from decidim_ine (originally 20220216191823)
class CreateDecidimIneNeighbourhoods < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_ine_neighbourhoods do |t|
      t.string :name, unique: true
      t.integer :district_id
      t.text :district_name
      t.timestamps
    end

    add_index :decidim_ine_neighbourhoods, [:name, :district_id], unique: true
  end
end
