require_relative '../../app/task/get_earthquake_task'
get_earthquake_task = GetEarthquakeTask.new
get_earthquake_task.async.start if defined?(Rails::Server)
