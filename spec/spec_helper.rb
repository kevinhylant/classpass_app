require './test_environment.rb'

module RSpecMixin
  include Rack::Test::Methods
  def app() App end
end

RSpec.configure do |c| 
  c.include RSpecMixin
  c.include Rack::Test::Methods
  c.include FactoryGirl::Syntax::Methods 

  c.after(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # c.after(:each) do |example|
  #   DatabaseCleaner.cleaning do
  #     example.run
  #   end
  # end

end