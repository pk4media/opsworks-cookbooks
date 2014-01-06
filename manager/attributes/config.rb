node[:deploy].each do |application, deploy|
  default[:deploy][application][:manager][:config][:name] = 'XPS Ad Server'

  default[:deploy][application][:manager][:config][:test] = false

  default[:deploy][application][:manager][:config][:ad_server][:host] = 'ads.pk4labs.com'
  default[:deploy][application][:manager][:config][:ad_server][:port] = nil

  default[:deploy][application][:manager][:config][:pixels][:host] = 'pixels.pk4labs.com'
  default[:deploy][application][:manager][:config][:pixels][:port] = nil

  default[:deploy][application][:manager][:config][:instrumentation][:node_list] = []
  default[:deploy][application][:manager][:config][:instrumentation][:bucket] = 'instrumentation'
  default[:deploy][application][:manager][:config][:instrumentation][:password] = nil

  default[:deploy][application][:manager][:config][:aws][:access_key] = nil
  default[:deploy][application][:manager][:config][:aws][:secret_key] = nil
end