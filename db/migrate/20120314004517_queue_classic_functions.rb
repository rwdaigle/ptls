class QueueClassic < ActiveRecord::Migration
  def up
    db = QC::Database.new
    db.load_functions
    db.disconnect
  end

  def down
    db = QC::Database.new
    db.unload_functions
    db.disconnect
  end
end
