require 'spec_helper'

describe "Homepage" do
  before(:each) do
    get '/'
  end

  xit "returns a 200 status code" do
    expect(last_response.status).to eq(200)
  end
end

describe "Completed Classes API Endpoint" do
  let(:user_id) {User.first.id}

  before(:each) do 
    get "/users/#{user_id}/classes/completed"
  end
  
  xit "it returns a valid JSON file type" do
    expect(last_response.header['Content-Type']).to include('application/json')
  end
 
end

describe "Upcoming Classes API Endpoint" do
  let(:user_id) {User.first.id}

  before(:each) do 
    get "/users/#{user_id}/classes/upcoming"
  end
  
  xit "it returns a valid JSON file type" do
    expect(last_response.header['Content-Type']).to include('application/json')
  end
 
end
