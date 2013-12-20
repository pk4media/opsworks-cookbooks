node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping wordpress::deploy application #{application} as it is not an PHP app")
    next
  end

  template "#{deploy[:deploy_to]}/shared/config/wp-config.php" do
    cookbook 'wordpress'
    source 'wp-config.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:database => deploy[:database], :wordpress => deploy[:wordpress])

    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  link "#{deploy[:deploy_to]}/current/wp-config.php" do
    to "#{deploy[:deploy_to]}/shared/config/wp-config.php"

    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/wp-config.php")
    end
  end

  execute "install_composer" do
    Chef::Log.debug("Installing PHP Composer to #{deploy[:deploy_to]}/shared/scripts")
    command node[:wordpress][:composer][:install_command]
    cwd "#{deploy[:deploy_to]}/shared/scripts"
    creates "#{deploy[:deploy_to]}/shared/scripts/composer.phar"

    only_if do
      !node[:wordpress][:composer][:install_command].blank? && File.exists?("#{deploy[:deploy_to]}/shared/scripts")
    end
  end

  execute "run_composer" do
    command "php #{deploy[:deploy_to]}/shared/scripts/composer.phar update"
    cwd "#{deploy[:deploy_to]}/current"
    user deploy[:user]

    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/scripts/composer.phar") && File.exists?("#{deploy[:deploy_to]}/current/composer.json")
    end
  end
end