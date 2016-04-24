# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# CLI MEMO
# ./bin/bundle exec wheneverize .
# ./bin/bundle exec whenever --update-cron
# ./bin/bundle exec whenever --update-cron --set 'environment=development'
# ./bin/bundle exec whenever --clear-cron

every 10.minute do
  runner 'AnimateWorker.task'
  runner 'ChnicovideoWorker.task'
  runner 'OnsenWorker.task'
  runner 'AgonWorker.task'
end

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
