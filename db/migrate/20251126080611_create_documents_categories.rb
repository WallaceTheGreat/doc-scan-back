class CreateDocumentsCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :documents_categories, id: false do |t|
      t.references :document, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE documents_categories
      ADD PRIMARY KEY (document_id, category_id);
    SQL
  end
end
