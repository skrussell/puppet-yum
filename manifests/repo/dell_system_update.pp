# = Class: yum::repo::dell_system_update
#
# This class installs the DELL System Update repo
#
class yum::repo::dell_system_update (
	Enum['present','absent'] $ensure = 'present'
) {
	yum::managed_yumrepo {
		default:
			autokeyimport  => 'yes',
			ensure         => $ensure,
			enabled        => 1,
			failovermethod => 'priority',
			file_name      => 'dell-system-update',
			gpgcheck       => 1,
			gpgkey         => [
				'https://linux.dell.com/repo/hardware/dsu/public.key',
				'https://linux.dell.com/repo/hardware/dsu/public_gpg3.key'
			];
		'dell-system-update_independent':
			mirrorlist => 'https://linux.dell.com/repo/hardware/dsu/os_independent/'
		'dell-system-update_dependent':
			mirrorlist => 'https://linux.dell.com/repo/hardware/dsu/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1'
  }

}
