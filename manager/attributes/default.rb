default[:cron][:report_reconcile][:minutes] = '0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58'
default[:cron][:report_reconcile][:hours] = '*'
default[:cron][:report_reconcile][:command] = "cd /srv/www/xpsmanager/current && RAILS_ENV=production bundle exec rake adserver:reports:update --silent"