class CreateLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :logs do |t|
      t.text :trace
      t.string :message

      t.timestamps
    end
  end
end
