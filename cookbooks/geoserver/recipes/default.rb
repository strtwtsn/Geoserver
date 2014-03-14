package "unzip"

remote_file "Download Tomcat" do
path "/home/ubuntu/downloads/geoserver-2.4.5-war.zip"
source "http://sourceforge.net/projects/geoserver/files/GeoServer/2.4.5/geoserver-2.4.5-war.zip"
end

service "tomcat7" do
  service_name "tomcat7"
  supports :restart => true, :status => true, :reload => true
end

bash "Extract Geoserver" do
user "root"
code <<-EOH
unzip /home/ubuntu/downloads/geoserver-2.4.5-war.zip
sudo service /etc/init.d/tomcat7 stop
cp /home/ubuntu/downloads/geoserver.war /var/lib/tomcat7/webapps/
mkdir /geoserver_data/
chown -R tomcat7:tomcat7 /geoserver_data/
echo -e \"% export GEOSERVER_DATA_DIR=/geoserver_data\" | sudo tee -a /root/.bashrc
echo -e \"CATALINA_OPTS=\"-DGEOSERVER_DATA_DIR=/geoserver_data\"\" | sudo tee -a /usr/share/tomcat7/bin/setclasspath.sh
EOH
end

template "/var/lib/tomcat7/webapps/geoserver/WEB-INF/web.xml" do
source "web.xml.erb"
notifies :restart, resources(:service => "tomcat7"), :immediately
end


service "tomcat7" do
  action :restart
end

