# = Class: yum::repo::remi_php74
#
# This class installs the remi-php74 repo
#
class yum::repo::remi_php74 {
  $releasever = $::operatingsystem ? {
    /(?i:Amazon)/ => '6',
    default       => '$releasever',  # Yum var
  }

  $os = $::operatingsystem ? {
    /(?i:Fedora)/ => 'fedora',
    default       => 'enterprise',
  }

  $osname = $::operatingsystem ? {
    /(?i:Fedora)/ => 'Fedora',
    default       => 'Enterprise Linux',
  }

  yum::managed_yumrepo { 'remi-php74':
    descr      => "Remi's PHP 7.4 RPM repository for ${osname} \$releasever - \$basearch",
    mirrorlist => "http://rpms.remirepo.net/${os}/${releasever}/php74/mirror",
    enabled    => 1,
    gpgcheck   => 1,
    gpgkey     => 'http://rpms.remirepo.net/RPM-GPG-KEY-remi',
    priority   => 1,
  }
}
