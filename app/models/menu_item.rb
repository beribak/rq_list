class MenuItem < ApplicationRecord
  include Translatable

  belongs_to :section

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  translates :name, :description

  before_validation :set_default_position, on: :create

  private

  def set_default_position
    return if position.present?
    self.position = section.menu_items.maximum(:position).to_i + 1
  end
end
