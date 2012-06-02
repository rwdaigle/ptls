class AddProcessorToUnits < ActiveRecord::Migration

  def change
    change_table :units do |t|
      t.column :processor_type, :string
    end
    remove_column :subjects, :unit_processor_type, :from, :to
  end
end