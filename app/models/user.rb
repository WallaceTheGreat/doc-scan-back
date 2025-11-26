class User < ApplicationRecord
  has_many :documents, foreign_key: :created_by
end
