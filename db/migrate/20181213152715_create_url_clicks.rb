class CreateUrlClicks < ActiveRecord::Migration[5.2]
  def change
    create_table :url_clicks do |t|
      t.integer :url_id, null: false
      t.integer :user_id
      t.integer :clicks

      t.timestamps
    end

    add_index :url_clicks, :url_id
    add_index :url_clicks, :user_id
  end
end
