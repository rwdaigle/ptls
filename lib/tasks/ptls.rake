namespace :ptls do
  
  desc "Auto translate the units of the SUBJECT_ID env variable"
  task :translate => :environment do
    subject = Subject.find(ENV['SUBJECT_ID'])
    subject.translate if subject
  end

  desc "Load words from external sources"
  task :load => :environment do
    puts "Enqueuing WordnikWODLoader.load!"
    $queue.enqueue("WordnikWODLoader.load!")
  end
end