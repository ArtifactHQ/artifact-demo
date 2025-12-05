class CreateVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :versions do |t|
      t.references :document, null: false, foreign_key: true
      t.integer :version_number, null: false
      t.text :content
      t.string :commit_message
      t.datetime :committed_at
      t.string :status, default: 'draft'

      t.timestamps
    end

    add_index :versions, [:document_id, :version_number], unique: true
    add_index :versions, :status
  end
end
