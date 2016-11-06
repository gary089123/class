class Rent < ActiveRecord::Base
  # 必填
  validates :name, presence: true

  belongs_to :user
  has_many :rent_times
  belongs_to :semester
end
