# = Class: yum::repo::atomic
#
# This class installs the atomic repo
#
class yum::repo::atomic {
  $os = downcase($facts['os']['name'])

  yum::managed_yumrepo { 'atomic':
    descr         => 'CentOS / Red Hat Enterprise Linux $releasever - atomicrocketturtle.com',
    mirrorlist    => "http://updates.atomicorp.com/channels/mirrorlist/atomic/${os}-\$releasever-\$basearch",
    enabled       => 1,
    gpgcheck      => 1,
#    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY.art',
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY.atomicorp',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY.atomicorp',
    priority      => 1,
    exclude       => 'nmap-ncat',
  }
}
