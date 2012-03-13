class SubjectProcessors < ActiveRecord::Migration

  def up
    change_table :subjects do |t|
      t.column :unit_processor_type, :string
      t.remove :name
    end
    change_column :subjects, :from, :string, :null => true
    change_column :subjects, :to, :string, :null => true
  end

  def down
    remove_column :subjects, :unit_processor_type
    change_column :subjects, :from, :string, :null => false
    change_column :subjects, :to, :string, :null => false
  end
end
