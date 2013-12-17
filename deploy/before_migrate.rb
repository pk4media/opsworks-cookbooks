deploy_resource = new_resource
deploy_to = deploy_resource.deploy_to

directory "#{deploy_to}/shared/cache" do
    group deploy[:group]
    owner deploy[:user]
    mode '0755'
    action :create
    recursive true
end

directory "#{deploy_to}/shared/uploads" do
    group deploy[:group]
    owner deploy[:user]
    mode '0755'
    action :create
    recursive true
end
