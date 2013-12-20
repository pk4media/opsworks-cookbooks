node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == 'php'

  default[:deploy][application][:wordpress][:cache][:version] = '0.9.3'
end

include_attribute 'w3_total_cache::dbcache'
include_attribute 'w3_total_cache::objectcache'
include_attribute 'w3_total_cache::pgcache'
include_attribute 'w3_total_cache::minify'
include_attribute 'w3_total_cache::cdn'