class SubjectProcessors < ActiveRecord::Migration

  def up
    change_table :subjects do |t|
      t.column :unit_processor_type, :string
      t.remove :name
    end
    change_column :subjects, :from, :string, :null => true
    change_column :subjects, :to, :string, :null => true

    # Queue classic
    create_table :queue_classic_jobs do |t|
      t.text :details
      t.timestamp :locked_at
    end
  end

  def down
    remove_column :subjects, :unit_processor_type
    change_table :subjects do |t|
      t.column :name, :string
    end
    
    drop_table :queue_classic_jobs
  end
end
