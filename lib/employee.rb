class Employee < ActiveRecord::Base
  belongs_to(:division)
  has_many :contributions
  has_many :projects, through: :contributions
end
