require 'rails_helper'

RSpec.describe User, type: :model do
  it "should exist" do
    user = User.new
    expect(user).to be_a User
  end
end
