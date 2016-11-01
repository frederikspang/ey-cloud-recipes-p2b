#
# Cookbook Name:: le
# Recipe:: default
#
if node[:environment][:framework_env] == "production" && ['app_master'].include?(node[:instance_role])
  require_recipe 'le::install'
  require_recipe 'le::configure'
  require_recipe 'le::start'
end
