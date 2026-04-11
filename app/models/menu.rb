class Menu < ApplicationRecord
  TEMPLATES = {
    "neon_noir" => {
      accent: "#35f98f",
      surface: "#061118"
    },
    "rouge_blanc" => {
      accent: "#ff3b3b",
      surface: "#fff8f6"
    },
    "electric_blue" => {
      accent: "#36d7ff",
      surface: "#071422"
    },
    "champagne_gold" => {
      accent: "#d6a94f",
      surface: "#fff9ef"
    }
  }.freeze

  include Translatable

  belongs_to :user
  has_many :sections, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :template_key, inclusion: { in: TEMPLATES.keys }

  translates :name, :description

  accepts_nested_attributes_for :sections, allow_destroy: true

  def template_config
    TEMPLATES.fetch(template_key, TEMPLATES["neon_noir"])
  end
end
