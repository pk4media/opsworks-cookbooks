node[:deploy].each do |application, deploy|
  # Create the wordpress configuration in the shared folder
  template "#{deploy[:deploy_to]}/shared/config/wp-config.php" do
    Chef::Log.debug("Adding wordpress config for application #{application}")
    cookbook 'wordpress'
    source 'wp-config.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:database => deploy[:database], :wordpress => deploy[:wordpress])

    only_if do
      ::File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  # Create the uploads shared uploads folder (that will persist across deployments)
  directory "#{deploy[:deploy_to]}/shared/uploads" do
    owner deploy[:user]
    group deploy[:group]
    mode '0775'
    action :create
    recursive true
  end

  template "#{deploy[:home]}/.composer/config.json" do
    cookbook 'wordpress'
    source 'config.json.erb'
    mode '0765'
    owner deploy[:user]
    group deploy[:group]

    only_if do
      ::File.exists?("#{deploy[:home]}") && ::File.exists?("#{node[:wordpress][:composer][:executable]}")
    end
  end
end