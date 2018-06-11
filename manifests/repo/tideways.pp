# = Class: yum::repo::tideways
#
# This class installs the tideways repo
#
class yum::repo::tideways {
  yum::managed_yumrepo { 'tideways':
    descr         => 'Tideways RPM repository for Redhat/Fedora/CentOS',
    baseurl       => 'https://s3-eu-west-1.amazonaws.com/qafoo-profiler/rpm',
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-tideways',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-tideways',
    priority      => 1,
  }
}
