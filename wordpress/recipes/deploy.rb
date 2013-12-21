node[:deploy].each do |application, deploy|
  # Create the uploads shared uploads folder (that will persist across deployments)
  directory "#{deploy[:deploy_to]}/shared/uploads" do
    owner deploy[:user]
    group deploy[:group]
    mode '0775'
    action :create
    recursive true
  end

  # Symlink the persisted uploads folder into the current deployment
  link "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/uploads" do
    to "#{deploy[:deploy_to]}/shared/uploads"
  end

  # Run composer on the new deployment to install all required packages
  execute "run_composer" do
    Chef::Log.debug("Executing composer update in #{deploy[:deploy_to]}/current for application #{application}")
    command "#{node[:wordpress][:composer][:executable]} update"
    cwd "#{deploy[:deploy_to]}/current"
    user deploy[:user]
    group deploy[:group]

    only_if do
      ::File.exists?("#{node[:wordpress][:composer][:executable]}") && ::File.exists?("#{deploy[:deploy_to]}/current/composer.json")
    end
  end

  link "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:system_path]}" do
    to "#{deploy[:deploy_to]}/current/vendor/wordpress/wordpress"

    only_if do
      ::File.exists?("#{deploy[:deploy_to]}/current/vendor/wordpress/wordpress")
    end
  end
end