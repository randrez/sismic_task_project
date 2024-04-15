require_relative '../../app/task/get_features_task'
get_feature_task = GetFeaturesTask.new
get_feature_task.async.start if defined?(Rails::Server)
