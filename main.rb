require 'sinatra'
require 'sqlite3'
require 'securerandom'
require 'sinatra/reloader'
require 'mechanize'

db = SQLite3::Database.new 'db/hakase.db'
db.results_as_hash = true

get '/test' do
  "Hello World!!"
end

get '/' do
	erb :index
end

post '/index_post' do
	redirect 'log_search_form'
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
	search_key = params['usr_id']
	#readlog = db.execute('SELECT * FROM readlog')
	#p readlog[0][0].to_s 
	result = db.execute('SELECT * FROM readlog WHERE usr_id="' + search_key + '"')
	locals = {
		search_key: search_key,
		result: result
	}
	erb :log_search_form_post, :locals => locals
end

get '/grp_usr_check' do
	locals = {
		grp_usr: db.execute('SELECT * FROM grp_usr')
	}
	erb :grp_usr_check, :locals => locals
end

get '/grp_input_form' do
	grp_usr = db.execute('SELECT * FROM grp_usr')
	locals = {	
		grp_usr: grp_usr
	}
	erb :grp_input_form, :locals => locals
end

post '/grp_input_form_post' do
	grp_id = params['grp_id']
	usr_id = params['usr_id']
	db.execute('INSERT INTO grp_usr(grp_id, usr_id) VALUES("' + grp_id + '", "' + usr_id + '")')

	redirect '/grp_input_form'
end

#search all group that a person joins
get '/grp_search_form' do
	erb :grp_search_form
end

post '/grp_search_form_post' do
	search_key = params['usr_id']
	result = db.execute('SELECT * FROM grp_usr WHERE usr_id="' + search_key + '"')
	locals = {
		search_key: search_key,
		result: result
	}
	erb :grp_search_form_post, :locals => locals
end

get '/grp_tl' do
	grp_id = params['grp_id']
	#grp_id = "sikilab"
	#grp_usr = db.execute('SELECT * FROM grp_usr WHERE grp_id="' + grp_id + '"')
	
	readlog = db.execute('SELECT * FROM readlog WHERE usr_id IN (
						 SELECT usr_id FROM grp_usr WHERE grp_id="' + grp_id + '"
						)')
	locals = {
		#grp_usr: grp_usr,
		readlog: readlog
	}
	erb :grp_tl, :locals => locals
end

get '/smr' do
	#pp_url = "https://www.nature.com/articles/1811199a0"
	pp_url = params['pp_url']
	gs_url = 'https://scholar.google.co.jp/scholar?q='+pp_url
	#URL = 'https://scholar.google.co.jp/scholar?q=https://www.nature.com/articles/1811199a0'

	agent = Mechanize.new
	page = agent.get(gs_url)

	elements = page.search(".//div[@class='gs_ri']")
	#elements = page.search('title')
	title = page.search(".//h3[@class='gs_rt']")
	author = page.search(".//div[@class='gs_a']")
	abstract = page.search(".//div[@class='gs_rs']")
	#elements.inspect
	
	locals = {
		elements: elements,
		title: title,
		author: author,
		abstract: abstract,
		gs_url: gs_url
	}

	erb :smr, :locals => locals
end
