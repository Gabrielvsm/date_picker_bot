require 'sqlite3'
require_relative '../env'

def db
    db = SQLite3::Database.open Env::DB_PATH
    db.results_as_hash = true

    db
end
