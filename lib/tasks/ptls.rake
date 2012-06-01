namespace :ptls do
  
  # desc "Auto translate the units of the SUBJECT_ID env variable"
  # task :translate => :environment do
  #   subject = Subject.find(ENV['SUBJECT_ID'])
  #   subject.translate if subject
  # end

  desc "Load words from external sources"
  task :load => :environment do
    [WordnikWODLoader].each do |klass|    # CSVLoader
      $queue.enqueue("#{klass.to_s}.load!")
      # klass.load!
    end
  end

  desc "Process un-answered units"
  task :process => :environment do
    $queue.enqueue("Subject.process!", Subject.vocabulary.id)
  end
end