node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "rake assets:precompile" do
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle exec rake assets:precompile"
    environment "RAILS_ENV" => deploy[:rails_env]
    user deploy[:user]
    action :run
  end
end