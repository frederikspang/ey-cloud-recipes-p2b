#
# Cookbook Name:: sftp
# Recipe:: default
#

if ['solo', 'app_master', 'app'].include?(node[:instance_role])

  group "sftp"

  directory "/data/sftp" do
    owner node[:owner_name]
    group node[:owner_name]
    mode "0755"
    action :create
  end

  directory "/data/sftp" do
    owner 'deploy'
    group 'jails'
    mode "0755"
  end

  template "/etc/ssh/sshd_config" do
    source "sshd_config_sftp.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      :app_user => node[:owner_name],
      :users => node[:sftp][:users]
    })
  end

  remote_file "/root/sftp-setup.sh" do
    owner "root"
    group "root"
    source "sftp-setup.sh"
    mode 0755
  end

  node[:sftp][:users].each do |user|
    execute "sftp-setup" do
      command "/root/sftp-setup.sh #{user}"
      not_if "grep -c '#{user}:' /etc/passwd"
    end

    # create directories specified in attributes
    node[:sftp]["directories_#{user}"].each do |dir|
      directory "/home/jails/#{user}/public/#{dir}" do
        owner "deploy"
        group "jails"
        mode 0775
        recursive true
        action :create
      end
    end

    link "/data/sftp/#{user}" do
      to "/home/jails/#{user}/public/"
    end
  end

  execute "add-app-user-to-jails-group" do
    command "usermod -G #{node[:owner_name]},jails #{node[:owner_name]}"
  end

  execute "restart-sshd" do
    command "/etc/init.d/sshd restart"
  end

end