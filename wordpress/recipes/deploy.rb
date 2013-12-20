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

  if deploy[:wordpress][:cache][:enabled]
    # Configure the w3-total-cache settings
    template "#{deploy[:deploy_to]}/shared/config/master.php" do
      cookbook 'wordpress'
      source 'master.php.erb'
      mode '0660'
      owner deploy[:user]
      group deploy[:group]
      variables(:memcached => deploy[:memcached], :cache => deploy[:wordpress][:cache])
      only_if do
        deploy[:wordpress][:cache][:enabled] && File.exists?("#{deploy[:deploy_to]}/shared/config")
      end
    end

    link "#{deploy[:deploy_to]}/current/wp-content/w3tc-config/master.php" do
      to "#{deploy[:deploy_to]}/shared/config/master.php"

      only_if do
        deploy[:wordpress][:cache][:enabled] && File.exists?("#{deploy[:deploy_to]}/shared/config/master.php")
      end
    end

    template "#{deploy[:deploy_to]}/shared/config/master-admin.php" do
      cookbook 'wordpress'
      source 'master-admin.php.erb'
      mode '0660'
      owner deploy[:user]
      group deploy[:group]
      only_if do
        deploy[:wordpress][:cache][:enabled] && File.exists?("#{deploy[:deploy_to]}/shared/config")
      end
    end
    
    link "#{deploy[:deploy_to]}/current/wp-content/w3tc-config/master-admin.php" do
      to "#{deploy[:deploy_to]}/shared/config/master-admin.php"

      only_if do
        deploy[:wordpress][:cache][:enabled] && File.exists?("#{deploy[:deploy_to]}/shared/config/master-admin.php")
      end
    end

    template "#{deploy[:deploy_to]}/current/wp-content/plugins/w3tc-wp-loader.php" do
      cookbook 'wordpress'
      source 'w3tc-wp-loader.php.erb'
      mode '0660'
      owner deploy[:user]
      group deploy[:group]
      variables(:deploy_to => deploy[:deploy_to])

      only_if do
        deploy[:wordpress][:cache][:enabled] && 
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

    file "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/advanced-cache.php" do
      content ::File.open("#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/plugins/w3-total-cache/wp-content/advanced-cache.php").read
      owner deploy[:user]
      group deploy[:group]
      mode '0660'
      action :create

      only_if do
        deploy[:wordpress][:cache][:enabled] && File.exists?("#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/plugins/w3-total-cache/wp-content/advanced-cache.php")
      end
    end

    file "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/db.php" do
      content ::File.open("#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/plugins/w3-total-cache/wp-content/db.php").read
      owner deploy[:user]
      group deploy[:group]
      mode '0660'
      action :create
      only_if do
        deploy[:wordpress][:cache][:enabled] && deploy[:wordpress][:cache][:dbcache][:enabled] && File.exists("#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/plugins/w3-total-cache/wp-content/db.php")
      end
    end

    file "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/object-cache.php" do
      content ::File.open("#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/plugins/w3-total-cache/wp-content/object-cache.php").read
      owner deploy[:user]
      group deploy[:group]
      mode '0660'
      action :create
      only_if do
        deploy[:wordpress][:cache][:enabled] && deploy[:wordpress][:cache][:objectcache][:enabled] && File.exists?("#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/plugins/w3-total-cache/wp-content/object-cache.php")
      end
    end
  end
end