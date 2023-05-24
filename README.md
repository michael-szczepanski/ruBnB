# RuBnB
RuBnB is an airBnB clone created as part of the Makers Academy course for the purpose of learning test-driven development as part of a team of 6 people to simulate a real life working environment.

## Learning objectives
* Learn to work and communicate effectively as part of a team to build a web application.
* Learn to break down projects into tasks and assign them to pairs.
* Learn to use agile ceremonies to organise your work and improve your processes.
* Learn to use the developer workflow to plan, implement and peer-review features.

## Setup
```zsh
# Install gems
bundle install

# Run the server (might need to use different terminal).
rackup

# Take note of port provided in 'INFO  WEBrick::HTTPServer#start: pid=26468 port=9292' line

# RuBnB can be now accessed through your browser using 
http://localhost:port
# or
http://127.0.0.1:port

# To get details on test coverage:
rspec
rubocop
```

## Built with
#### Main languages used:
* Ruby
  * Object-Oriented lanugage used for to handle majority of our back-end logic
* HTML/CSS
  * Markup language used for documents designed to be displayed in the web browser
* Sinatra
  * Domain-specific language used to map incoming web requests to blocks of Ruby Code
#### Ruby gems:
* Webrick
  * HTTP server toolkit allowing logging of server operations and HTTP access.
* Bcrypt
  * Used for password encryption
* PG
  * Used to interface with PostgreSQL RDBMS
#### Testing environment:
* RSpec
  * Testing tool for Ruby, created for Test Driven Development
* Rubocop
  * Ruby code style checker and formatter based on a community-driven Ruby Style Guide

## Testing coverage
* Testing coverage has been marked at 99.84% accoring to RSpec, with lines missed within `app.rb`.
* Currently, the line `14 DatabaseConnection.connect('rubnb')` cannot be accessed within a testing environment, therefore it is assumed to be working through indirect means of accessing the database through TablePlus an manually confirming that the main database is never accessed or manipulated

## Design documents and changes
* Original table design
  * [Link to table design](design/many-to-many_table_design.md)
  * One of the changes to design that came up throughout the project was a need to split the availability column into 2 separate columns named `available_to` and `available_from`
* Mockup of get and post routes throughout the project
  * [Link to route mockup](design/rubnb-mockup.png)
  * One change not reflected in the initial mockup design of the website was the ability for user to access the homepage regardless of whether or not they are logged in. This has been amended with a change the logic of the `get '/'` route, but has not been reflected in the mockup document.

## Key learning points 
#### What have we gained from the project

## Future developments
#### Which features and changes we would like to implement if we revisit the project, and how would we approach them?
* Formatting of the date on a spaces page to a more user-friendly format
  * This can be done by changing the string form of within the date hash.
* Protection against script injection using CGI class
* Email notifications functionality
  * Using Twilio or an equivalent API
* Chat functionality
* Adding images to your properties

## Credits
* [George Barret]()
* [Sarah Clements]()
* [Will Davies]()
* [Caroline Evans]()
* [Jack Skates]()
* [Michael Szczepanski](URL "https://github.com/michael-szczepanski/ruBnB")
* [Link to project repository](URL "https://github.com/michael-szczepanski/ruBnB")
* Project created as part of the [Makers Academy](URL "https://makers.tech/") software development course