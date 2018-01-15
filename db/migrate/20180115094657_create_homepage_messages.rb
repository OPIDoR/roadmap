class CreateHomepageMessages < ActiveRecord::Migration
  def change
    create_table :homepage_messages do |t|
      t.string :level
      t.string :text

      t.timestamps null: false
    end
  end
end
