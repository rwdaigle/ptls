require 'active_support/concern'

module EventLogger

  extend ActiveSupport::Concern

  module ClassMethods

    def log_context(*segments, &block)
      Scrolls.context(log_data_from(*segments), &block)
    end

    def log(*segments, &block)
      log_data = log_data_from(*segments)

      # Would use Scrolls to execute block but wouldn't have 'elapsed' in log_data for log receivers
      if block_given?
        elapsed_ms = Benchmark.ms { yield }
        log_data.merge!({ 'elapsed' => elapsed_ms.round(2) })
      end

      Scrolls.log(log_data)
      $queue.enqueue('LogReceiver.receive', log_data) # Send it off for archival, forwarding, whatever.
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