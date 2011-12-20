class AddDeferrals < ActiveRecord::Migration
  def self.up
    add_column :learnings, :deferred, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :learnings, :deferred
  end
end
