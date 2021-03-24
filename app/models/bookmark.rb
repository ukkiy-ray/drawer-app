class Bookmark < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 50 }
  validates :category, presence: true, length: { maximum: 50 }

  with_options presence: true do
    validates :url, format: {with: /\A#{URI::regexp(%w(http https))}\z/}
  end
end
