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

  context 'GET /spaces/:id' do
    it 'retrieves the individual space page' do
      response = get('/spaces/1')
      expect(response.status).to eq 200
      expect(response.body).to include 'This is my lovely house'

      response = get('/spaces/2')
      expect(response.status).to eq 200
      expect(response.body).to include 'This is my less-lovely shed'

    end
  end

  context 'POST /book-a-space' do
    it 'sends correct parameters' do
      response = post('/book-a-space', {id: 1})
      expect(response.status).to eq 302

      response = get('/spaces/1')
      expect(response.body).to include 'Availability: false'
    end
  end
  
end
