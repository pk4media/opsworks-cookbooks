node[:deploy].each do |application, deploy|
  default[application][:cron][:report_reconcile][:minutes] = '*/1'
  default[application][:cron][:report_reconcile][:hours] = '*'
end

include_attribute "manager::config"