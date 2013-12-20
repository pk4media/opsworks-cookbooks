default[:wordpress][:composer][:install_command] = "curl -sS https://getcomposer.org/installer | php"

node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == 'php'

  default[:deploy][application][:wordpress][:system_path] = 'wordpress'
  default[:deploy][application][:wordpress][:content_path] = 'wp-content'
  default[:deploy][application][:wordpress][:default_theme] = 'twentyfourteen'
end