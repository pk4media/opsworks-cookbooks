node[:deploy].each do |application, deploy|
  if deploy[:wordpress][:cache][:enabled]
    directory "#{deploy[:deploy_to]}/shared/cache" do
      owner deploy[:user]
      group deploy[:group]
      mode '0775'
      action :create
      recursive true
    end

    template "#{deploy[:deploy_to]}/shared/config/master.php" do
      Chef::Log.debug("Adding w3-total-cache config for application #{application}")
      cookbook 'w3_total_cache'
      source 'master.php.erb'
      mode '0660'
      owner deploy[:user]
      group deploy[:group]
      variables(:memcached => deploy[:memcached], :cache => deploy[:wordpress][:cache])

      only_if do
        ::File.exists?("#{deploy[:deploy_to]}/shared/config")
      end
    end

    template "#{deploy[:deploy_to]}/shared/config/master-admin.php" do
      Chef::Log.debug("Adding w3-total-cache master-admin.php for application #{application}")
      cookbook 'w3_total_cache'
      source 'master-admin.php.erb'
      mode '0660'
      owner deploy[:user]
      group deploy[:group]

      only_if do
        ::File.exists?("#{deploy[:deploy_to]}/shared/config")
      end
    end

    template "#{deploy[:deploy_to]}/shared/config/advanced-cache.php" do
      cookbook 'w3_total_cache'
      source "advanced-cache.#{deploy[:wordpress][:cache][:version]}.php.erb"
      mode '0660'
      owner deploy[:user]
      group deploy[:group]
    end

    template "#{deploy[:deploy_to]}/shared/config/db.php" do
      cookbook 'w3_total_cache'
      source "db.#{deploy[:wordpress][:cache][:version]}.php.erb"
      mode '0660'
      owner deploy[:user]
      group deploy[:group]

      only_if do
        deploy[:wordpress][:cache][:dbcache][:enabled]
      end
    end

    template "#{deploy[:deploy_to]}/current/shared/config/object-cache.php" do
      cookbook 'w3_total_cache'
      source "object-cache.#{deploy[:wordpress][:cache][:version]}.php.erb"
      mode '0660'
      owner deploy[:user]
      group deploy[:group]

      only_if do
        deploy[:wordpress][:cache][:objectcache][:enabled]
      end
    end

    directory "#{deploy[:deploy_to]}/shared/cache/config" do
      recursive true
      action :delete
    end
  end
end