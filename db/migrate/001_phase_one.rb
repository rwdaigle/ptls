class PhaseOne < ActiveRecord::Migration
  def self.up
    
    create_table :subjects do |t|
      t.string :name, :permalink, :null => false, :unique => true
      t.string :from, :to, :null => false
      t.timestamps
    end
    add_index :subjects, :permalink
    
    create_table :units do |t|
      t.string :question, :null => false
      t.string :answer
      t.integer :subject_id, :position, :null => false
      t.timestamps
    end
    add_index :units, :subject_id
    
    create_table :users do |t|
      t.string :login, :crypted_password, :salt, :null => false, :limit => 40
      t.string :email, :remember_token
      t.datetime :remember_token_expires_at
      t.integer :daily_units, :null => false, :default => 5
      t.timestamps
    end
    add_index :users, :login, :unique => true
    
    create_table :learnings do |t|
      t.integer :user_id, :unit_id, :null => false
      t.datetime :created_at, :null => false
    end
    add_index :learnings, :user_id
    
    create_table :reviews do |t|
      t.integer :user_id, :unit_id, :null => false
      t.integer :interval, :null => false, :default => 1
      t.boolean :success, :reviewed, :null => false, :default => false
      t.date :scheduled_for, :null => false
      t.timestamps
      t.datetime :reviewed_at
    end
    add_index :reviews, :user_id
    
  end

  def self.down
    drop_table :units
    drop_table :subjects
    drop_table :users
    drop_table :learnings
    drop_table :reviews
  end
end
