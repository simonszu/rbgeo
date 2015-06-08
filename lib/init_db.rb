# Connects and initializes the database

def init_db ()

  # Connect to DB
  begin
    # If there is no database file, create it
    if !File.file?(GC_CACHEDB)
      SQLite3::Database.new GC_CACHEDB
    end
    # Let ActiveRecord connect to the db
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => GC_CACHEDB)
  rescue SQLite3::Exception => e
    puts "Fehler beim Zugriff oder Anlegen der Datenbank."
    puts e
    puts "In den meisten Fällen reicht es, das Datenbankfile #{GC_CACHEDB} zu löschen, und alle Caches erneut einzulesen."
    exit
  end

  # Initialize the DB if not already done
  # Table for caches we don't own
  ActiveRecord::Schema.define do 
    unless ActiveRecord::Base.connection.tables.include? 'caches'
      puts "Initializing database..."
      create_table :caches do |table|
        table.column :gcid, :string
        table.column :name, :string
        table.column :owner, :string
        table.column :cachetype, :string
        table.column :size, :string
        table.column :difficulty, :double
        table.column :terrain, :double
        table.column :coords, :string
        table.column :area, :string
        table.column :hiddendate, :integer
        table.column :status, :string
        table.column :favcount, :integer
        table.column :guid, :string
        table.column :logtype, :string
        table.column :logdate, :integer
        table.column :favorite, :integer
        table.column :log, :text
      end
      puts "Database initialized!"
    end  
  end

  # Table for caches owned
  ActiveRecord::Schema.define do 
    unless ActiveRecord::Base.connection.tables.include? 'caches'
      puts "Initializing database..."
      create_table :ownedcaches do |table|
        table.column :gcid, :string
        table.column :name, :string
        table.column :owner, :string
        table.column :cachetype, :string
        table.column :size, :string
        table.column :difficulty, :double
        table.column :terrain, :double
        table.column :coords, :string
        table.column :area, :string
        table.column :hiddendate, :integer
        table.column :status, :string
        table.column :favcount, :integer
        table.column :guid, :string
        table.column :logtype, :string
        table.column :logdate, :integer
        table.column :favorite, :integer
        table.column :log, :text
      end
      puts "Database initialized!"
    end  
  end
end

# Here be models, necessary for using ActiveRecord
class Cache < ActiveRecord::Base
end

class Ownedcache < ActiveRecord::Base
end