require 'rubygems'
require 'bundler/setup'
require 'couchrest_model'

class Note < CouchRest::Model::Base
  use_database CouchRest.database!('simplenote_database_test')
  
  property :key,        String
  property :content,    String
  property :createdate, String
  property :modifydate, String
  property :version,    Integer, :default => 1
  property :syncnumber, Integer, :default => 1
  property :minversion, Integer, :default => 1
  property :deleted,    Integer, :default => 0
  property :tags,       [String]
  property :systemtags, [String]
  
  timestamps!
  
  view_by :key
  view_by :createdate
end