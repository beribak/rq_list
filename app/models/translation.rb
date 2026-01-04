class Translation < ApplicationRecord
  belongs_to :translatable, polymorphic: true

  validates :field_name, presence: true
  validates :locale, presence: true
  validates :content, presence: true
  validates :field_name, uniqueness: { scope: [ :translatable_type, :translatable_id, :locale ] }
end
