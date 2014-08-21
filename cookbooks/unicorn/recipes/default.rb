if ['solo', 'app_master', 'app'].include?(node[:instance_role])
  appname = "appcore"

  service "unicorn_#{appname}" do
    supports :restart => true
  end

  case node[:ec2][:instance_type]
  when 'm1.small', 'm3.small'  then worker_count = 5
  when 'm1.medium', 'm3.medium', 'c1.medium' then worker_count = 10
  when 'm1.large', 'm3.large', 'c1.large', 'c3.large'  then worker_count = 20
  when 'm1.xlarge', 'm3.xlarge', 'c1.xlarge', 'c3.xlarge' then worker_count = 40
  else worker_count = 10
  end

  template "/data/#{appname}/shared/config/custom_unicorn.rb" do
    source "custom_unicorn.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    backup 0
    variables({
      :worker_count => worker_count
    })
    notifies :restart, resources(:service => "unicorn_#{appname}")
  end
end
