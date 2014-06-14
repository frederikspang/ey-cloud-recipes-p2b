#
# Cookbook Name:: appcore
# Recipe:: default
#

require_recipe "appcore::cron"

execute "ensure required directories" do
  command "mkdir -p /data/#{app}/shared/locales"
  command "mkdir -p /data/#{app}/shared/storage"
end
