require 'rubygems'
require 'couchrest_model'

class Note < CouchRest::Model::Base
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
  
  view_by :key
end