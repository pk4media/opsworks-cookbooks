node[:deploy].each do |application, deploy|
  default[:deploy][application][:wordpress][:cache][:pgcache][:debug] = false
  default[:deploy][application][:wordpress][:cache][:pgcache][:engine] = 'file'
  default[:deploy][application][:wordpress][:cache][:pgcache][:lifetime] = 3600
  default[:deploy][application][:wordpress][:cache][:pgcache][:cache][:ssl] = true
  default[:deploy][application][:wordpress][:cache][:pgcache][:cache][:_404] = false
  default[:deploy][application][:wordpress][:cache][:pgcache][:cache][:headers] = [
    'Last-Modified',
    'Content-Type',
    'X-Pingback',
    'P3P'
  ]
end