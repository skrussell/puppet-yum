#
# Defined type for easily managing a remi repository for a specific PHP version
#
define yum::repos::remi_php_repo (
	Pattern[/\A[57]\.\d\z/] $version = $name,
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

	$version_short = regsubst($version, '\.', '')

	if ($mirror_url) {
		$use_mirrorlist = 'absent'
		$use_baseurl    = $mirror_url
	} else {
		$mirror_list_base_url = "http://rpms.remirepo.net/${os}/${releasever}/php${version_short}"
		$use_mirrorlist = $facts['os']['release']['major'] ? {
			8       => "${mirror_list_base_url}/\$basearch/mirror",
			default => "${mirror_list_base_url}/mirror"
		}
		$use_baseurl    = 'absent'
	}

	yum::managed_yumrepo { "remi-php${version_short}":
		descr      => "Remi's PHP ${version} RPM repository for ${osname} \$releasever - \$basearch",
		baseurl    => $use_baseurl,
		mirrorlist => $use_mirrorlist,
		enabled    => 1,
		gpgcheck   => 1,
		gpgkey     => 'http://rpms.remirepo.net/RPM-GPG-KEY-remi',
		priority   => 1,
	}
}
