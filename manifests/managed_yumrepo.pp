# = Define yum::managed_yumrepo
#
define yum::managed_yumrepo (
	Enum['present','absent'] $ensure = 'present',
	Variant[Enum['absent'],String[1]] $descr = 'absent',
	Variant[Enum['absent'],Yum::Url] $baseurl = 'absent',
	Variant[Enum['absent'],Yum::Url] $mirrorlist = 'absent',
	Variant[Enum['absent'],Yum::Url] $metalink = 'absent',
	Yum::Boolean $enabled = 0,
	String $file_name = $name,
	Yum::Boolean $gpgcheck = 0,
	Variant[Enum['present','absent'],Yum::Url,Array[Yum::Url]] $gpgkey = 'absent',
	Optional[Variant[Stdlib::Filesource,Array[Stdlib::Filesource,1],Hash[Stdlib::Filesource,String,1]]] $gpgkey_source = undef,
	Optional[String[1]] $gpgkey_name = undef,
	Enum['absent','roundrobin','priority'] $failovermethod = 'absent',
	Integer $priority = 99,
	Variant[Enum['absent'],Yum::Boolean] $protect = 'absent',
	Variant[Enum['absent'],String[1]] $exclude = 'absent',
	Enum['yes','no'] $autokeyimport = 'no',
	Variant[Enum['absent'],String[1]] $includepkgs = 'absent',
	Variant[Enum['absent','never'],Pattern[/^[0-9]+[dhm]$/],Integer[0]] $metadata_expire = 'absent',
	Variant[Enum['absent'],String[1]] $include = 'absent',
	Variant[Enum['absent'],Yum::Boolean] $repo_gpgcheck = 'absent',
	Variant[Enum['absent'],Pattern[$re::path]] $sslcacert = 'absent',
	Variant[Enum['absent'],Pattern[$re::path]] $sslclientcert = 'absent',
	Variant[Enum['absent'],Pattern[$re::path]] $sslclientkey = 'absent',
	Variant[Enum['absent'],Yum::Boolean] $sslverify = 'absent'
) {

	# ensure that everything is setup
	include ::yum::prerequisites

	if ($protect != 'absent') {
		if ! defined(Yum::Plugin['protectbase']) {
			yum::plugin { 'protectbase': }
		}
	}

	if ($mirrorlist != 'absent' and $metalink != 'absent') {
		fail('Should not supply both metalink and mirrorlist arguments')
	}

	$file_ensure = $ensure ? {
		'present' => 'file',
		default   => $ensure
	}

	# Turns out the yumrepo target support is not yet implemented! Need to use independant files
	# until it is implemented (bug open since 2014, so fat chance of that anytime soon...)
	#$repo_target_file = "/etc/yum.repos.d/${file_name}.repo"
	$repo_target_file = "/etc/yum.repos.d/${name}.repo"

	if (! defined(File[$repo_target_file])) {
		file { $repo_target_file:
			ensure  => $file_ensure,
			replace => false,
			before  => Yumrepo[ $name ],
			mode    => '0644',
			owner   => 'root',
			group   => 0,
		}

		if ($gpgkey != 'absent') {
			if ($gpgkey_source) {
				if ($gpgkey_source =~ Hash) {
					$gpg_keys = $gpgkey_source
				} elsif ($gpgkey_source =~ Array) {
					$gpg_keys = $gpgkey_source.map |Integer $idx, Stdlib::Filesource $g_k_s| {
						if ($gpgkey_name) {
							$g_k_n = "${gpgkey_name}-${idx}"
						} else {
							$g_k_n = url_parse($g_k_s,'filename')
						}
						$res = { $g_k_s => $g_k_n }
						$res
					}.flatten_array_of_hashes_to_hash
				} else {
					$gpgkey_real_name = $gpgkey_name ? {
						undef   => url_parse($gpgkey_source,'filename'),
						default => $gpgkey_name,
					}
					$gpg_keys = { $gpgkey_source => $gpgkey_real_name }
				}

				$gpg_keys.each |Stdlib::Filesource $g_k_s, String $g_k_n| {
					$gpg_key_file = "${yum::params::gpg_key_store}/${g_k_n}"
					if ! defined(File[$gpg_key_file]) {
						file { $gpg_key_file:
							ensure  => $file_ensure,
							mode    => '0644',
							owner   => 'root',
							group   => 'root',
							replace => false,
							source  => $g_k_s,
							before  => Yumrepo[ $name ]
						}
					}
				}
				$use_gpg_key_files = $gpg_keys.map |Stdlib::Filesource $g_k_s, String $g_k_n| {
					"file://${yum::params::gpg_key_store}/${g_k_n}"
				}
			} else {
				if ($gpgkey == 'present') {
					fail('Can not pass "gpgkey = present" without specifying gpgkey_source too')
				} else {
					$use_gpg_key_files = $gpgkey
				}
			}
		} else {
			$use_gpg_key_files = $gpgkey
		}

		$use_gpgkey = $use_gpg_key_files ? {
			Array   => join($use_gpg_key_files, ' '),
			default => $use_gpg_key_files
		}
	} else {
		$use_gpgkey = $gpgkey
	}

	if ($yum::priorities_plugin) {
		$use_priority = $priority
		$use_failover = $failovermethod
	} else {
		if ($failovermethod == 'priority') {
			warning("It' useless setting the 'failovermethod' to 'priority' when the yum priorities plugin is disable. Setting to 'absent' for repo: ${name}")
			$use_failover = 'absent'
		} else {
			$use_failover = $failovermethod
		}
		$use_priority = undef
	}

	if ($repo_gpgcheck =~ Yum::Boolean::True) {
		package { 'pygpgme':
			ensure => 'installed'
		}
	}

	if (! defined(Yumrepo[$name])) {
		yumrepo { $name:
			ensure          => $ensure,
			descr           => $descr,
			baseurl         => $baseurl,
			mirrorlist      => $mirrorlist,
			metalink        => $metalink,
			enabled         => $enabled,
			gpgcheck        => $gpgcheck,
			gpgkey          => $use_gpgkey,
			failovermethod  => $use_failover,
			priority        => $use_priority,
			protect         => $protect,
			exclude         => $exclude,
			includepkgs     => $includepkgs,
			metadata_expire => $metadata_expire,
			include         => $include,
			repo_gpgcheck   => $repo_gpgcheck,
			sslcacert       => $sslcacert,
			sslclientcert   => $sslclientcert,
			sslclientkey    => $sslclientkey,
			sslverify       => $sslverify,
			target          => $repo_target_file
		}

		if ($ensure == 'present' and $autokeyimport == 'yes' and $gpgkey != 'absent') {
			if (! defined(Exec["rpmkey_add_${use_gpgkey}"])) {
				exec { "rpmkey_add_${use_gpgkey}":
					command     => "rpm --import ${use_gpgkey}",
					before      => Yumrepo[ $name ],
					refreshonly => true,
					path        => '/sbin:/bin:/usr/sbin:/usr/bin',
				}
			}
		}
	}
}
