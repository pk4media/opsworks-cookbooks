execute "install_composer" do
  command node[:wordpress][:composer][:install_command]
  creates node[:wordpress][:composer][:executable]

  only_if do
    !node[:wordpress][:composer][:install_command].blank?
  end
end