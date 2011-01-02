require 'rubygems'
require "bundler/setup"
require 'couchrest'
require 'uuid'
require 'note'
require 'ruby-debug'

module DBWrapper
  class SimplenoteDatabase
    
    def initialize(path)
      raise ArgumentError, "path to database must not be nil" if path.length == 0
    end
    
    def get_notes
      Note.all
    end
    
    def get_not_deleted_notes
      get_notes().reject{ |note| note.deleted == 1 }
    end

    def get_note_with_key(key)
      notes = Note.by_key :key => key
      notes.first
    end

    def get_index
      get_notes
    end

    def delete_note_with_key(key)
      notes = Note.by_key :key => key
      note = notes.first
      if note
        note.deleted = 1
        note.save
        return true
      end
      
      return false
    end

    def create_note(note_hash)
      note_hash['key'] = UUID.generate
      
      note = Note.new note_hash
      note.save   
      
      note.key
    end
  end
end