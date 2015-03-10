# RSpec.configure do |config|
#   config.include FactoryGirl::Syntax::Methods

#   config.before(:suite) do
#     begin
#       DatabaseCleaner.start
#       FactoryGirl.lint
#     ensure
#       DatabaseCleaner.clean
#     end
#   end
# end

# FactoryGirl.define do
#   factory :user do
#     first_name "John"
#     last_name  "Doe"
#   end

#   # This will use the User class (Admin would have been guessed)
#   factory :instructor, class: User do
#     first_name "Leanne"
#     last_name  "Weiner"
#   end
# end

# Returns a saved User instance
# user = create(:user)

# create(:user) do |user|
#   user.posts.create(attributes_for(:post))
# end


# factory :user do
#   # ...
#   activation_code { User.generate_activation_code }
#   date_of_birth   { 21.years.ago }
# end


# factory :user do
#   first_name "Joe"
#   last_name  "Blow"
#   email { "#{first_name}.#{last_name}@example.com".downcase }
# end

# create(:user, last_name: "Doe").email
# => "joe.doe@example.com"

# factory :post do
#   title "A title"

#   factory :approved_post do
#     approved true
#   end
# end

# approved_post = create(:approved_post)
# approved_post.title    # => "A title"
# approved_post.approved # => true

# Sometimes, you'll want to create or build multiple instances of a factory at once.

# built_users   = build_list(:user, 25)
# created_users = create_list(:user, 25)

# Cucumber
# World(FactoryGirl::Syntax::Methods)
