class Translation < ActiveResource::Base
  
  self.site = "http://ajax.googleapis.com/ajax/services/language/"
  self.logger = ActiveRecord::Base.logger
  self.format = :json
  self.headers['HTTP_REFERER'] = 'http://ptls.yfactorial.com'
  
  class << self
  
    # Translate the given word or phrase frome one language to another
    #   Translation.translate(question, :from => subject.from, :to => subject.to)
    def translate(phrase, opts = {})
      extract_translation(connection.get(path(params(phrase, opts)), headers))
    end
        
    private
    
    # Get the translation from the response
    def extract_translation(response)
      if response && response['responseData'] && response['responseData']['translatedText']
        response['responseData']['translatedText'].downcase
      end
    end      
    
    # Get the hash of params to send for this requested translation
    def params(phrase, opts)
      default_params.merge(:q => phrase, :langpair => "#{opts[:from] || 'en'}|#{opts[:to] || 'it'}")
    end
    
    # The default params that must be sent on every request
    def default_params; { :v => '1.0', :key => key }; end
    
    # The path to query against
    def path(params); "#{site.path}translate#{query_string(params)}"; end
    
    # Key for ryandaigle.com
    def key; 'ABQIAAAAy8pbLvXSAhT6CrI93EHftRRpqnpJsJmfW0aD3J1b_UKiNl32xRQTLRpqK7u0TlMjfg4G06CMTVh47g'; end
    
  end  
end