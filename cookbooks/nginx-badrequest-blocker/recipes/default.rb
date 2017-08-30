if ['app_master', 'app', 'solo'].include?(node[:instance_role])

  # Set temp file with config to be added
  remote_file "/tmp/nginx_blocking_append.conf" do
    user "deploy"
    source "nginx_blocking_append.txt"
  end

  node[:applications].each do |app, data|
    Execute "Clean up Nginx blocking config from earlier runs" do
      user "deploy"
      command "sed -i.bak '/#---BOT-REQUEST_BLOCKING-START/,/#---BOT-REQUEST_BLOCKING-END/d' /data/nginx/servers/#{app}/custom.conf && rm /data/nginx/servers/#{app}/custom.conf.bak"
    end

    Execute "Config Nginx to block bots/ips" do
      user "deploy"
      command "cat /tmp/nginx_blocking_append.conf >> /data/nginx/servers/#{app}/custom.conf"
    end

    Execute "Config Nginx to block bots/ips" do
      user "deploy"
      command "cat /tmp/nginx_blocking_append.conf >> /data/nginx/servers/#{app}/custom.ssl.conf"
    end
  end

  Execute "Remove nginx_blocking_append temp file" do
    command "rm /tmp/nginx_blocking_append.conf"
  end

  Execute "Reload nginx config" do
    command "sudo /etc/init.d/nginx reload"
  end

end
