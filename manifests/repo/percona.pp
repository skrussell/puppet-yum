# = Class: yum::repo::percona
#
# This class installs the Percona RPM Repository
#
class yum::repo::percona {
	$base_url = 'http://repo.percona.com/yum/release'
	if ($facts['os']['name'] == 'CentOS') {
		$use_base_url = "${base_url}/${downcase($facts['os']['name'])}"
	} else {
		$use_base_url = $base_url
	}
	yum::managed_yumrepo { 'percona':
		descr          => 'Percona RPM Repository (http://www.percona.com/percona-lab.html)',
		baseurl        => "${use_base_url}/\$releasever/os/\$basearch/",
		enabled        => 1,
		gpgcheck       => 1,
		failovermethod => 'priority',
		gpgkey         => 'https://repo.percona.com/yum/PERCONA-PACKAGING-KEY',
		priority       => 1,
	}
}
