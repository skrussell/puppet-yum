# = Class: yum::repo::puppet5
#
# This class installs the puppet5 repo
#
class yum::repo::puppetlabs5 (
  $baseurl    = '',
  $collection = '1',
  $priority   = 99,
) {
  $osver = $::operatingsystem ? {
    'XenServer' => [ '5' ],
    default     => split($::operatingsystemrelease, '[.]')
  }
  $release = $::operatingsystem ? {
    /(?i:Centos|RedHat|Scientific|CloudLinux|XenServer)/ => $osver[0],
    default                                              => '6',
  }

  $real_baseurl = $baseurl ? {
    ''      => "http://yum.puppetlabs.com/puppet5/el/${release}/\$basearch",
    default => $baseurl,
  }

  yum::managed_yumrepo { 'puppet5':
    descr          => 'Puppet 5 Repository el 7 - $basearch',
    baseurl        => $real_baseurl,
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppet5',
    gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-puppet5',
    priority       => $priority,
  }

}
