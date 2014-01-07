node[:deploy].each do |application, deploy|
  template "#{deploy[:deploy_to]}/shared/config/application.yml" do
    Chef::Log.debug "Adding application config for #{application}"
    cookbook 'server'
    source 'application.yml.erb'
    mode '0640'
    owner deploy[:user]
    group deploy[:group]
    variables(:environment => deploy[:rails_env], :config => deploy[:manager][:config])
  end
end