node[:deploy].each do |application, deploy|
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
end