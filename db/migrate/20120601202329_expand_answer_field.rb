class ExpandAnswerField < ActiveRecord::Migration

  def up
    change_column(:units, :answer, :text)
  end

  def down
    change_column(:units, :answer, :varchar, :limit => 255)
  end
end
