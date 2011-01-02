require 'rubygems'
require "bundler/setup"
require 'test/unit'
require 'dbwrapper'
require 'note'

class DBWrapperTest < Test::Unit::TestCase
  
  attr_accessor :database
  
  def setup
    @database = DBWrapper::SimplenoteDB.new("simplenote_database_test")
  end

  def test_initialize_nil_database
    begin
      @database = DBWrapper::SimplenoteDB.new
      fail "ArgumentException expected"
    rescue ArgumentError => e
      # ArgumentError expected
    end
  end


  def test_get_notes
    notes = Note.all
    assert_not_nil notes
  end
  
  def test_get_index
  index = @database.get_index
  assert_not_nil index
  end
  
  def test_create_note
    note = Note.new(
      :content => 'A new note',
      :modifydate => Time.now.to_f.to_s,
      :createdate => Time.now.to_f.to_s
      )
    
    key = @database.create_note(note)
    assert_not_nil key
  end
    
end