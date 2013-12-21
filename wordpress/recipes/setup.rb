# Install composer into the shared folder (only if not already installed)
execute "install_composer" do
  Chef::Log.debug("Installing PHP Composer to #{node[:wordpress][:composer][:executable]}")
  command node[:wordpress][:composer][:install_command]
  creates node[:wordpress][:composer][:executable]

  only_if do
    !node[:wordpress][:composer][:install_command].blank? && !node[:wordpress][:composer][:executable].blank?
  end
end

template "#{deploy[:home]}/.composer/config.json" do
  cookbook 'wordpress'
  source 'config.json.erb'
  mode '0765'
  owner deploy[:user]
  group deploy[:group]

  only_if do
    ::File.exists?("#{deploy[:home]}") && ::File.exists?("#{node[:wordpress][:composer][:executable]}")
  end
end