include_attribute 'wordpress'

node[:deploy].each do |application, deploy|
  default[:deploy][application][:wordpress][:cache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:version] = '0.9.3'

  default[:deploy][application][:wordpress][:cache][:dbcache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:browsercache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:objectcache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:pgcache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:minify][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:cdn][:enabled] = false
end

include_attribute 'w3_total_cache::dbcache'
include_attribute 'w3_total_cache::objectcache'
include_attribute 'w3_total_cache::pgcache'
include_attribute 'w3_total_cache::minify'
include_attribute 'w3_total_cache::cdn'
include_attribute 'w3_total_cache::browsercache'