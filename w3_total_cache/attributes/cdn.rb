node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == 'php'

  default[:deploy][application][:wordpress][:cache][:cdn][:debug] = false
  default[:deploy][application][:wordpress][:cache][:cdn][:engine] = 'cf2'

  default[:deploy][application][:wordpress][:cache][:cdn][:reject][:files] = [
    '{uploads_dir}/wpcf7_captcha/*',
    '{uploads_dir}/imagerotator.swf',
    '{plugins_dir}/wp-fb-autoconnect/facebook-platform/channel.html'
  ]

  default[:deploy][application][:wordpress][:cache][:cdn][:cf][:key] = deploy[:aws_key]
  default[:deploy][application][:wordpress][:cache][:cdn][:cf][:secret] = deploy[:aws_secret]
  default[:deploy][application][:wordpress][:cache][:cdn][:cf][:bucket] = ''
  default[:deploy][application][:wordpress][:cache][:cdn][:cf][:id] = ''
  default[:deploy][application][:wordpress][:cache][:cdn][:cf][:cname] = []
  default[:deploy][application][:wordpress][:cache][:cdn][:cf][:ssl] = 'disabled'

  default[:deploy][application][:wordpress][:cache][:cdn][:cf2][:key] = deploy[:aws_key]
  default[:deploy][application][:wordpress][:cache][:cdn][:cf2][:secret] = deploy[:aws_secret]
  default[:deploy][application][:wordpress][:cache][:cdn][:cf2][:id] = ''
  default[:deploy][application][:wordpress][:cache][:cdn][:cf2][:cname] = []
  default[:deploy][application][:wordpress][:cache][:cdn][:cf2][:ssl] = 'disabled'
end