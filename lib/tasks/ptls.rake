namespace :ptls do
  
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