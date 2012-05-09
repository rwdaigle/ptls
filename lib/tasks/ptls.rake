require 'csv'

namespace :ptls do
  
  desc "Auto translate the units of the SUBJECT_ID env variable"
  task :translate => :environment do
    subject = Subject.find(ENV['SUBJECT_ID'])
    subject.translate if subject
  end

  desc "Load words from external sources"
  task :load => :environment do
    # puts "Enqueuing WordnikWODLoader.load!"
    # $queue.enqueue("WordnikWODLoader.load!")
    WordnikWODLoader.load!(Date.today)
  end

  desc "Import words from the csv file located at VOCABULARY_CSV_URL"
  task :import => :environment do

    # Get the file to filesystem
    Object.log({event: "ptls:import", file: ENV['VOCABULARY_CSV_URL']}) do
      # Rails.logger.info "Importing words from #{ENV['VOCABULARY_CSV_URL']}"
      file = "tmp/#{Time.now.utc.to_i}-import.csv"
      `curl "#{ENV['VOCABULARY_CSV_URL']}" > #{file}`

      # Parse
      vocab = Subject.vocabulary
      CSV.foreach(file) do |row|
        vocab.units.create(question: row[0])
      end
    end
  end
end