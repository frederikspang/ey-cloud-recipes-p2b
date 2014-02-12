#
# Cookbook Name:: appcore
# Recipe:: cron
#

if node[:environment][:framework_env] == "production" && ['app_master'].include?(node[:instance_role])

  node[:applications].each do |app, data|
    
    template "/etc/cron.d/reboot_cron" do 
      owner 'root' 
      group 'root' 
      mode 0644 
      source "reboot_cron.erb" 
      variables({ 
      :app_name => app, 
      :framework_env => node[:environment][:framework_env] 
    })
    end

    cron "copy-production-logs" do
      user node[:owner_name]
      minute "0"
      hour "5"
      day "*"
      month "*"
      weekday "*"
      command "/data/#{app}/shared/bin/copy_production_logs.sh > /dev/null 2>&1"
      action :create
    end
  
  end
  
end