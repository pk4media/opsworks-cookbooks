node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  template "#{deploy[:deploy_to]}/shared/config/master-admin.php" do
    cookbook 'w3_total_cache'
    source 'master-admin.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/master.php" do
    cookbook 'w3_total_cache'
    source 'master.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:memcached => deploy[:memcached], :cache => deploy[:wordpress][:cache])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end
end