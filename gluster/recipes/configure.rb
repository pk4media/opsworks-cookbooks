service 'glusterd' do
    supports :restart => true, :status => true, :reload => true
    action :nothing
end

service 'glusterfsd' do
    supports :restart => true, :status => true, :reload => true
    action :nothing
end

service 'rpcbind' do
    supports :restart => true, :status => true, :reload => true
    action :nothing
end
