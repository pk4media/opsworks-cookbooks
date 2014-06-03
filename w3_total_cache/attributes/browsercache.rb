node[:deploy].each do |application, deploy|
  default[:deploy][application][:wordpress][:cache][:browsercache][:cssjs][:compression] = true
  default[:deploy][application][:wordpress][:cache][:browsercache][:cssjs][:replace] = false
  default[:deploy][application][:wordpress][:cache][:browsercache][:other][:replace] = false
end