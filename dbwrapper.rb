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
    
    def get_not_deleted_notes
      get_notes().reject{ |note| note.deleted }
    end

    def get_note_with_key(key)
      notes = Note.by_key :key => key
      notes.first
    end

    def get_index
      get_notes
    end

    def update_note(note)
      persistent_note = get_note_with_key note.key
      
      persistent_note.modifydate  = note.modifydate
      persistent_note.content     = note.content
      persistent_note.version    += 1
      persistent_note.syncnumber += 1
      persistent_note.tags        = note.tags
      persistent_note.systemtags  = note.systemtags
      
      persistent_note.save
      
      persistent_note
    end

    def delete_note_with_key(key)
      notes = Note.by_key :key => key
      note = notes.first
      if note
        note.deleted = true
        note.save
        return true
      end
      
      return false
    end

    def create_note(note)
      key = UUID.generate
      note.key = key
      
      id = @database.save_doc(note)
   
      key
    end
  end
end