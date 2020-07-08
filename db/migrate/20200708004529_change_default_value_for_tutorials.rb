class ChangeDefaultValueForTutorials < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tutorials, :classroom, from: false, to: true 
  end
end
