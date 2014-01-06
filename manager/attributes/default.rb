default[:cron][:report_reconcile][:minutes] = '*/2'
default[:cron][:report_reconcile][:hours] = '*'
default[:cron][:report_reconcile][:command] = "cd /srv/www/xpsmanager/current && RAILS_ENV=production bundle exec rake adserver:reports:update --silent"