require 'rails_helper'

RSpec.describe 'Example', type: :model do
  it 'can use Factory Bot' do
    # This test will pass if Factory Bot is working
    expect(FactoryBot).to be_truthy
  end

  it 'can use Faker' do
    # This test will pass if Faker is working
    expect(Faker::Name.name).to be_a(String)
  end
end 