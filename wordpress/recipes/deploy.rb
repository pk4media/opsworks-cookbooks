include_recipe "wordpress::configure"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  Chef::Log.debug("Deploying wordpress for #{application} with settings: #{deploy.inspect}")

  # Link the wordpress configuration to the value in the shared folder
  link "#{deploy[:deploy_to]}/current/wp-config.php" do
    to "#{deploy[:deploy_to]}/shared/config/wp-config.php"

    only_if do
      ::File.exists?("#{deploy[:deploy_to]}/shared/config/wp-config.php")
    end
  end

  # Symlink the persisted uploads folder into the current deployment
  link "#{deploy[:deploy_to]}/current/wp-content/uploads" do
    to "#{deploy[:deploy_to]}/shared/uploads"
  end

  # Run composer on the new deployment to install all required packages
  execute "run_composer" do
    Chef::Log.debug("Executing composer update in #{deploy[:deploy_to]}/current for application #{application}")
    command "#{node[:wordpress][:composer][:executable]} install"
    cwd "#{deploy[:deploy_to]}/current"
    environment ({'COMPOSER_HOME' => "#{deploy[:home]}/.composer"})
    user deploy[:user]
    group deploy[:group]

    only_if do
      ::File.exists?("#{node[:wordpress][:composer][:executable]}") && ::File.exists?("#{deploy[:deploy_to]}/current/composer.json")
    end
  end

  link "#{deploy[:deploy_to]}/current/wordpress" do
    to "#{deploy[:deploy_to]}/current/vendor/wordpress/wordpress"

    only_if do
      ::File.exists?("#{deploy[:deploy_to]}/current/vendor/wordpress/wordpress")
    end
  end

  template "#{deploy[:deploy_to]}/current/vendor/wordpress/wp-config.php" do
    cookbook 'wordpress'
    source 'wp-config-link.php.erb'
    mode '0640'
    owner deploy[:user]
    group deploy[:group]
  end

  execute "harden_directories" do
    command "find #{deploy[:deploy_to]}/current/ -type d -exec chmod 775 {} \\;"
    user deploy[:user]
    group deploy[:group]
  end

  execute "harden_files" do
    command "find #{deploy[:deploy_to]}/current/ -type f -exec chmod 664 {} \\;"
    user deploy[:user]
    group deploy[:group]
  end

  htaccess_partials = []
  htaccess_partials << {:template => 'htaccess-browsercache.erb', :cookbook => 'w3_total_cache', :variables => {:cache => deploy[:wordpress][:cache]}} if deploy[:wordpress][:cache][:enabled] && deploy[:wordpress][:cache][:browsercache][:enabled]
  htaccess_partials << {:template => 'htaccess-cdn.erb', :cookbook => 'w3_total_cache', :variables => {:cache => deploy[:wordpress][:cache]}} if deploy[:wordpress][:cache][:enabled] && deploy[:wordpress][:cache][:cdn][:enabled]
  template "#{deploy[:deploy_to]}/current/.htaccess" do
    cookbook 'wordpress'
    source 'htaccess.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:partials => htaccess_partials, :upload_max_filesize => deploy[:wordpress][:upload_max_filesize])
  end
end