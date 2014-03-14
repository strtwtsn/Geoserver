bash "Remove current java and instll new" do
code <<-EOH
sudo apt-get update
sudo apt-get install -y python-software-properties
sudo apt-get update
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install -y oracle-java7-installer
EOH
end

bash "Post install changes" do
code <<-EOH
echo -e \"JAVA_OPTS=\"-Djava.awt.headless=true -Xmx1024m\"\" | sudo tee -a /etc/default/tomcat7
echo -e \"TOMCAT7_SECURITY=no\" | sudo tee -a /etc/default/tomcat7
EOH
end

