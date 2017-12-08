# = Define yum::versionlock
#
define yum::versionlock (
	Enum['present','absent'] $ensure = 'present'
) {
	include ::yum::plugin::versionlock

	$locked_check = "yum -C versionlock list | grep -q ${name}"

	if ($ensure == 'present') {
		exec { "add-yum-lock-${name}":
			command => "yum -C versionlock add ${name}",
			unless  => $locked_check,
			require => Class['yum::plugin::versionlock'],
		}
	} else {
		exec { "remove-yum-lock-${name}":
			command => "yum -C versionlock delete ${name}",
			onlyif  => $locked_check,
			require => Class['yum::plugin::versionlock'],
		}
	}
}
