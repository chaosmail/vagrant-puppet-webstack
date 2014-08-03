if $config == undef {
	$config = loadyaml('/vagrant/config.yaml')
}

# Setup MySQL
# https://forge.puppetlabs.com/puppetlabs/mysql

$databases = {
  "${config['db_name']}" => {
    ensure  => 'present',
    charset => 'utf8',
  },
}

$users = {
  "${config['db_user']}@localhost" => {
    ensure                   => 'present',
    max_connections_per_hour => '0',
    max_queries_per_hour     => '0',
    max_updates_per_hour     => '0',
    max_user_connections     => '0',
  },
}

$grants = {
  "${config['db_user']}@localhost/${config['db_name']}.*" => {
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => "${config['db_name']}.*",
    user       => "${config['db_user']}@localhost",
  },
}

class { 'mysql::server':
  root_password    => 'root',
  override_options => { 'mysqld' => { 'max_connections' => '1024' } },
  users 		   => $users,
  grants 		   => $grants,
  databases 	   => $databases,
}