require 'queue_classic'
require 'queue_classic/tasks'
require 'queue_worker'

namespace :jobs do
  task :work  => :environment do
    QueueWorker.new.start
  end
end