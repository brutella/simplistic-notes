require 'rubygems'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['*_test.rb']
  t.ruby_opts = ['-rubygems -I.'] if defined? Gem
end
