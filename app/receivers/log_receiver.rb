class LogReceiver

  class << self

    def receive(log_data)
      if Rails.env.production?
        if(log_data)
          receivers.each do |receiver|
            receiver.call(log_data['action'], log_data)
          end
        end
      end
    end

    def receivers
      [
        lambda { |action, log_data|
          stat_hat_post_performance(action, log_data)
          stat_hat_post_increment(action)
        }
      ]
    end

    def stat_hat_post_performance(event, log_data)
      if(value = log_data['elapsed'])
        Scrolls.log({'action' => 'stathat-post-value', 'event' => event, 'value' => value})
        StatHat::API.ez_post_value("#{event} Performance", ENV['STAT_HAT_KEY'], value)
      end
    end

    def stat_hat_post_increment(event, increment = 1)
      Scrolls.log({'action' => 'stathat-post-counter', 'event' => event, 'value' => increment})
      StatHat::API.ez_post_count("#{event} Count", ENV['STAT_HAT_KEY'], increment)
    end
  end
end