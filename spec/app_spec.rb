require 'spec_helper'

describe "Homepage" do
  before(:each) do
    get '/'
  end

  xit "returns a 200 status code" do
    expect(last_response.status).to eq(200)
  end
end

describe "Instructor API Endpoint" do
  before(:each) do 
    get '/instructors'
  end
  
  it "returns a JSON file type" do
    expect(last_response.header['Content-Type']).to include('application/json')
  end
end
