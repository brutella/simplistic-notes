require 'rubygems'
require 'couchrest'
require 'uuid'

module DBWrapper
  class SimplenoteDB
    
    def initialize(path)
      raise ArgumentError, "path to database must not be nil" if !path

      @database = CouchRest.new.database!(path)
    end
    
    def get_notes
      documents = @database.documents
      documents.each do |document|
        puts document
      end
    end

    def get_note(key)
      
    end

    def get_index
      get_notes
    end

    def update_note(note)

    end

    def delete_note(note)

    end

    def create_note(note)
      key = UUID.generate
      note['key'] = key
      
      id = @database.save_doc(note)
            
      key
    end
  end
end