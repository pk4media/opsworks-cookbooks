include_recipe "rails_helpers::configure"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  # Ensure the application.yml file doesn't exist, so that we can symlink it
  file "#{deploy[:deploy_to]}/current/config/application.yml" do
    action :delete

    only_if do
      deploy[:rails_app][:write_config]
    end
  end

  file "#{deploy[:deploy_to]}/shared/config/application.yml" do
    content YAML.dump(Hash[deploy[:rails_env], deploy[:rails_app][:config].to_hash]).gsub('!map:Chef::Node::ImmutableMash','').gsub('!seq:Chef::Node::ImmutableArray','').gsub('---','')
    owner deploy[:user]
    group deploy[:group]
    mode 0640

    only_if do
      deploy[:rails_app][:write_config] && deploy[:rails_app][:config]
    end
  end

  link "#{deploy[:deploy_to]}/current/config/application.yml" do
    to "#{deploy[:deploy_to]}/shared/config/application.yml"

    only_if do
      ::File.exists?("#{deploy[:deploy_to]}/shared/config/application.yml")
    end
  end

  # Ensure the application.yml file doesn't exist, so that we can symlink it
  file "#{deploy[:deploy_to]}/current/config/couchbase.yml" do
    action :delete

    only_if do
      deploy[:rails_app][:write_config]
    end
  end

  file "#{deploy[:deploy_to]}/shared/config/couchbase.yml" do
    content YAML.dump(Hash[deploy[:rails_env], deploy[:rails_app][:couchbase].to_hash]).gsub('!map:Chef::Node::ImmutableMash','').gsub('!seq:Chef::Node::ImmutableArray','').gsub('---','')
    owner deploy[:user]
    group deploy[:group]
    mode 0640

    only_if do
      deploy[:rails_app][:write_config] && deploy[:rails_app][:couchbase]
    end
  end

  link "#{deploy[:deploy_to]}/current/config/couchbase.yml" do
    to "#{deploy[:deploy_to]}/shared/config/couchbase.yml"

    only_if do
      ::File.exists?("#{deploy[:deploy_to]}/shared/config/couchbase.yml")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/aws.yml" do
    Chef::Log.debug "Adding aws config for #{application}"
    cookbook 'rails_helpers'
    source 'aws.yml.erb'
    mode '0640'
    owner deploy[:user]
    group deploy[:group]
    variables(:environment => deploy[:rails_env], :aws => deploy[:aws])

    only_if do
      deploy[:aws][:access_key_id] && deploy[:aws][:secret_access_key]
    end
  end

  link "#{deploy[:deploy_to]}/current/config/aws.yml" do
    to "#{deploy[:deploy_to]}/shared/config/aws.yml"

    only_if do
      ::File.exists?("#{deploy[:deploy_to]}/shared/config/aws.yml")
    end
  end

  directory "#{deploy[:deploy_to]}/current/tmp/cache" do
    owner deploy[:user]
    group deploy[:group]
    mode 0755
    action :create
    recursive true
  end

  execute "rake assets:precompile" do
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle exec rake assets:precompile"
    environment "RAILS_ENV" => deploy[:rails_env]
    user deploy[:user]
    action :run
  end

  execute "restart_rails" do
    cwd "#{deploy[:deploy_to]}/current"
    command "sleep #{deploy[:sleep_before_restart]} && #{node[:opsworks][:rails_stack][:restart_command]}"
    user deploy[:user]
    action :run

    only_if do 
      File.exists?("#{deploy[:deploy_to]}/current")
    end
  end
end