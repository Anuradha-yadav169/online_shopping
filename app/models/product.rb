class Product < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :orders, through: :line_items
  has_many_attached :images

  def self.search(search)
    where('name LIKE ?', "%#{search}%")
  end
end
