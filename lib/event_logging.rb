require 'active_support/concern'

module EventLogger

  extend ActiveSupport::Concern

  module ClassMethods

    def hiya; puts "hiya"; end

    def log(*segments, &block)
      ms = Benchmark.ms { yield } if block_given?
      log_data = default_log_data
      call_log_data = segments.inject({}) do |map, segment|
        map.merge!(segment.to_log)
      end
      log_data.merge!(call_log_data)
      log_data.merge!(duration: ms.round(3)) if block_given?
      event_logger.info(log_data.to_json)
    end

    private

    def default_log_data
      { timestamp: Time.now.utc.to_f, caller: called_from(2) }
    end

    def called_from(depth=1)
      caller_method = parse_caller(caller(depth+1).first).last
      klass = self.is_a?(Class) ? self.to_s : self.class.to_s
      "#{klass}##{caller_method}"
    end

    # Stolen from ActionMailer, where this was used but was not made reusable
    def parse_caller(at)
      if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
        file   = Regexp.last_match[1]
        line   = Regexp.last_match[2].to_i
        method = Regexp.last_match[3]
        [file, line, method]
      end
    end

    def event_logger
      Rails.logger
    end
  end

  # def log(*tokens, &block)
  #   ms = Benchmark.ms { yield } if block_given?
  #   token_str = tokens.collect do |token|
  #     token.respond_to?(:to_log) ? token.to_log : token.to_s
  #   end.join(' ')
  #   execution = ms ? "execution=#{ms.round(3)}ms" : nil
  #   klass = self.is_a?(Class) ? self : self.class
  #   self.class.event_logger.info "[#{klass}] event=#{self.class.caller_method} #{token_str} #{execution}"
  # end
end

class Hash

  def to_log
    self
  end
end

class Object
  include EventLogger
end