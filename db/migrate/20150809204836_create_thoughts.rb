class CreateThoughts < ActiveRecord::Migration
  def change
    create_table :thoughts do |t|
      t.string :title
      t.string :body
      t.belongs_to :user
      t.timestamps
    end
  end
end
