class AddPhoneToDecidimUser < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_users, :phone, :string
  end
end
