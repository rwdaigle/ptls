require 'csv'

class Loader
  
  class << self
    
    def import(file)
      CSV::Reader.parse(File.open(file)).each do |row|
        RAILS_DEFAULT_LOGGER.info "Importing #{row[0]}"
        add_language_unit(row[0], row[1]) if not row[0].nil?
      end
    end    
  
    # Add this question to all languages
    def add_language_unit(question, answer)
      Subject.add_language_unit(question, answer)
    end
    
  end
end