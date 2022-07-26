# This class represents the connection to the database.
# It allows you to run SQL.

# It has been designed to provide helpful error messages when things go wrong.
# As a result some syntax may be a little unfamiliar. Feel free to dig into it
# if you like, but you don't need to and it's OK if it seems strange.

require 'pg'
require 'rainbow/refinement'

class DatabaseConnection
  using Rainbow

  def self.connect(database_name)
    @host = '127.0.0.1'
    @database_name = database_name
    puts "Connecting to database `#{@database_name}`...".blue unless test_mode?

    if test_mode? && !@database_name.end_with?("_test")
      puts "Refusing to connect to the dev database in test mode.".red
      puts "For your safety, when the tests are running this class will refuse"
      puts "to connect to a database unless its name ends with `_test`."
      puts "You tried to connect to the database `#{database_name}`."
      puts "This is probably a problem with your setup."
      exit
    end

    @connection = PG.connect({ host: @host, dbname: @database_name })
    puts "Connected to the database successfully.".green unless test_mode?
  rescue PG::Error => e
    exit_with_helpful_connection_message(e)
  end

  def self.exec_params(sql, params = [])
    @connection.exec_params(sql, params)
  rescue PG::Error => e
    exit_with_helpful_query_message(e, sql, params)
  end

  private

  def self.exit_with_helpful_connection_message(error)
    puts "I could not connect to the database.".red
    puts "Here is the original error message:"
    puts "  #{error.message}".bold
    puts "  #{generate_backtrace(error)}}"
    if error.message.include? "does not exist"
      puts "My guess: You haven't created the database `#{@database_name}`.".blue
      puts "To do this, run:"
      puts "  createdb #{@database_name}"
    elsif !["localhost", "127.0.0.1", "::1"].include? @host
      puts "My guess: Your database host (`#{@host}`) is not right.".blue
      puts "It should be `localhost`."
    elsif error.message.include? "Connection refused"
      if `which pg_ctl`.empty?
        puts "My guess: You don't have PostgreSQL installed.".blue
        puts "You can install it with:"
        puts "  brew install postgresql"
      else
        puts "My guess: Your local PostgreSQL server is not running.".blue
        puts "You can start it with:"
        puts "  brew services start postgresql"
      end
    end
  ensure
    exit
  end

  def self.exit_with_helpful_query_message(error, sql, fields)
    puts "I got an error when running an SQL query.".red
    puts "Here is the original error message:"
    puts "  #{error.message.strip}".bold
    puts "  #{generate_backtrace(error)}"
    puts "Here is the query that caused the problem:"
    puts "  #{sql}".bold
    puts "Here are the fields:"
    puts "  #{fields}".bold
    if /table .* does not exist/ =~ error.message
      tables = @connection.exec("SELECT table_name FROM information_schema.tables WHERE table_schema='public';")
      if sql.include?("DROP TABLE") && !sql.include?("DROP TABLE IF EXISTS")
        puts "My guess: You are trying to drop a table without IF EXISTS.".blue
        puts "Try adding `IF EXISTS` to your query to ensure it only drops it if necessary."
        puts "Instead of:"
        puts "  #{sql}".bold
        puts "Try:"
        puts "  #{sql.gsub("DROP TABLE", "DROP TABLE IF EXISTS")}".bold
      elsif tables.ntuples.zero?
        puts "My guess: You haven't set up your database tables.".blue
        puts "To set up your database tables, run:"
        puts "  ruby reset_tables.rb"
      else
        puts "My guess: You haven't created the table `#{$1}`.".blue
        puts "Firstly, add the CREATE TABLE command to `reset_tables.rb`:"
        puts "  def reset_tables(db) # Add to this existing method"
        puts "    # ..."
        puts "    db.run(\"DROP IF EXISTS TABLE #{$1};\")"
        puts "    db.run(\"CREATE TABLE #{$1} (id SERIAL PRIMARY KEY, ...);\") # Include your colums here too"
        puts "    # ..."
        puts "  end"
        puts "Then run:"
        puts "  ruby reset_tables.rb"
      end
    elsif /column .* does not exist/ =~ error.message
      puts "My guess: You haven't created the column `#{$1}`.".blue
      puts "To do this, first update your `reset_tables.rb` file to include the column:"
      puts "  def reset_tables(db) # Add to this existing method"
      puts "    # ..."
      puts "    db.run(\"DROP IF EXISTS TABLE #{$1};\")"
      puts "    db.run(\"CREATE TABLE #{$1} (id SERIAL PRIMARY KEY, ...);\") # Include your column here"
      puts "    # ..."
      puts "  end"
      puts "Then run:"
      puts "  ruby reset_tables.rb"
    end
  ensure
    exit
  end

  def self.generate_backtrace(error)
    error.backtrace.reject { |line| line.include?("/gems/") }.join("\n  ")
  end

  def self.test_mode?
    return ENV['ENV'] == 'test'
  end
end