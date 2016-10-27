#
# Cookbook Name:: resque
# Recipe:: default
#
if ['solo', 'util'].include?(node[:instance_role])
  if node[:name] == 'generic_utility' || node[:name] == 'resque_finalize'
    execute "install resque gem" do
      command "gem install resque redis redis-namespace yajl-ruby -r"
      not_if { "gem list | grep resque" }
    end

    if node[:name] == 'generic_utility'
      case node[:ec2][:instance_type]
      when 'm1.medium', 'm3.medium', 'c1.medium' then worker_count = 8
      when 'm1.large', 'm3.large', 'c1.large', 'c3.large'  then worker_count = 13
      else worker_count = 5
      end
    elsif node[:name] == 'resque_finalize'
      case node[:ec2][:instance_type]
      when 'm1.small', 'm3.small'  then worker_count = 5
      when 'm1.medium', 'm3.medium', 'c1.medium' then worker_count = 10
      when 'm1.large', 'm3.large', 'c1.large', 'c3.large'  then worker_count = 20
      when 'm1.xlarge', 'm3.xlarge', 'c1.xlarge', 'c3.xlarge' then worker_count = 40
      when 'm1.2xlarge', 'm3.2xlarge', 'c1.2xlarge', 'c3.2xlarge' then worker_count = 80
      else worker_count = 5
      end
    else
      worker_count = 0
    end

    node[:applications].each do |app, data|
      template "/etc/monit.d/resque_#{app}.monitrc" do
        owner 'root'
        group 'root'
        mode 0644
        source "monitrc.conf.erb"
        variables({
        :num_workers => worker_count,
        :app_name => app,
        :rails_env => node[:environment][:framework_env]
        })
      end

      worker_count.times do |count|
        template "/data/#{app}/shared/config/resque_#{count}.conf" do
          owner node[:owner_name]
          group node[:owner_name]
          mode 0644
          source "#{node[:name]}_#{node[:name] == 'resque_finalize' ? count%5 : count}.conf.erb"
        end
      end

      execute "ensure-resque-is-setup-with-monit" do
        epic_fail true
        command %Q{
        monit reload
        }
      end
    end
  end
end
