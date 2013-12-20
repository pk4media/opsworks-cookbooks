include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  template "#{deploy[:deploy_to]}/current/wp-content/plugins/w3tc-wp-loader.php" do
    cookbook 'w3_total_cache'
    source 'w3tc-wp-loader.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:deploy_to => deploy[:deploy_to])
  end
  
  template "#{deploy[:deploy_to]}/shared/config/master.php" do
    cookbook 'w3_total_cache'
    source 'master.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:memcached => deploy[:memcached], :cache => deploy[:wordpress][:cache])
  end
  
  link "#{deploy[:deploy_to]}/current/wp-content/w3tc-config/master.php" do
    to "#{deploy[:deploy_to]}/shared/config/master.php"
  end
  
  template "#{deploy[:deploy_to]}/shared/config/master-admin.php" do
    cookbook 'w3_total_cache'
    source 'master-admin.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
  end
  
  link "#{deploy[:deploy_to]}/current/wp-content/w3tc-config/master-admin.php" do
    to "#{deploy[:deploy_to]}/shared/config/master-admin.php"
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
  end

  file "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/db.php" do
    content ::File.open("#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/plugins/w3-total-cache/wp-content/db.php").read
    owner deploy[:user]
    group deploy[:group]
    mode '0660'
    action :create
    only_if do
      deploy[:wordpress][:cache][:dbcache][:enabled]
    end
  end

  file "#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/object-cache.php" do
    content ::File.open("#{deploy[:deploy_to]}/current/#{deploy[:wordpress][:content_path]}/plugins/w3-total-cache/wp-content/object-cache.php").read
    owner deploy[:user]
    group deploy[:group]
    mode '0660'
    action :create
    only_if do
      deploy[:wordpress][:cache][:objectcache][:enabled]
    end
  end
end