node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == 'php'

  default[:deploy][application][:wordpress][:cache][:minify][:enabled] = false
  default[:deploy][application][:wordpress][:cache][:minify][:debug] = false
  default[:deploy][application][:wordpress][:cache][:minify][:engine] = 'file'
  default[:deploy][application][:wordpress][:cache][:minify][:auto] = true
  default[:deploy][application][:wordpress][:cache][:minify][:auto][:disable_filename_length_test] = true
  default[:deploy][application][:wordpress][:cache][:minify][:auot][:filename_length] = 150
end