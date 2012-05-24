require 'active_support/concern'

module EventLogger

  extend ActiveSupport::Concern

  module ClassMethods

    def log_context(*segments, &block)
      Scrolls.context(log_data_from(*segments), &block)
    end

    def log(*segments, &block)
      Scrolls.log(log_data_from(*segments), &block)
    end

    private

    def log_data_from(*segments)
      segments.inject({}) do |map, segment|
        map.merge!(segment.to_log)
      end
    end

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