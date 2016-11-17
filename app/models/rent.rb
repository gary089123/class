class Rent < ActiveRecord::Base
  # 必填
  validates_presence_of :semester_id, :name, :teacher, :phone, :email, :facility

  belongs_to :user
  has_many :rent_times
  belongs_to :semester
end
