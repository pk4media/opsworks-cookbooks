node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == 'php'

  default[:deploy][application][:wordpress][:cache][:version] = '0.9.3'

  default[:deploy][application][:wordpress][:cache][:dbcache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:objectcache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:pgcache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:minify][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:cdn][:enabled] = false

  default[:deploy][application][:symlink_before_migrate] = {}
end

include_attribute 'w3_total_cache::dbcache'
include_attribute 'w3_total_cache::objectcache'
include_attribute 'w3_total_cache::pgcache'
include_attribute 'w3_total_cache::minify'
include_attribute 'w3_total_cache::cdn'