require_relative '../../app/tasks/get_earthquake_task'
get_earthquake_task = GetEarthquakeTask.new
get_earthquake_task.async.init if defined?(Rails::Server)
