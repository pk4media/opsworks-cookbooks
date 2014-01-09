node[:deploy].each do |application, deploy|
  default[application][:cron][:report_reconcile][:minutes] = '*/1'
  default[application][:cron][:report_reconcile][:hours] = '*'

  default[:deploy][application][:manager][:config][:name] = 'XPS Ad Manager'
  default[:deploy][application][:manager][:config][:short_name] = 'XPS'

  default[:deploy][application][:manager][:config][:test] = false

  default[:deploy][application][:manager][:config][:ad_server][:host] = 'ads.pk4labs.com'
  default[:deploy][application][:manager][:config][:ad_server][:port] = nil

  default[:deploy][application][:manager][:config][:pixels][:host] = 'pixels.pk4labs.com'
  default[:deploy][application][:manager][:config][:pixels][:port] = nil

  default[:deploy][application][:manager][:config][:instrumentation][:node_list] = []
  default[:deploy][application][:manager][:config][:instrumentation][:bucket] = 'instrumentation'
  default[:deploy][application][:manager][:config][:instrumentation][:password] = nil
end