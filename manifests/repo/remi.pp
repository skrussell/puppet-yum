# = Class: yum::repo::remi
#
# This class installs the remi repo
#
class yum::repo::remi (
	Optional[String] $mirror_url = undef
) {
	$releasever = $::operatingsystem ? {
		/(?i:Amazon)/ => '6',
		default       => '$releasever',  # Yum var
	}

	$os = $::operatingsystem ? {
		/(?i:Fedora)/ => 'fedora',
		default       => 'enterprise',
	}

	$osname = $::operatingsystem ? {
		/(?i:Fedora)/ => 'Fedora',
		default       => 'Enterprise Linux',
	}

	if ($mirror_url) {
		$use_baseurl    = $mirror_url
		$use_mirrorlist = 'absent'
	} else {
		$mirror_list_base_url = "http://rpms.remirepo.net/${os}/${releasever}/remi"
		$use_baseurl          = 'absent'
		$use_mirrorlist       = $facts['os']['release']['major'] ? {
			'8'     => "${mirror_list_base_url}/\$basearch/mirror",
			default => "${mirror_list_base_url}/mirror"
		}
	}

	yum::managed_yumrepo { 'remi':
		descr      => "Remi's RPM repository for ${osname} \$releasever - \$basearch",
		baseurl    => $use_baseurl,
		mirrorlist => $use_mirrorlist,
		enabled    => 1,
		gpgcheck   => 1,
		gpgkey     => 'http://rpms.remirepo.net/RPM-GPG-KEY-remi',
		priority   => 1,
	}
}
