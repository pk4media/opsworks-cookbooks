default[:cron][:report_reconcile][:minutes] = '*/1'
default[:cron][:report_reconcile][:hours] = '*'

include_attribute "manager::config"