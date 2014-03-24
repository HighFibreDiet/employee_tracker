require 'spec_helper'

describe Employee do
  it {should belong_to :division}
  it {should have_and_belong_to_many :projects}
end
