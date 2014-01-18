include_recipe "rails_helpers::configure"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  # Ensure the application.yml file doesn't exist, so that we can symlink it
  file "#{deploy[:deploy_to]}/current/config/application.yml" do
    action :delete

    only_if do
      deploy[:rails_app][:write_config]
    end
  end

  link "#{deploy[:deploy_to]}/current/config/application.yml" do
    to "#{deploy[:deploy_to]}/shared/config/application.yml"

    only_if do
      ::File.exists?("#{deploy[:deploy_to]}/shared/config/application.yml")
    end
  end

  link "#{deploy[:deploy_to]}/current/config/aws.yml" do
    to "#{deploy[:deploy_to]}/shared/config/aws.yml"

    only_if do
      ::File.exists?("#{deploy[:deploy_to]}/shared/config/aws.yml")
    end
  end

  execute "restart_rails" do
    cwd "#{deploy[:deploy_to]}/current"
    command "sleep #{deploy[:sleep_before_restart]} && #{node[:opsworks][:rails_stack][:restart_command]}"
    action :run

    only_if do 
      File.exists?("#{deploy[:deploy_to]}/current")
    end
  end
end