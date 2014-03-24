require 'spec_helper'

describe Employee do
  it {should belong_to :division}
  it {should have_many :contributions}
  it {should have_many :projects}
end
