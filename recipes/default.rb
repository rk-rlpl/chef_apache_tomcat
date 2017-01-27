#
# Cookbook:: apache_tomcat
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Install java
package 'java-1.7.0-openjdk-devel'

# Add a group Tomcat
group 'tomcat'

# Install user
user 'tomcat' do
  manage_home false
  shell '/bin/nologin'
  group 'tomcat'
  home '/opt/tomcat'

end

# Download Tomcat
# http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.tar.gz

remote_file 'apache-tomcat-8.5.11.tar.gz' do
  source 'http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.tar.gz'

end

directory '/opt/tomcat' do
  action :create
  group 'tomcat'
end

# TODO:
execute 'tar -C /opt/tomcat -xvzf apache-tomcat-8.5.11.tar.gz --strip-components=1 && cd /opt/tomcat'

#TODO
execute 'chgrp -R tomcat /opt/tomcat'

directory '/opt/tomcat/conf' do
  mode '0070'
end

#TODO:
execute 'cd /opt/tomcat && chmod g+r conf/*'

#TODO:
execute 'cd /opt/tomcat && chown -R tomcat webapps/ work/ temp/ logs/'

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

#TODO
execute 'systemctl daemon-reload'

#TODO
service 'tomcat' do
  action [:start, :enable]
end
