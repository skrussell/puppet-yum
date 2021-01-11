# = Class: yum::repo::endpoint
#
# This class installs the End Point repo
#
class yum::repo::endpoint (
	Optional[String] $mirror_url = undef
) {
	if ($mirror_url) {
		$use_baseurl = $mirror_url
	} else {
		$use_baseurl = 'https://packages.endpoint.com/rhel/$releasever/os/$basearch/'
	}

	$gpg_file_basename = 'RPM-GPG-KEY-endpoint'
	if ($facts['os']['family'] != 'RedHat') {
		fail('This OS is not supported by the End Point Repository')
	} else {
		if (versioncmp($facts['os']['release']['major'], '7') > 0) {
			fail('This OS version is not supported by the End Point Repository')
		} else {
			if (versioncmp($facts['os']['release']['major'], '7') == 0) {
				$gpg_filename = "${gpg_file_basename}-7"
			} else {
				$gpg_filename = $gpg_file_basename
			}
		}
	}

	yum::managed_yumrepo { 'endpoint':
		baseurl        => $use_baseurl,
		descr          => 'End Point repository',
		enabled        => 1,
		gpgcheck       => 1,
		gpgkey         => "file:///etc/pki/rpm-gpg/${gpg_filename}" ,
		gpgkey_source  => "puppet:///modules/yum/rpm-gpg/${gpg_filename}",
		priority       => 1
	}

}

