class Menu < ApplicationRecord
  belongs_to :user
  has_many :sections, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  accepts_nested_attributes_for :sections, allow_destroy: true
end
