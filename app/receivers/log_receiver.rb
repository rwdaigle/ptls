class LogReceiver

  class << self

    def receive(log_data)
      if(log_data)
        event_receivers.each do |receiver|
          receiver.call(log_data['action'], log_data)
        end
      end
    end

    def event_receivers
      [

        # EVENT_IMPORT_WOD_WORDNIK_PERFORMANCE
        lambda { |action, log_data|
          if(action == 'wod-import')
            stat_hat_post_performance(StatHatConfig::EVENT_IMPORT_WOD_WORDNIK_PERFORMANCE, log_data)
          end
        },

        # EVENT_IMPORT_EMAIL_PERFORMANCE
        lambda { |action, log_data|
          if(action == 'email-import')
            stat_hat_post_performance(StatHatConfig::EVENT_IMPORT_EMAIL_PERFORMANCE, log_data)
          end
        }
      ]
    end

    def stat_hat_post_performance(event, log_data)
      if(value = log_data['elapsed'])
        Scrolls.log({'action' => 'stathat-post-value', 'event' => event, 'value' => value})
        StatHat::API.ez_post_value(event, ENV['STAT_HAT_KEY'], value)
      end
    end
  end
end