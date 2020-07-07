class CreateUsersFollowers < ActiveRecord::Migration[5.2]
  def change
    create_table :user_followers do |t|
      t.references :users, foreign_key: true
      t.integer "following_id"
      t.integer "followee_id"

      t.timestamps
    end
  end
end
