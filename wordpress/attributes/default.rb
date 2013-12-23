default[:wordpress][:composer][:executable] = "/usr/local/bin/composer"
default[:wordpress][:composer][:install_command] = "curl -sS https://getcomposer.org/installer | php && mv composer.phar #{node[:wordpress][:composer][:executable]}"

node[:deploy].each do |application, deploy|
  default[:deploy][application][:wordpress][:debug] = false
  default[:deploy][application][:wordpress][:default_theme] = 'twentyfourteen'
  default[:deploy][application][:wordpress][:upload_max_filesize] = '2M'
end

include_attribute 'w3_total_cache'