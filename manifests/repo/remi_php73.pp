# = Class: yum::repo::remi_php73
#
# This class installs the remi-php73 repo
#
class yum::repo::remi_php73 {
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

  yum::managed_yumrepo { 'remi-php73':
    descr      => "Remi's PHP 7.3 RPM repository for ${osname} \$releasever - \$basearch",
    mirrorlist => "http://rpms.remirepo.net/${os}/${releasever}/php73/mirror",
    enabled    => 1,
    gpgcheck   => 1,
    gpgkey     => 'http://rpms.remirepo.net/RPM-GPG-KEY-remi',
    priority   => 1,
  }
}
