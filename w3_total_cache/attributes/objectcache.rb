node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == 'php'

  default[:deploy][application][:wordpress][:cache][:objectcache][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:objectcache][:debug] = false
  default[:deploy][application][:wordpress][:cache][:objectcache][:engine] = 'file'
  default[:deploy][application][:wordpress][:cache][:objectcache][:lifetime] = 180
end