require 'sinatra'
require 'sqlite3'
require 'securerandom'

db = SQLite3::Database.new 'db/hakase.db'
db.results_as_hash = true

get '/' do
	erb :index
end

get '/log_input_form' do
	readlog = db.execute('SELECT * FROM readlog')
	locals = {	
		readlog: readlog
	}
	erb :log_input_form, :locals => locals
end

post '/log_input_form_post' do
	usr_id = params['usr_id']
	pp_url = params['pp_url']
	pp_title = params['pp_title']

	db.execute('INSERT INTO readlog(usr_id, pp_url, pp_title) VALUES("' + usr_id + '", "' + pp_url + '", "' + pp_title + '")')

	redirect '/log_input_form'
end

get '/readlog_check' do
	locals = {
		readlog: db.execute('SELECT * FROM readlog')
	}
	erb :readlog_check, :locals => locals
end

get '/log_search_form' do
	erb :log_search_form
end

post '/log_search_form_post' do
	#search_key = params['usr_id']
	readlog = db.execute('SELECT * FROM readlog')
	p readlog[0][0].to_s
	##p db.execute('SELECT * FROM readlog WHERE usr_id="' + search_key + '"')
end
