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

  template "#{deploy[:deploy_to]}/shared/scripts/display_rolling.sh" do
    cookbook 'manager'
    source 'display_rolling.sh.erb'
    mode 0750
    owner deploy[:user]
    group deploy[:group]
    variables(:environment => deploy[:rails_env], :current => "#{deploy[:deploy_to]}/current", :lock => "#{application}_display_rolling_lock")
  end

  cron "#{application}_display_rolling" do
    minute '*/2'
    command "#{deploy[:deploy_to]}/shared/scripts/display_rolling.sh"
  end

  template "#{deploy[:deploy_to]}/shared/scripts/video_rolling.sh" do
    cookbook 'manager'
    source 'video_rolling.sh.erb'
    mode 0750
    owner deploy[:user]
    group deploy[:group]
    variables(:environment => deploy[:rails_env], :current => "#{deploy[:deploy_to]}/current", :lock => "#{application}_video_rolling_lock")
  end

  cron "#{application}_video_rolling" do
    minute '*/2'
    command "#{deploy[:deploy_to]}/shared/scripts/video_rolling.sh"
  end

  template "#{deploy[:deploy_to]}/shared/scripts/centaur_rolling.sh" do
    cookbook 'manager'
    source 'centaur_rolling.sh.erb'
    mode 0750
    owner deploy[:user]
    group deploy[:group]
    variables(:environment => deploy[:rails_env], :current => "#{deploy[:deploy_to]}/current", :lock => "#{application}_centaur_rolling_lock")
  end

  cron "#{application}_centaur_rolling" do
    minute '*/5'
    command "#{deploy[:deploy_to]}/shared/scripts/centaur_rolling.sh"
  end

  template "#{deploy[:deploy_to]}/shared/scripts/scope_rolling.sh" do
    cookbook 'manager'
    source 'scope_rolling.sh.erb'
    mode 0750
    owner deploy[:user]
    group deploy[:group]
    variables(:environment => deploy[:rails_env], :current => "#{deploy[:deploy_to]}/current", :lock => "#{application}_scope_rolling_lock")
  end

  cron "#{application}_scope_rolling" do
    minute '*/5'
    command "#{deploy[:deploy_to]}/shared/scripts/scope_rolling.sh"
  end

  template "#{deploy[:deploy_to]}/shared/scripts/display_daily.sh" do
    cookbook 'manager'
    source 'display_daily.sh.erb'
    mode 0750
    owner deploy[:user]
    group deploy[:group]
    variables(:environment => deploy[:rails_env], :current => "#{deploy[:deploy_to]}/current", :lock => "#{application}_display_daily_lock")
  end

  cron "#{application}_display_daily" do
    minute '0'
    hour '8'
    command "#{deploy[:deploy_to]}/shared/scripts/display_daily.sh"
  end

  template "#{deploy[:deploy_to]}/shared/scripts/video_daily.sh" do
    cookbook 'manager'
    source 'video_daily.sh.erb'
    mode 0750
    owner deploy[:user]
    group deploy[:group]
    variables(:environment => deploy[:rails_env], :current => "#{deploy[:deploy_to]}/current", :lock => "#{application}_video_daily_lock")
  end

  cron "#{application}_video_daily" do
    minute '0'
    hour '8'
    command "#{deploy[:deploy_to]}/shared/scripts/video_daily.sh"
  end
end