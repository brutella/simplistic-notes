require 'rubygems'
require 'bundler/setup'
require 'couchrest_model'

class Note < CouchRest::Model::Base
  use_database CouchRest.database!('http://localhost:5984/simplenote_database_test')
  
  property :key,        String
  property :content,    String
  property :createdate, String
  property :modifydate, String
  property :version,    Integer
  property :syncnumber, Integer
  property :minversion, Integer
  property :deleted,    Integer
  property :tags,       [String]
  property :systemtags, [String]
  
  timestamps!
  
  view_by :key
  view_by :createdate
end