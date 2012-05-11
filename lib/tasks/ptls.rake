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
    Object.log({caller: "ptls.rake#import", event: "csv-import", file: ENV['VOCABULARY_CSV_URL']}) do

      file = "tmp/#{Time.now.utc.to_i}-import.csv"
      `curl "#{ENV['VOCABULARY_CSV_URL']}" > #{file}`

      # Parse
      vocab = Subject.vocabulary
      CSV.foreach(file) do |row|
        unit = vocab.units.create(question: row[0])
        if(unit && unit.valid?)
          Object.log({caller: "ptls.rake#import", event: "csv-import-unit" }, unit, { status: "success" })
        else
          Object.log({caller: "ptls.rake#import", event: "csv-import-unit" }, unit, { status: "failure" }, { message: unit.errors.full_messages.join(", ") })
        end
      end
    end
  end
end