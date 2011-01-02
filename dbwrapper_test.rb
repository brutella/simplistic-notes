require 'rubygems'
require "bundler/setup"
require 'test/unit'
require 'dbwrapper'
require 'note'

class DBWrapperTest < Test::Unit::TestCase
  
  attr_accessor :database
  
  def setup
    @database = DBWrapper::SimplenoteDatabase.new('simplenote_database_test')
  end
  
  def test_initialize_nil_database
    begin
      @database = DBWrapper::SimplenoteDatabase.new
      fail "ArgumentException expected"
    rescue ArgumentError => e
      # ArgumentError expected
    end
  end

  def test_a_note_creation
    note = Note.new(
      :content => 'A new note',
      :modifydate => Time.now.to_f.to_s,
      :createdate => Time.now.to_f.to_s
      )
    
    key = @database.create_note(note)
    assert_not_nil key
  
    another_key = @database.create_note(note)
    assert_not_nil another_key
    
    assert_not_equal another_key, key
  end

  def test_get_notes
    notes = @database.get_notes
    assert_not_nil notes
  end
  
  def test_get_index
    index = @database.get_index
    assert_not_nil index
  end
  
  def test_not_deleted_notes
    notes = @database.get_not_deleted_notes
    assert notes.length != 0
    
    notes.each do |note|
      assert note.deleted != true
    end
  end
  
  def test_update_note
    notes = @database.get_not_deleted_notes
    assert_not_nil notes
    
    debugger 
    
    note = notes.first
    assert_not_nil note
    
    note.content = "A new content"
    note.modifydate = Time.new.to_f.to_s
    
    tags = ["important", "todo"]
    note.tags = tags
    
    @database.update_note note
    
    updated_note = @database.get_note_with_key note.key

    assert_equal updated_note.content,     note.content
    assert_equal updated_note.modifydate,  note.modifydate
    assert_equal updated_note.tags,        note.tags
  end

  def test_delete_note
    notes = @database.get_not_deleted_notes
    
    key = notes.first.key
    result = @database.delete_note_with_key key
    assert result
    
    note = @database.get_note_with_key key
    assert_not_nil note
    assert note.deleted == true
  end

  def test_delete_note_with_wrong_key
    assert @database.delete_note_with_key('a wrong key') == false
  end
    
end