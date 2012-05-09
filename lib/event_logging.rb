require 'active_support/concern'

module EventLogger

  extend ActiveSupport::Concern

  module ClassMethods

    def hiya; puts "hiya"; end

    def log(*segments, &block)
      ms = Benchmark.ms { yield } if block_given?
      log_values = { klass: (self.is_a?(Class) ? self.to_s : self.class.to_s), event: self.caller_method }
      segment_values = segments.inject({}) do |map, segment|
        map.merge!(segment.to_log)
      end
      log_values.merge!(segment_values)
      log_values.merge!(execution: ms.round(3)) if block_given?
      event_logger.info(log_values.to_json)
    end

    def caller_method(depth=1)
      parse_caller(caller(depth+1).first).last
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

  def log(*tokens, &block)
    ms = Benchmark.ms { yield } if block_given?
    token_str = tokens.collect do |token|
      token.respond_to?(:to_log) ? token.to_log : token.to_s
    end.join(' ')
    execution = ms ? "execution=#{ms.round(3)}ms" : nil
    klass = self.is_a?(Class) ? self : self.class
    self.class.event_logger.info "[#{klass}] event=#{self.class.caller_method} #{token_str} #{execution}"
  end
end

class Hash

  def to_log
    self
  end
end

class Object
  include EventLogger
end