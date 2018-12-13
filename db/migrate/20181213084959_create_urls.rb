class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.integer :user_id
      t.string :url_long, null: false
      t.string :url_short, null: false

      t.timestamps
    end

    add_index :urls, :user_id
    add_index :urls, :url_short, unique: true
  end
end
