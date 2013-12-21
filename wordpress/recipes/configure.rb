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

  # Link the wordpress configuration to the value in the shared folder
  link "#{deploy[:deploy_to]}/current/wp-config.php" do
    to "#{deploy[:deploy_to]}/shared/config/wp-config.php"

    only_if do
      ::File.exists?("#{deploy[:deploy_to]}/shared/config/wp-config.php")
    end
  end
end