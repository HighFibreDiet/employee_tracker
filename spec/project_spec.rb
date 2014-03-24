require 'spec_helper'

describe Project do
  it {should have_many :contributions}
  it {should have_many :employees}
end
