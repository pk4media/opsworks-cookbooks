node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  link "#{deploy[:deploy_to]}/current/wp-config.php" do
    to "#{deploy[:deploy_to]}/shared/config/wp-config.php"
  end

  execute "install_composer" do
    command node[:wordpress][:composer][:install_command]
    cwd "#{deploy[:deploy_to]}/shared/scripts"
    creates "#{deploy[:deploy_to]}/shared/scripts/composer.phar"

    only_if do
      !node[:wordpress][:composer][:install_command].blank?
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