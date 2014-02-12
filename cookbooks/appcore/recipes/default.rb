#
# Cookbook Name:: appcore
# Recipe:: default
#

require_recipe "appcore::cron"

enable_package "app-text/pdftk-bin" do
  version "1.44"
end

package "app-text/pdftk-bin" do
  action :install
end

remote_file "/usr/bin/pdftk" do
  owner "root"
  group "root"
  mode 0755
  source "pdftk"
end
