class CreateJoinTableUsersRepresentatives < ActiveRecord::Migration[6.0]
  def change
    create_join_table :representatives, :users do |t|
      t.index [:user_id, :representative_id]
      t.index [:representative_id, :user_id]
    end
  end
end
