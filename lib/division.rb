class Division < ActiveRecord::Base
  has_many(:employees)
  has_many :projects, { :through => :employees }
end
