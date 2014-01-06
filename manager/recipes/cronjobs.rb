cron 'report_reconcile' do
  minute node[:cron][:report_reconcile][:minutes]
  hour node[:cron][:report_reconcile][:hours]
  command node[:cron][:report_reconcile][:command]
end