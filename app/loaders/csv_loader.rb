require 'csv'

class CSVLoader

  class << self

    def load!

      # Get the file to filesystem
      log({event: "csv-import", url: ENV['VOCABULARY_CSV_URL']}) do

        file = "tmp/#{Time.now.utc.to_f}-import.csv"
        `curl -q "#{ENV['VOCABULARY_CSV_URL']}" > #{file}`

        load_csv_file(file)
      end
    end

    def load_csv_file(file)
      vocab = Subject.vocabulary
      CSV.foreach(file) do |row|
        unit = vocab.units.create(question: row[0])
        if(unit && unit.valid?)
          log({event: "csv-import-unit" }, unit, { status: "success" })
        else
          log({event: "csv-import-unit" }, unit, { status: "failure" }, { message: unit.errors.full_messages.join(", ") })
        end
      end
    end
  end
end