# = Class: yum::repo::rabbitmq_server
#
# This class installs the RabbitMQ Server repo
#
class yum::repo::rabbitmq_server {
	yum::managed_yumrepo { 'rabbitmq_rabbitmq-server':
		descr           => 'rabbitmq_rabbitmq-server',
		baseurl         => 'https://packagecloud.io/rabbitmq/rabbitmq-server/el/$releasever/$basearch',
		enabled         => 1,
		failovermethod  => 'priority',
		priority        => 1,
		gpgcheck        => 0,
		repo_gpgcheck   => 1,
		gpgkey          => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rabbitmq',
		gpgkey_source   => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rabbitmq',
		metadata_expire => 300,
		sslverify       => 1,
		sslcacert       => '/etc/pki/tls/certs/ca-bundle.crt'
	}
	yum::managed_yumrepo { 'rabbitmq_rabbitmq-server-source':
		descr           => 'rabbitmq_rabbitmq-server-source',
		baseurl         => 'https://packagecloud.io/rabbitmq/rabbitmq-server/el/$releasever/SRPMS',
		enabled         => 1,
		failovermethod  => 'priority',
		priority        => 1,
		gpgcheck        => 0,
		repo_gpgcheck   => 1,
		gpgkey          => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rabbitmq',
		gpgkey_source   => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rabbitmq',
		metadata_expire => 300,
		sslverify       => 1,
		sslcacert       => '/etc/pki/tls/certs/ca-bundle.crt'
	}
}
