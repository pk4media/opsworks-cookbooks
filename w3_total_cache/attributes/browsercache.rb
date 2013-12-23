node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == 'php'

  default[:deploy][application][:wordpress][:cache][:browsercache][:cssjs][:compression] = true
end