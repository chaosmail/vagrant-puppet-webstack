if $config == undef {
	$config = loadyaml('/vagrant/config.yaml')
}

# Setup Git
# https://forge.puppetlabs.com/puppetlabs/git

include git

git::config { 'user.name':
  value => $config['author_name'],
  require => Package['git'],
}

git::config { 'user.email':
  value => $config['author_email'],
  require => Package['git'],
}