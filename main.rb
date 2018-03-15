require 'sinatra'
require 'sqlite3'
require 'securerandom'

db = SQLite3::Database.new 'db/hakase.db'
db.results_as_hash = true

get '/' do
	erb :index
end

get '/log_input_form' do
		
end

post '/log_input' do

end
