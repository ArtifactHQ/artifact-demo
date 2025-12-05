class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.references :project, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content
      t.string :document_type, default: 'specification'

      t.timestamps
    end

    add_index :documents, [:project_id, :title]
    add_index :documents, :document_type
  end
end
