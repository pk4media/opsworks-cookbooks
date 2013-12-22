include_recipe "wordpress::configure"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]
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
end