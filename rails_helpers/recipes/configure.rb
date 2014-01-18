node[:deploy].each do |application, deploy|
  ruby_block 'application.yml' do
    block do
      config = Hash[deploy[:rails_env], deploy[:rails_app][:config].to_hash]
      ::File.open(::File.join(deploy[:deploy_to], 'shared', 'config', 'application.yml'), 'w', 0640) do |file|
        file.write YAML.dump(config)
      end
    end

    only_if do
      deploy[:rails_app][:write_config]
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
end