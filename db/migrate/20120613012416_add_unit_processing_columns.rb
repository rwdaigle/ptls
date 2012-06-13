class AddUnitProcessingColumns < ActiveRecord::Migration

  def up
    change_table :units do |t|
      t.datetime :last_processed_at
      t.integer :process_count, :default => 0, :null => false
    end
  end

  def down
    remove_column :units, :last_processed_at, :process_count
  end
end
