class Question < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
end