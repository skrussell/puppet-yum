#
# class yum::repo::cdh6 - Sets-up the Cloudera 6 Repo
#
# @param version A specific version to lock to, or 6 (default) which is a link to the latest release at the time (default baseurl only)
# @param baseurl An overriding URL to use (must be a full Yum repository URL for the cdh6 packages)
# @param baseurl_extras An overriding URL to use (must be a full Yum repository URL for the gplextra6 packages)
class yum::repo::cdh6 (
	Pattern[/\A6(\.\d\d?){0,2}\z/] $version = '6.0.0',
	Optional[Stdlib::HTTPurl] $baseurl = undef
) {
	unless (($baseurl and $baseurl) or $facts['os']['hardware'] == 'x86_64') {
		fail('Only x86_84 packages are hosted in the cloudera repository')
	}
	if ($baseurl) {
		$use_baseurl = $baseurl
	} else {
		$use_baseurl = "https://archive.cloudera.com/cdh6/${version}/redhat${facts['os']['release']['major']}/yum/"
	}
	yum::managed_yumrepo { 'cloudera-cdh6':
		descr          => "Cloudera's Distribution for Hadoop, Version 6",
		baseurl        => $use_baseurl,
		enabled        => 1,
		gpgcheck       => 1,
		gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-cloudera',
		gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-cloudera',
		priority       => 20,
		failovermethod => 'priority',
	}
}
