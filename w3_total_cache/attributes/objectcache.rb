node[:deploy].each do |application, deploy|
  default[:deploy][application][:wordpress][:cache][:objectcache][:debug] = false
  default[:deploy][application][:wordpress][:cache][:objectcache][:engine] = 'file'
  default[:deploy][application][:wordpress][:cache][:objectcache][:lifetime] = 180
end