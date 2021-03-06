class cls_ej4 {
	host { 'localhost':
		ensure       => 'present',
		target       => '/etc/hosts',
		ip           => '127.0.0.1',
		host_aliases => [
		  'mysql1',
		  'memcached1'
		]
	}

	# PHP
	include ::yum::repo::remi
	package { 'libzip-last':
		require => Yumrepo['remi']
	}

	class{ '::yum::repo::remi_php56':
		require => Package['libzip-last']
	}

	class { 'php':
		version => 'latest',
		require => Yumrepo['remi-php56'],
	}

	php::module { [ 'devel', 'pear', 'xml', 'mbstring', 'pecl-memcache', 'soap' ]: }

	# Apache
	class{ 'apache': }

	apache::vhost { 'centos.dev':
		port    => '80',
		docroot => '/var/www',
	}

	apache::vhost { 'project1.dev':
		port    => '80',
		docroot => '/var/www/project1',
	}

	# MYSQL
	class { '::mysql::server':
		root_password    => 'vagrantpass',
	}

	mysql::db { 'mpwar_test':
		user     => 'mpwardb',
		password => 'mpwardb',
	}

}
