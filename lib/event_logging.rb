require 'active_support/concern'

module EventLogger

  extend ActiveSupport::Concern

  module ClassMethods

    def log(*segments, &block)
      call_log_data = segments.inject({}) do |map, segment|
        map.merge!(segment.to_log)
      end
      Scrolls.log(call_log_data, &block)
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