class CreateReactions < ActiveRecord::Migration[8.0]
  def change
    create_table :reactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true, index: false
      t.string :kind, null: false

      t.timestamps
    end

    # One reaction per person per post; changing it updates the row in place.
    add_index :reactions, [:post_id, :user_id], unique: true
  end
end
