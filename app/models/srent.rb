class Srent < ActiveRecord::Base
  belongs_to :user
  has_many :srent_times
  belongs_to :semester
end
