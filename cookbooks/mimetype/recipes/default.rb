if ['solo', 'app_master', 'app'].include?(node[:instance_role])

  execute "add mime type" do
    command "sed -ie '/}/i \    text/cache-manifest manifest;' /etc/nginx/mime.types"
    not_if "grep 'text/cache-manifest' /etc/nginx/mime.types"
  end

  execute "/etc/init.d/nginx reload"
end

#set timeout in appcore.conf and appcore.ssl.conf
#location ~* \.manifest$ {
#    expires 1h;
#  }
