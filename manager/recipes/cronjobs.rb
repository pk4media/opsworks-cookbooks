node[:deploy].each do |application, deploy|
  template "#{deploy[:deploy_to]}/shared/scripts/report_reconcile.sh" do
    cookbook 'manager'
    source 'report_reconcile.sh.erb'
    mode '0750'
    owner deploy[:user]
    group deploy[:group]
    variables(:environment => deploy[:rails_env], :current => "#{deploy[:deploy_to]}/current", :lock => "#{application}_report_reconcile_lock")
  end

  cron "#{application}_report_reconcile" do
    minute node[application][:cron][:report_reconcile][:minutes]
    hour node[application][:cron][:report_reconcile][:hours]
    command "#{deploy[:deploy_to]}/shared/scripts/report_reconcile.sh"
  end
end