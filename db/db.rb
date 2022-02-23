require 'sqlite3'

def db
  db = SQLite3::Database.open ENV['DPB_DB_PATH']
  db.results_as_hash = true

  db
end
