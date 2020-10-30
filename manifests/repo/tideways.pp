# = Class: yum::repo::tideways
#
# This class installs the tideways repo
#
class yum::repo::tideways {
	$repo_name = 'tideways'

	$gpg_key_basename = 'RPM-GPG-KEY-tideways'

	yum::managed_yumrepo { $repo_name:
		descr         => 'Tideways RPM repository for Redhat/Fedora/CentOS',
		baseurl       => 'https://packages.tideways.com/yum-packages-main',
		enabled       => 1,
		gpgcheck      => 1,
		gpgkey        => 'present',
		gpgkey_source => { 'https://packages.tideways.com/key.gpg' => "${gpg_key_basename}-new", 'https://s3-eu-west-1.amazonaws.com/tideways/packages/EEB5E8F4.gpg' => $gpg_key_basename },
		priority      => 1,
		notify        => Exec[ "yum_clean_${repo_name}_cache" ]
	}

	exec { "yum_clean_${repo_name}_cache":
		command     => "yum clean all --disablerepo='*' --enablerepo='${repo_name}'",
		refreshonly => true
	}
}
