class CreateRadioStations < ActiveRecord::Migration
  def change
    create_table :radio_stations do |t|
      t.string :name,            null: false, default: ''
      t.string :url,             null: false, default: '' 
      t.string :parse_url,       null: false, default: ''
      t.integer :parse_url_type, null: false, default: 0

      t.timestamps null: false
    end
  end
end
