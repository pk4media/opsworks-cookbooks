include_recipe "manager::configure"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  # Ensure the application.yml file doesn't exist, so that we can symlink it
  file "#{deploy[:deploy_to]}/current/config/application.yml" do
    force_unlink true
    action :delete
  end

  link "#{deploy[:deploy_to]}/current/config/application.yml" do
    to "#{deploy[:deploy_to]}/shared/config/application.yml"

    only_if do
      ::File.exists?("#{deploy[:deploy_to]}/shared/config/application.yml")
    end
  end
end