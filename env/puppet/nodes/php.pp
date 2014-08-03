if $config == undef {
	$config = loadyaml('/vagrant/config.yaml')
}

# Setup PHP
# https://forge.puppetlabs.com/thias/php

include php::cli
include php::fpm::daemon

php::ini { '/etc/php.ini':
  display_errors => 'On',
  memory_limit   => '256M',
}

php::fpm::conf { 'www':
  listen  => '127.0.0.1:9000',
  user    => 'nginx',
  require => Package['nginx'],
  env 	  => [{'APP_ENV' => $config['app_env']}],
}

# Create symlink to mcrypt.ini
# http://stackoverflow.com/questions/19446679/mcrypt-not-present-after-ubuntu-upgrade-to-13-10
# file { '/etc/php5/mods-available/mcrypt.ini':
#    ensure => 'link',
#    target => '/etc/php5/conf.d/mcrypt.ini',
# }

php::module { [ 'mcrypt', 'mysql', 'pgsql' ]: }

