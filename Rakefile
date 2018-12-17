require 'rake/testtask'
require 'rubocop/rake_task'

task default: 'test'

RuboCop::RakeTask.new

Rake::TestTask.new do |task|
  task.pattern = 'test/**/*_test.rb'
end
