#
# Cookbook Name:: appcore
# Recipe:: default
#

require_recipe "appcore::cron"

execute "ensure required directories" do
  command "mkdir -p /data/appcore/shared/locales"
  command "mkdir -p /data/appcore/shared/storage"
end
