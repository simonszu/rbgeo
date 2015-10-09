# Connects and initializes the database

def init_db ()

  # Connect to DB
  begin
    # If there is no database file, create it
    if !File.file?(CACHEDB)
      SQLite3::Database.new CACHEDB
    end
    # Let ActiveRecord connect to the db
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => CACHEDB)
  rescue SQLite3::Exception => e
    puts "Fehler beim Zugriff oder Anlegen der Datenbank."
    puts e
    puts "In den meisten Fällen reicht es, das Datenbankfile #{GC_CACHEDB} zu löschen, und alle Caches erneut einzulesen."
    exit
  end

  # Initialize the DB if not already done
  # Table for caches we don't own
  ActiveRecord::Schema.define do
    unless ActiveRecord::Base.connection.tables.include? 'gcaches'
      puts "Initializing database for not owned caches..."
      create_table :gcaches do |table|
        table.column :gcid, :string
        table.column :name, :string
        table.column :owner, :string
        table.column :owner_guid, :string
        table.column :type, :string
        table.column :size, :string
        table.column :difficulty, :double
        table.column :terrain, :double
        table.column :coords_lat, :string
        table.column :coords_lon, :string
        table.column :country, :string
        table.column :region, :string
        table.column :hiddendate, :integer
        table.column :status, :string
        table.column :favcount, :integer
        table.column :guid, :string
        table.column :logtype, :string
        table.column :found, :integer
        table.column :dnf, :integer
        table.column :logdate, :integer
        table.column :favorite, :integer
        table.column :log, :text
      end
      puts "Database initialized!"
    end
  end

  # Table for caches owned
  ActiveRecord::Schema.define do
    unless ActiveRecord::Base.connection.tables.include? 'gownedcaches'
      puts "Initializing database for owned caches..."
      create_table :gownedcaches do |table|
        table.column :name, :string
        table.column :status, :string
        table.column :guid, :string
        table.column :type, :string
      end
      puts "Database initialized!"
    end
  end
end

# Here be models, necessary for using ActiveRecord
class Gcache < ActiveRecord::Base
  self.inheritance_column = :inheritance_type
end

class Gownedcache < ActiveRecord::Base
  self.inheritance_column = :inheritance_type
end
