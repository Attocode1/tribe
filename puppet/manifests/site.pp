Exec {
    path => [
    	'/usr/local/bin',
		'/opt/local/bin',
		'/usr/bin',
		'/usr/sbin',
		'/bin',
		'/sbin'
    ]
}

exec {'wget -O /tmp/wakanda-server.deb':
	command => 'wget -O /tmp/wakanda-server.deb http://www.andrewcare.ca/wakanda-server_4.129628_amd64.deb',
	creates => '/tmp/wakanda-server.deb'
}

package {'wakanda-server':
	require => Exec['wget -O /tmp/wakanda-server.deb'],
	ensure => installed,
	source => '/tmp/wakanda-server.deb',
	provider => 'dpkg'
}

file { '/etc/init/wakanda-server.conf':
	require => Package['wakanda-server'],
	ensure => file,
	source => '/vagrant/puppet/files/wakanda-server.conf'
}

service {'wakanda-server':
	require => [
		Package['wakanda-server'],
		File['/etc/init/wakanda-server.conf']
	],
	subscribe => File['/etc/init/wakanda-server.conf'],
	ensure => running,
	enable => true,
	hasrestart => true,
	hasstatus => true
}