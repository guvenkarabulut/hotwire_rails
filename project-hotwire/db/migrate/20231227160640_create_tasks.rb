class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :body
      t.string :status
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
