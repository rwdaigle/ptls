class AddSubjectTitle < ActiveRecord::Migration
  def self.up
    add_column :subjects, :title, :string, :null => false
    Subject.find(:all).each do |s|
      s.update_attribute(:title, s.name.split.first)
    end
  end

  def self.down
    remove_column :subjects, :title
  end
end
