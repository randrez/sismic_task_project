require_relative '../../app/task/get_feature_task'
get_feature_task = GetFeatureTask.new
get_feature_task.async.start if defined?(Rails::Server)
