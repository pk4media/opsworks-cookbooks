yum_repository 'couchbase' do
  description 'Couchbase package repository'
  baseurl "http://packages.couchbase.com/rpm/5.5/#{node['kernel']['machine']  =~ /x86_64/ ? 'x86_64' : 'i686'}"
  gpgkey 'http://packages.couchbase.com/rpm/couchbase-rpm.key'
  action :create
end

package 'libcouchbase-devel' do
  action :install
end

yum_repository 'couchbase' do
  action :delete
end