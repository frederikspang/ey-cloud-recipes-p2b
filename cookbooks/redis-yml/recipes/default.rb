if ['app_master', 'app', 'util'].include?(node[:instance_role])
  redis_instance = node['utility_instances'].find { |instance| instance['name'] == 'generic_utility' }

  if redis_instance
    node[:applications].each do |app, data|
      template "/data/#{app}/shared/config/redis.yml"do
        source 'redis.yml.erb'
        owner node[:owner_name]
        group node[:owner_name]
        mode 0655
        backup 0
        variables({
          :environment => node[:environment][:framework_env],
          :hostname => redis_instance[:hostname]
        })
      end
    end
  end
end
