require 'acts_as_timed'
# Learning.class_eval { include ActsAsTimed }
ActiveRecord::Base.class_eval { include ActiveRecord::ActsAsTimed }