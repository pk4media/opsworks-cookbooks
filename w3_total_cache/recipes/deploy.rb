include_recipe "w3_total_cache::configure"
include_recipe "wordpress::deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  Chef::Log.debug("Deploying w3_total_cache for #{application} with settings: #{deploy.inspect}")

  if deploy[:wordpress][:cache][:enabled]
    Chef::Log.debug("Wordpress w3-total-cache enabled for application #{application}")

    # Setup the w3-total-cache config folder
    directory "#{deploy[:deploy_to]}/current/wp-content/w3tc-config" do
      owner deploy[:user]
      group deploy[:group]
      mode '0775'
      action :create
      recursive true
    end

    link "#{deploy[:deploy_to]}/current/wp-content/w3tc-config/master.php" do
      to "#{deploy[:deploy_to]}/shared/config/master.php"

      only_if do
        ::File.exists?("#{deploy[:deploy_to]}/shared/config/master.php")
      end
    end
    
    link "#{deploy[:deploy_to]}/current/wp-content/w3tc-config/master-admin.php" do
      to "#{deploy[:deploy_to]}/shared/config/master-admin.php"

      only_if do
        ::File.exists?("#{deploy[:deploy_to]}/shared/config/master-admin.php")
      end
    end

    template "#{deploy[:deploy_to]}/current/wp-content/plugins/w3tc-wp-loader.php" do
      cookbook 'w3_total_cache'
      source 'w3tc-wp-loader.php.erb'
      mode '0660'
      owner deploy[:user]
      group deploy[:group]
      variables(:deploy_to => deploy[:deploy_to])
    end

    link "#{deploy[:deploy_to]}/current/wp-content/cache" do
      to "#{deploy[:deploy_to]}/shared/cache"
    end

    link "#{deploy[:deploy_to]}/current/wp-content/advanced-cache.php" do
      to "#{deploy[:deploy_to]}/shared/config/advanced-cache.php"
    end

    if deploy[:wordpress][:cache][:db][:enabled]
      link "#{deploy[:deploy_to]}/current/wp-content/db.php" do
        to "#{deploy[:deploy_to]}/shared/config/db.php"
      end
    end

    if deploy[:wordpress][:cache][:objectcache][:enabled]
      link "#{deploy[:deploy_to]}/current/wp-content/object-cache.php" do
        to "#{deploy[:deploy_to]}/shared/config/object-cache.php"
      end
    end
    
    directory "#{deploy[:deploy_to]}/shared/cache/minify" do
      recursive true
      action :delete
    end
  end
end