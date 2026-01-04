class Section < ApplicationRecord
  include Translatable

  belongs_to :menu
  has_many :menu_items, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  translates :name

  accepts_nested_attributes_for :menu_items, allow_destroy: true

  before_validation :set_default_position, on: :create

  private

  def set_default_position
    return if position.present?
    self.position = menu.sections.maximum(:position).to_i + 1
  end
end
