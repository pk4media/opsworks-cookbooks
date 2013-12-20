node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == 'php'

  default[:deploy][application][:wordpress][:cache][:dbcache][:debug] = false
  default[:deploy][application][:wordpress][:cache][:dbcache][:engine] = 'file'
  default[:deploy][application][:wordpress][:cache][:dbcache][:lifetime] = 180
  default[:deploy][application][:wordpress][:cache][:dbcache][:memcached][:persistant] = true
end