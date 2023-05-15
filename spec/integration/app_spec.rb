require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.


  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')

      expect(response.status).to eq(200)
    end
  end

  context "GET /spaces" do
    it "displays list of all spaces" do
      response = get("/spaces")

      expect(response.status).to eq(200)
      expect(response.body).to include("<title>Spaces | ruBnB</title>")
      expect(response.body).to include("Jack's House")
      expect(response.body).to include("This is my lovely house")
      expect(response.body).to include("Jack's Shed")
      expect(response.body).to include("This is my less-lovely shed")
      expect(response.body).to include("Jill's converted well")
      expect(response.body).to include("Feel like a frog looking at the sky")
    end
  end
end
