#
# This class installs the Hewlett Packard Enterprise Management Component Pack (MCP) repo
#
class yum::repo::hpe::mcp (
	Enum['present','absent'] $ensure = 'present',
	String $repo_name = 'mcp',
	Stdlib::HTTPUrl $baseurl = "${yum::repo::hpe}/${repo_name}",
	Enum['current','12.05','11.30','11.21','11.05','10.62','10.50','10.40','10.20'] $version = 'current'
) inherits yum::repo::hpe {
	$distroname = $facts['os']['name'] ? {
		/(?i:Asianux|CentOS|Fedora|OracleLinux|openSUSE)/ => $facts['os']['name'].downcase,
		/(?i:RedHat|SLES)/                                => fail('HPe MCP repo is not availae for this OS - use SPP instead'),
		default                                           => fail('This OS is not supported')
	}

	$repo_url = "${baseurl}/${distroname}/\$releasever/${facts['os']['architecture']}/${version}"

	yum::managed_yumrepo { "${yum::repo::hpe::repo_basename}-${repo_name}":
			ensure        => $ensure,
			descr         => 'HPE - Management Component Pack',
			baseurl       => $repo_url,
			enabled       => 1,
			gpgcheck      => 0,
			gpgkey        => 'present',
			gpgkey_source => $yum::repo::hpe::gpg_keys
	}
}
