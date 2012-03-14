require 'queue_classic'
require 'queue_classic/tasks'
require 'queue_worker'

namespace :queue do

  desc "Custom queue classic worker task"
  task :work  => :environment do
    QueueWorker.new.start
  end
end