web: bundle exec thin start -p $PORT -e $RACK_ENV
worker: bundle exec rake qc:work
#clock: bundle exec clockwork clock.rb