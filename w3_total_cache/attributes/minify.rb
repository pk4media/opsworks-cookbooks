node[:deploy].each do |application, deploy|
  default[:deploy][application][:wordpress][:cache][:minify][:debug] = false
  default[:deploy][application][:wordpress][:cache][:minify][:engine] = 'file'
  default[:deploy][application][:wordpress][:cache][:minify][:rewrite] = true
  default[:deploy][application][:wordpress][:cache][:minify][:auto][:enabled] = true
  default[:deploy][application][:wordpress][:cache][:minify][:auto][:disable_filename_length_test] = true
  default[:deploy][application][:wordpress][:cache][:minify][:auto][:filename_length] = 150
end