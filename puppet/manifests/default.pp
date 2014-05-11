# Variables
$home = "/home/vagrant"
$execute_as_vagrant = "sudo -u vagrant -H bash -l -c"
# user "mysql" or "mongodb"
$database = "mysql"

# Set default binary paths 
Exec {
	path => [ "/usr/bin", "/usr/local/bin" ]
}


# Prepare system before main stage
stage { "init": }

class update_apt {
	exec { "apt-get -y update": }
}

class{ "update_apt" :
	stage => init,
}

Stage[ "init" ] -> Stage[ "main" ]


# Main packages
package { "vim":
	ensure => "present",
}

package { "git":
	ensure => "present",
}

package { "build-essential":
	ensure => "present",
}

package { "python-software-properties":
	ensure => "present",
}

package { "imagemagick":
	ensure => "present",
}

package { "curl":
	ensure => "present",
}

# Install apache
class { "apache": }

apache::vhost{ "default":
	docroot => "/var/www/app",
	directory => "/var/www/app",
	server_name => false,
	priority => "",
	directory_allow_override => "All",
	directory_options => "Indexes FollowSymLinks MultiViews",
	template => "apache/virtualhost/vhost.conf.erb",
}

apache::module{ "rewrite": }

# Install database
#case $database {
	#"mongodb" : {
		#class { "::mongodb::server":
			#auth => true,
		#}
		#mongodb::db { "app":
			#user => "root",
			#password => "root",
		#}
	#}
#}
