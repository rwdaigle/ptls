require 'csv'

class CSVLoader

  class << self

    def load!
      log({event: "csv-import", url: ENV['VOCABULARY_CSV_URL']}) do

        file = "tmp/#{Time.now.utc.to_f}-import.csv"
        `curl -q "#{ENV['VOCABULARY_CSV_URL']}" > #{file}`
          
        CSV.foreach(file) do |row|
          Subject.add_vocabulary_word(row[0])
        end
      end
    end
  end
end