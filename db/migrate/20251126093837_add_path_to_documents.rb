class AddPathToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :documents, :path, :string
  end
end
