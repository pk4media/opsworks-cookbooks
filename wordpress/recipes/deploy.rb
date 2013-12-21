include_recipe "deploy::php"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping wordpress::deploy application #{application} as it is not an PHP app")
    next
  end

  template "#{deploy[:deploy_to]}/shared/config/wp-config.php" do
    Chef::Log.debug("Adding wordpress config for application #{application}")
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
    Chef::Log.debug("Installing PHP Composer to #{deploy[:deploy_to]}/shared/scripts for application #{application}")
    command node[:wordpress][:composer][:install_command]
    cwd "#{deploy[:deploy_to]}/shared/scripts"
    creates "#{deploy[:deploy_to]}/shared/scripts/composer.phar"

    only_if do
      !node[:wordpress][:composer][:install_command].blank? && ::File.exists?("#{deploy[:deploy_to]}/shared/scripts")
    end
  end

  execute "run_composer" do
    Chef::Log.debug("Executing composer update in #{deploy[:deploy_to]}/current for application #{application}")
    command "php #{deploy[:deploy_to]}/shared/scripts/composer.phar update"
    cwd "#{deploy[:deploy_to]}/current"
    user deploy[:user]
    group deploy[:group]

    only_if do
      ::File.exists?("#{deploy[:deploy_to]}/shared/scripts/composer.phar") && ::File.exists?("#{deploy[:deploy_to]}/current/composer.json")
    end
  end

  directory "#{new_resource.deploy_to}/shared/uploads" do
    group new_resource.group
    owner new_resource.user
    mode 0775
    action :create
    recursive true
  end

  link "#{release_path}/wp-content/uploads" do
    to "#{new_resource.deploy_to}/shared/uploads"
  end

  if deploy[:wordpress][:cache][:enabled]
    Chef::Log.debug("Wordpress w3-total-cache enabled for application #{application}")

    # Setup the w3-total-cache config folder
    directory "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/w3tc-config"
      owner deploy[:user]
      group deploy[:group]
      mode 0775
      action :create
      recursive true
    end

    directory "#{deploy[:deploy_to]}/shared/cache" do
      group new_resource.group
      owner new_resource.user
      mode 0775
      action :create
      recursive true
    end

    link "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/cache" do
      to "#{deploy[:deploy_to]}/shared/cache"
    end

    template "#{deploy[:deploy_to]}/shared/config/master.php" do
      Chef::Log.debug("Adding w3-total-cache config for application #{application}")
      cookbook 'wordpress'
      source 'master.php.erb'
      mode '0660'
      owner deploy[:user]
      group deploy[:group]
      variables(:memcached => deploy[:memcached], :cache => deploy[:wordpress][:cache])

      only_if do
        deploy[:wordpress][:cache][:enabled] && ::File.exists?("#{deploy[:deploy_to]}/shared/config")
      end
    end

    link "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/w3tc-config/master.php" do
      to "#{deploy[:deploy_to]}/shared/config/master.php"

      only_if do
        deploy[:wordpress][:cache][:enabled] && ::File.exists?("#{deploy[:deploy_to]}/shared/config/master.php")
      end
    end

    template "#{deploy[:deploy_to]}/shared/config/master-admin.php" do
      Chef::Log.debug("Adding w3-total-cache master-admin.php for application #{application}")
      cookbook 'wordpress'
      source 'master-admin.php.erb'
      mode '0660'
      owner deploy[:user]
      group deploy[:group]

      only_if do
        deploy[:wordpress][:cache][:enabled] && ::File.exists?("#{deploy[:deploy_to]}/shared/config")
      end
    end
    
    link "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/w3tc-config/master-admin.php" do
      to "#{deploy[:deploy_to]}/shared/config/master-admin.php"

      only_if do
        deploy[:wordpress][:cache][:enabled] && ::File.exists?("#{deploy[:deploy_to]}/shared/config/master-admin.php")
      end
    end

    template "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/plugins/w3tc-wp-loader.php" do
      cookbook 'wordpress'
      source 'w3tc-wp-loader.php.erb'
      mode '0660'
      owner deploy[:user]
      group deploy[:group]
      variables(:deploy_to => deploy[:deploy_to], :system_path => deploy[:wordpress][:system_path])

      only_if do
        deploy[:wordpress][:cache][:enabled]
      end
    end

    template "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/advanced-cache.php" do
      cookbook 'wordpress'
      source "advanced-cache.#{deploy[:wordpress][:cache][:version]}.php.erb"
      mode '0660'
      owner deploy[:user]
      group deploy[:group]

      only_if do
        deploy[:wordpress][:cache][:enabled]
      end
    end

    template "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/db.php" do
      cookbook 'wordpress'
      source "db.#{deploy[:wordpress][:cache][:version]}.php.erb"
      mode '0660'
      owner deploy[:user]
      group deploy[:group]

      only_if do
        deploy[:wordpress][:cache][:enabled] && deploy[:wordpress][:cache][:dbcache][:enabled]
      end
    end

    template "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/object-cache.php" do
      cookbook 'wordpress'
      source "object-cache.#{deploy[:wordpress][:cache][:version]}.php.erb"
      mode '0660'
      owner deploy[:user]
      group deploy[:group]

      only_if do
        deploy[:wordpress][:cache][:enabled] && deploy[:wordpress][:cache][:objectcache][:enabled]
      end
    end

    directory "#{deploy[:deploy_to]}/shared/cache/config" do
      recursive true
      action :delete
    end
    
    directory "#{deploy[:deploy_to]}/shared/cache/minify" do
      recursive true
      action :delete
    end
  end
end