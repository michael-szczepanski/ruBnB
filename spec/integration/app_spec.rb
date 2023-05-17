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
    it 'should redirect to /spaces' do
      response = get('/')

      expect(response.status).to eq(302)
    end
  end
  
   context "GET /spaces" do
    it "displays list of all spaces" do
      response = get("/spaces")

      expect(response.status).to eq(200)
      expect(response.body).to include("Spaces | ruBnB")
      expect(response.body).to include("Jack's House")
      expect(response.body).to include("This is my lovely house")
      expect(response.body).to include("Jack's Shed")
      expect(response.body).to include("This is my less-lovely shed")
      expect(response.body).to include("Jill's converted well")
      expect(response.body).to include("Feel like a frog looking at the sky")
    end
  end

  context 'GET /spaces/new' do
    it 'should return status 200 and form to create new space' do
      response = get('/spaces/new')

      expect(response.status).to eq 200
      expect(response.body).to include('Create your space!')
      expect(response.body).to include('action="/spaces/new" method="POST"')
    end
  end

  context 'GET /signup' do
    it ' Should return status 200 and display sign up form' do
      response = get('/signup')

      expect(response.status).to eq 200
      expect(response.body).to include 'form'
      expect(response.body).to include 'POST'
      expect(response.body).to include '/signup'
    end
  end

  context 'POST /signup' do
    it "Should return status 200 and add a new user to the database" do
      response = post('/signup', { 
        name: "Mike", 
        username: "mike",
        email: "mike@mike.com",
        password: "verysecurepassword" })
      expect(response.status).to eq 302

      response = get('/spaces')
      expect(response.body).to include "Welcome Mike!"
    end
  end

  context 'POST /login' do
    it 'Should allow login with valid credentials' do
      response = post('/login', {
        email: 'jack@email.com',
        password: 'pwtest1'
      })

      expect(response.status).to eq 302

      response = get('/spaces')
      expect(response.body).to include "Welcome Jack!"
    end
  end

  context 'POST /spaces/new' do
    it 'creates a new space' do

      response = post(
        '/spaces/new',
        name: 'treehouse',
        description: 'a lovely treehouse',
        price_per_night: 50.0,
        user_id: 1
      )

      expect(response.status).to eq 302
      
      response = get('/spaces')
      expect(response.body).to include('treehouse')
      expect(response.body).to include('a lovely treehouse')
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
      # TODO: what expectation here?
      # expect(response.body).to include 'Availability: false'
    end
  end

  context 'POST /logout' do
    it 'logs a user out of website' do
      post('/login', {
        email: 'jack@email.com',
        password: 'pwtest1'
      })
      post('/logout')
      response = get('/spaces')
      expect(response.body).not_to include 'Welcome Jack!'
    end
  end
end
