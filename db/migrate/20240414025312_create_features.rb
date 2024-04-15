class CreateFeatures < ActiveRecord::Migration[7.1]
  def change
    create_table :features do |t|
      t.string :external_id
      t.float :magnitude
      t.string :place
      t.datetime :time
      t.boolean :tsunami
      t.string :mag_type
      t.string :title
      t.string :type
      t.string :url
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
