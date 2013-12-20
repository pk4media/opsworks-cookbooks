default[:wordpress][:composer][:install_command] = "curl -sS https://getcomposer.org/installer | php"

node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == 'php'

  default[:deploy][application][:wordpress][:debug] = false

  default[:deploy][application][:wordpress][:system_path] = 'wordpress'
  default[:deploy][application][:wordpress][:content_path] = 'wp-content'
  default[:deploy][application][:wordpress][:default_theme] = 'twentyfourteen'

  default[:deploy][application][:wordpress][:cache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:version] = '0.9.3'

  default[:deploy][application][:wordpress][:cache][:dbcache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:objectcache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:pgcache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:minify][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:cdn][:enabled] = false
end

include_attribute 'wordpress::dbcache'
include_attribute 'wordpress::objectcache'
include_attribute 'wordpress::pgcache'
include_attribute 'wordpress::minify'
include_attribute 'wordpress::cdn'