node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  directory "/vol/files/reports" do
    owner deploy[:user]
    group deploy[:group]
    mode 0755
    action :create
    recursive true
  end

end