require 'sqlite3'

db = SQLite3::Database.new '../db/hakase.db'

db.execute('CREATE TABLE readlog(id INTEGER PRIMARY KEY, usr_id TEXT, pp_url TEXT, pp_title TEXT)')
