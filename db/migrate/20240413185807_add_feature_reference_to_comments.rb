class AddFeatureReferenceToComments < ActiveRecord::Migration[7.1]
  def change
    add_reference :comments, :feature, foreign_key: true
  end
end
