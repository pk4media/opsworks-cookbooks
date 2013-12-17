include_recipe 'deploy'

node[:deploy].each do |application, deploy|
    if deploy[:application_type] != 'php'
        Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
        next
    end
    
    template "#{deploy[:deploy_to]}/current/wp-config.php" do
        cookbook 'wordpress'
        source 'wp-config.php.erb'
        mode '0660'
        owner deploy[:user]
        group deploy[:group]
        variables(:database => deploy[:database])
    end
end
