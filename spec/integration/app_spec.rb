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
    it 'if user is logged out show log-in page' do
      response = get('/')

      expect(response.status).to eq 200

      expect(response.body).to include 'Log in'
      expect(response.body).to include 'Welcome to ruBnB'
      expect(response.body).to include 'New to ruBnB? Sign up <a href="/signup">here!</a>'
    end

    it 'if user is logged in it shows the userpage' do
      post('/login', {
        email: 'jack@email.com',
        password: 'pwtest1'
      })

      response = get('/')
      
      expect(response.status).to eq 200

      expect(response.body).to include 'Welcome, Jack!'
      expect(response.body).to include 'Here are your current spaces:'
      expect(response.body).to include "Jack's House"
      expect(response.body).to include "Jack's Shed"
    end
    
    it 'displays the top requested spaces' do
      response = get('/')

      expect(response.status).to eq 200

      expect(response.body).to include "Jack's Shed"
      expect(response.body).to include "Jill's converted well"
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
      post('/login', {
        email: 'jack@email.com',
        password: 'pwtest1'
      })
      
      response = get('/spaces/new')

      expect(response.status).to eq 200
      expect(response.body).to include('Create your space!')
      expect(response.body).to include('action="/spaces/new" method="POST"')
    end
  end

  context 'POST /spaces/new' do
    it 'creates a new space' do
      post('/login', {
        email: 'jack@email.com',
        password: 'pwtest1'
      })

      response = post(
        '/spaces/new',
        name: 'treehouse',
        description: 'a lovely treehouse',
        price_per_night: 50.00,
        available_from: '2023-05-19',
        available_to: '2023-05-23'
      )

      expect(response.status).to eq 302
      
      response = get('/')
      expect(response.body).to include('treehouse')
      expect(response.body).to include('a lovely treehouse')
      expect(response.body).to include ('£50.00')
    end

    it 'does not allow available_to to be earlier than available_from' do
      post('/login', {
        email: 'jack@email.com',
        password: 'pwtest1'
      })

      response = post(
        '/spaces/new',
        name: 'treehouse 2',
        description: 'a lovely treehouse',
        price_per_night: 50.00,
        available_from: '2023-05-25',
        available_to: '2023-05-23'
      )

      expect(response.status).to eq 302
      
      response = get('/spaces')
      expect(response.body).to_not include "treehouse 2"
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

      response = get('/')
      expect(response.body).to include "Welcome, Mike!"
    end
  end

  context 'POST /login' do
    it 'Should allow login with valid credentials' do
      response = post('/login', {
        email: 'jack@email.com',
        password: 'pwtest1'
      })

      expect(response.status).to eq 302

      response = get('/')
      expect(response.body).to include "Welcome, Jack!"
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

  context 'POST /book' do
    it 'sends correct parameters' do
      post('/login', {
        email: 'jill@email.com',
        password: 'pwtest2'
      })

      response = post('/book', {
        date:'2023-05-16', 
        user_id: 2, 
        space_id: 3
        })

      expect(response.status).to eq 302

      response = get('/bookings')
      expect(response.body).to include "Jack's House"
      expect(response.body).to include "Booking date: 16 May 2023"
      expect(response.body).to include "Status: Pending"
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

  context 'GET /bookings' do
    it 'returns a view of bookings Jack has made' do
      post('/login', {
        email: 'jack@email.com',
        password: 'pwtest1'
      })

      response = get('/bookings')

      expect(response.status).to eq 200
      expect(response.body).to include "Jill's converted well" # name of space
      expect(response.body).to include '19 May 2023' # date of booking
      expect(response.body).to include 'Denied' # booking.request_status
    end

    it 'returns a view of booking requests on spaces Jack owns' do
      post('/login', {
        email: 'jack@email.com',
        password: 'pwtest1'
      })

      response = get('/bookings')
      
      expect(response.status).to eq 200
      expect(response.body).to include "Jack's House" # name of space
      expect(response.body).to include '20 May 2023' # date of booking
      expect(response.body).to include 'Pending' # booking.request_status

      expect(response.body).to include "Jack's Shed" # name of space
      expect(response.body).to include '26 May 2023' # date of booking
      expect(response.body).to include 'Pending' # booking.request_status

      expect(response.body).to include "Jack's Shed" # name of space
      expect(response.body).to include '26 May 2023' # date of booking
      expect(response.body).to include 'Pending' # booking.request_status
    end
  end

  context 'POST /confirm' do
    it 'changes booking request_status to confirmed' do
      # log Jack in
      post('/login', {
        email: 'jack@email.com',
        password: 'pwtest1'
      })
      
      # send confirm to all three requests for Jack's spaces
      post('/confirm', {id: 1})
      post('/confirm', {id: 2})
      post('/confirm', {id: 3})
      
      response = get('/bookings')

      # check that none of them are now pending
      expect(response.body).not_to include 'Pending'
    end
  end

  context 'POST /deny' do
    it 'changes booking request_status to denied' do
       # log Jack in
       post('/login', {
        email: 'jack@email.com',
        password: 'pwtest1'
      })
      
      # send deny to all three requests for Jack's spaces
      post('/deny', {id: 1})
      post('/deny', {id: 2})
      post('/deny', {id: 3})
      
      response = get('/bookings')

      # check that none of them are now pending
      expect(response.body).not_to include 'Pending'
    end
  end
end
