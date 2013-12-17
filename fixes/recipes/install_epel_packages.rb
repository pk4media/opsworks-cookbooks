# The opsworks GUI won't install packages from epel.

if node[:epel_packages] && !node[:epel_packages].empty?
  node[:epel_packages].each do |name|
    package name do
      action :install
    end
  end
end
