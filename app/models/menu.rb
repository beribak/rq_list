class Menu < ApplicationRecord
  include Translatable

  belongs_to :user
  has_many :sections, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  translates :name, :description

  accepts_nested_attributes_for :sections, allow_destroy: true
end
