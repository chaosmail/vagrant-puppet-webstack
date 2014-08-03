if $config == undef {
	$config = loadyaml('/vagrant/config.yaml')
}

# Setup Upstart
# https://github.com/bison/puppet-upstart

include upstart

# upstart::job { "${config['project_name']}d":
#   description    => "Launch ${config['project_name']} as a service",
#   version        => "3626f2",
#   start_on		   => 'vagrant-ready',
#   respawn        => true,
#   respawn_limit  => '5 10',
#   user           => 'vagrant',
#   group          => 'vagrant',
#   chdir          => "/var/www/${config['project_name']}/${config['public_root']}",
#   exec           => "command to start service",
# }