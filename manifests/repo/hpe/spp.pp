#
# This class installs the Hewlett Packard Enterprise Service Pack for Prolient (SPP) repo
#
class yum::repo::hpe::spp (
	Pattern[/\A(G7|Gen(1[0-9]|[89]))\z/] $hw_gen,
	Enum['present','absent'] $ensure = 'present',
	String $repo_name = 'spp',
	Stdlib::HTTPUrl $baseurl = "${yum::repo::hpe::baseurl}/${repo_name}-${hw_gen.downcase}",
	String $version = 'current'
) inherits yum::repo::hpe {
	$distroname = $facts['os']['name'] ? {
		/(?i:Asianux|CentOS|Fedora|OracleLinux|openSUSE)/ => fail('HPe SPP repo is not availae for this OS - use MCP instead'),
		/(?i:RedHat)/                                     => 'rhel',
		/(?i:SLES)/                                       => 'suse',
		default                                           => fail('This OS is not supported')
	}

	$valid_vers_gen10 = ['current','next','2020.05.0','2020.09.0','2020.03.0','2019.12.0','2019.09.0','2019.03.0','2018.11.0','2018.09.0']
	$valid_vers_gen9  = $valid_vers_gen10
	$valid_vers_gen8  = ['current','gen8.1_hotfix9','g7.1_hotfix3','2017.07.1','2017.04.0','2016.10.0','2016.04.0']
	$valid_vers_g7    = $valid_vers_gen8

	$valid_vers = getparam("valid_vers_${hw_gen.downcase}")

	if (!($version in $valid_vers)) {
		fail("'${version}' is not a valid version for ${hw_gen} hardware")
	}

	$repo_url = "${baseurl}/${distroname}/\$releasever/${facts['os']['architecture']}/${version}"

	yum::managed_yumrepo { "${yum::repo::hpe::repo_basename}-${repo_name}":
			ensure        => $ensure,
			descr         => 'HPE - Service Pack for Prolient',
			baseurl       => $repo_url,
			enabled       => 1,
			gpgcheck      => 0,
			gpgkey        => 'present',
			gpgkey_source => $yum::repo::hpe::gpg_keys
	}
}
