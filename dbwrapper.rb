require 'rubygems'
require "bundler/setup"
require 'couchrest'
require 'uuid'
require 'note'
require 'ruby-debug'

module DBWrapper
  class SimplenoteDB
    
    def initialize(path)
      raise ArgumentError, "path to database must not be nil" if !path

      @database = CouchRest.new.database!(path)
    end
    
    def get_notes
      Note.all
    end

    def get_note(key)
      Note.by_key key
    end

    def get_index
      get_notes
    end

    def update_note(note)
      persistent_note = Note.by_key note.key
      persistent_note.modifydate  = note.modifydate
      persistent_note.content     = note.content
      persistent_note.version    += 1
      persistent_note.syncnumber +=1
      persistent_note.tags        = note.tags
      persistent_note.systemtags  = note.systemtags
      
      persistent_note.save
      
      persistent_note
    end

    def delete_note(note)

    end

    def create_note(note)
      key = UUID.generate
      note.key = key
      
      id = @database.save_doc(note)
   
      key
    end
  end
end