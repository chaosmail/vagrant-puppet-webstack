if $config == undef {
	$config = loadyaml('/vagrant/config.yaml')
}

$www_root = "/var/www/${config['project_name']}/${config['public_root']}"

# Setup NGINX Webserver
# https://forge.puppetlabs.com/jfryman/nginx

class { 'nginx': }

# Configure Virtual host
nginx::resource::vhost { "www.${config['project_name']}.dev":
	ensure       			=> present,
	www_root 				=> $www_root,
	listen_port 			=> $config['listen_port'],
	rewrite_www_to_non_www 	=> true,
	index_files   			=> [ 'index.php' ],
	access_log 				=> "/var/log/nginx/${config['project_name']}_access.log",
	error_log 				=> "/var/log/nginx/${config['project_name']}_error.log",
}

# Configure PHP-FPM
nginx::resource::location { ".php":
	ensure          => present,
	vhost           => "www.${config['project_name']}.dev",
	www_root 		=> $www_root,
	location  	    => '~ \.php$',
	fastcgi         => "127.0.0.1:9000",
}

# Configure FastCGI Params Workaround
# $app_env = $config['app_env']
# Append this in modules/nginx/templates/vhost/fastcgi_params.erb
# <% if @app_env %>
# fastcgi_param	APP_ENV 			<%= @app_env %>;
# <% end %>