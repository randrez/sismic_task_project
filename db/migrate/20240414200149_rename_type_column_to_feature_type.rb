class RenameTypeColumnToFeatureType < ActiveRecord::Migration[7.1]
  def change
    rename_column :features, :type, :feature_type
  end
end
