class DocumentsCategory < ApplicationRecord
  belongs_to :doc
  belongs_to :cat
end
