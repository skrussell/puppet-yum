# = Class: yum::repo::erlang
#
# This class installs the erlang repository from Erlang Solutions
#
class yum::repo::erlang {
  yum::managed_yumrepo { 'erlang':
    descr          => 'Erlang solutions official repository for RHEL and Cent OS - $basearch',
    baseurl        => 'http://packages.erlang-solutions.com/rpm/centos/$releasever/$basearch',
    enabled        => 1,
	failovermethod => 'priority',
	priority       => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-erlang',
    gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-erlang'
  }
}
