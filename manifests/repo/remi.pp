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

	$el8_key = 'http://rpms.remirepo.net/RPM-GPG-KEY-remi2018'
	$el7_key = 'http://rpms.remirepo.net/RPM-GPG-KEY-remi'
	if ($osname == 'Fedora') {
		if (versioncmp($facts['os']['release']['major'], '28') >= 0) {
			$use_gpg_url = $el8_key
		} elsif (versioncmp($facts['os']['release']['major'], '26') == 0 or versioncmp($facts['os']['release']['major'], '27') == 0) {
			$use_gpg_url = 'http://rpms.remirepo.net/RPM-GPG-KEY-remi2017'
		} else {
			$use_gpg_url = $el7_key
		}
	} else {
		$use_gpg_url = $facts['os']['release']['major'] ? {
			'8'     => $el8_key,
			default => $el7_key
		}
	}

	yum::managed_yumrepo { 'remi':
		descr      => "Remi's RPM repository for ${osname} \$releasever - \$basearch",
		baseurl    => $use_baseurl,
		mirrorlist => $use_mirrorlist,
		enabled    => 1,
		gpgcheck   => 1,
		gpgkey     => $use_gpg_url,
		priority   => 1,
	}
}
