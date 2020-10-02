# = Class: yum::repo::remi_modular
#
# This class installs the remi EL8 modular repo
#
class yum::repo::remi_modular (
	Optional[String] $mirror_url = undef
) {
	if ($facts['os']['release']['major'] != '8') {
		fail('The remi_modular yum repo is only meant for RedHat/CentOS 8 repos')
	}

	if ($mirror_url) {
		$use_baseurl    = $mirror_url
		$use_mirrorlist = 'absent'
	} else {
		$use_baseurl    = 'absent'
		$use_mirrorlist = 'http://cdn.remirepo.net/enterprise/8/modular/$basearch/mirror'
	}

	yum::managed_yumrepo { 'remi-modular':
		descr      => 'Remi\'s Modular repository for Enterprise Linux 8 - $basearch',
		baseurl    => $use_baseurl,
		mirrorlist => $use_mirrorlist,
		enabled    => 1,
		gpgcheck   => 1,
		gpgkey     => 'http://rpms.remirepo.net/RPM-GPG-KEY-remi2018',
		priority   => 1
	}
}
