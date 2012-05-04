require ::File.expand_path('../config/environment',  __FILE__)
include Clockwork

handler do |job|
  $queue.enqueue(job)
end

every(30.seconds, "WordnikWODLoader.load!")