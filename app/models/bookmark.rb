class Bookmark < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :url, presence: true, length: { maximum: 200 }
  validates :category, presence: true, length: { maximum: 50 }
end
