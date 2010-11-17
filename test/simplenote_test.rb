require 'test/unit'
require 'rack/test'
require 'simplenote'

class SimplenoteTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Simplenote::Server
  end

  def auth(path)
    uri = URI.parse path
    uri.query = Rack::Utils.build_query(
      :email => 'test@example.com',
      :auth => '4AD2AB0C69C862309C53B1668271950CA026B11A4501E9E6F59D3617026865C5'
    )
    uri.to_s
  end

  def test_login_success
    body = Base64.encode64 "email=test@example.com&password=Simplenote"
    post '/api/login', {}, {:input => body}
    assert last_response.ok?, "response is ok"
    assert_equal '4AD2AB0C69C862309C53B1668271950CA026B11A4501E9E6F59D3617026865C5', last_response.body
  end

  def test_login_failure
    body = Base64.encode64 "email=test@example.com&password=wrong"
    post '/api/login', {}, {:input => body}
    assert last_response.status == 400
  end

  def test_create_note_bad_auth
    note = {
      'content' => 'Test Note',
      'createdate' => '1283689511.529748',
      'modifydate' => '1289942464.55253'
    }
    post '/api2/data', {}, {:input => note.to_json}
    assert last_response.status == 401
  end

  def test_create_note
    note = {
      'content' => 'Test Note',
      'createdate' => '1283689511.529748',
      'modifydate' => '1289942464.55253'
    }
    post auth('/api2/data'), {}, {:input => note.to_json}
    assert last_response.ok?, "response is ok"

    new_note = JSON.parse(last_response.body)
    assert_equal 'Test Note', new_note['content']
    assert_equal '1283689511.529748', new_note['createdate']
    assert_equal '1289942464.55253', new_note['modifydate']
    assert_equal 1, new_note['version'], "version is initialised"
    assert_equal 1, new_note['minversion'], "minversion is initialised"
    assert_equal 1, new_note['syncnumber'], "syncnum is initialised"
    assert_equal 0, new_note['deleted'], "note is not deleted"
    assert new_note.has_key?('key'), "key is set"
    assert new_note['tags'].empty?, 'tags is empty'
    assert new_note['systemtags'].empty?, 'tags is empty'
  end

  def test_note_bad_auth
    get '/api2/data/note-key'
    assert last_response.status == 401
  end

  def test_note_not_found
    get auth('/api2/data/not-found')
    assert last_response.status == 404
  end

  def test_get_note
    # Create a note
    post auth('/api2/data'), {}, {:input => { 'content' => 'Test Note' }.to_json}
    note = JSON.parse(last_response.body)

    # Retrieve the note
    get auth("/api2/data/#{note['key']}")
    fetched_note = JSON.parse(last_response.body)
    assert last_response.ok?, "response is ok"
    assert_equal note, fetched_note
  end

end
