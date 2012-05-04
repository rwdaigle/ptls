require ::File.expand_path('../config/environment',  __FILE__)
include Clockwork

handler do |job|
  $queue.enqueue(job)
end

every(12.hours, "WordnikWODLoader.load!")