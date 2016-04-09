class CreateRadios < ActiveRecord::Migration
  def change
    create_table :radios do |t|
      t.string :name,           null:false, default: ''
      t.string :description
      t.string :url,            null:false, default: ''
      t.string :image_url
      t.datetime :published_at, null:false
      t.integer :radio_station_id

      t.timestamps null: false
    end

    add_index :radios, [:name, :published_at], unique: true
  end
end
