include_recipe 'deploy'

node[:deploy].each do |application, deploy|
    if deploy[:application_type] != 'php'
        Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
        next
    end
    
    template "#{deploy[:deploy_to]}/shared/config/wp-config.php" do
        cookbook 'wordpress'
        source 'wp-config.php.erb'
        mode '0660'
        owner deploy[:user]
        group deploy[:group]
        variables(:database => deploy[:database])
    end
    
    link "#{deploy[:deploy_to]}/current/wp-config.php" do
        to "#{deploy[:deploy_to]}/shared/config/wp-config.php"
    end
    
    template "#{deploy[:deploy_to]}/current/wp-content/plugins/w3tc-wp-loader.php" do
        cookbook 'wordpress'
        source 'w3tc-wp-loader.php.erb'
        mode '0660'
        owner deploy[:user]
        group deploy[:group]
        variables(:deploy_to => deploy[:deploy_to])
    end
    
    template "#{deploy[:deploy_to]}/shared/cache/config/master.php" do
        cookbook 'wordpress'
        source 'master.php.erb'
        mode '0660'
        owner deploy[:user]
        group deploy[:group]
        variables(:memcached => deploy[:memcached])
    end
end
