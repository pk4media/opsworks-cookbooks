include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  execute "run_composer" do
    command "#{deploy[:wordpress][:composer][:executable]} install"
    cwd "#{deploy[:deploy_to]}/current"

    only_if do
      File.exists?(node[:wordpress][:composer][:executable]) && File.exists?("#{deploy[:deploy_to]}/current/composer.json")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/wp-config.php" do
    cookbook 'wordpress'
    source 'wp-config.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:database => deploy[:database], :wordpress => deploy[:wordpress])
  end
  
  link "#{deploy[:deploy_to]}/current/wp-config.php" do
    to "#{deploy[:deploy_to]}/shared/config/wp-config.php"
  end
end