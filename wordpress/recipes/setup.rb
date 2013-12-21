# Install composer into the shared folder (only if not already installed)
execute "install_composer" do
  Chef::Log.debug("Installing PHP Composer to #{node[:wordpress][:composer][:executable]}")
  command node[:wordpress][:composer][:install_command]
  creates node[:wordpress][:composer][:executable]

  only_if do
    !node[:wordpress][:composer][:install_command].blank? && !node[:wordpress][:composer][:executable].blank?
  end
end