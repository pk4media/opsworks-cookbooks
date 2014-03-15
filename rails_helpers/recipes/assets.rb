node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "rake assets:precompile" do
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle exec rake assets:precompile"
    environment "RAILS_ENV" => deploy[:rails_env]
    user deploy[:user]
    action :run
  end

  execute "restart_rails" do
    cwd "#{deploy[:deploy_to]}/current"
    command "sleep #{deploy[:sleep_before_restart]} && #{node[:opsworks][:rails_stack][:restart_command]}"
    user deploy[:user]
    action :run

    only_if do 
      File.exists?("#{deploy[:deploy_to]}/current")
    end
  end
end