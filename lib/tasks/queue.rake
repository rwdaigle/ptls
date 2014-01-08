require 'queue_classic'
require 'queue_classic/tasks'
require 'queue_worker'

namespace :queue do

  desc "Custom queue classic worker task"
  task :work  => :environment do
    QueueWorker.new.start
  end

  desc "Work through the queue and exit when all jobs have been processed"
  task :work_then_exit  => :environment do
    worker = QueueWorker.new
    $queue.count.times { worker.work }
    end
  end
end