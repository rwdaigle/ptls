

namespace :ptls do
  
  desc "Auto translate the units of the SUBJECT_ID env variable"
  task :translate => :environment do
    subject = Subject.find(ENV['SUBJECT_ID'])
    subject.translate if subject
  end

  desc "Load words from external sources"
  task :load => :environment do
    [WordnikWODLoader, CSVLoader].each do |klass|
      klass.load!
    end
  end
end