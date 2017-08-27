class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :site_url
      t.string :telephone

      t.timestamps
    end
  end
end
