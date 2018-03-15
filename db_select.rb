require 'sqlite3'

db = SQLite3::Database.new 'db/hakase.db'

p db.execute('SELECT * FROM readlog')
