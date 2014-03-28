node[:deploy].each do |application, deploy|
  default[:deploy][application][:wordpress][:cache][:browsercache][:cssjs][:compression] = true
end