node[:deploy].each do |application, deploy|
  default[:deploy][application][:aws][:access_key_id] = nil
  default[:deploy][application][:aws][:secret_access_key] = nil
end