require 'queue_classic'

class QueueWorker < QC::Worker

  def handle_failure(job, exception)
    logger.error "[Queue] event=error job=#{job.inspect} message=\"#{exception.message}\""
    logger.error "[Queue] event=error backtrace=#{exception.backtrace}"
  end

  def logger
    ActiveRecord::Base.logger
  end
end