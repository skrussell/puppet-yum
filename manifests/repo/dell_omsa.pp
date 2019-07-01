# = Class: yum::repo::dell_omsa
#
# This class installs the DELL OpenManage repo
#
class yum::repo::dell_omsa (
	Enum['present','absent'] $ensure = 'present'
) {
  yum::managed_yumrepo { 'dell-omsa-indep':
		ensure         => $ensure,
    descr          => 'Dell OMSA repository - Hardware independent',
    enabled        => 1,
    gpgcheck       => 1,
    mirrorlist     => 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver',
    failovermethod => 'priority',
    gpgkey         => 'http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-dell http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-libsmbios',
  }

  yum::managed_yumrepo { 'dell-omsa-specific':
		ensure         => $ensure,
    descr          => 'Dell OMSA repository - Hardware specific',
    enabled        => 1,
    gpgcheck       => 1,
    mirrorlist     => 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver',
    failovermethod => 'priority',
    gpgkey         => 'http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-dell http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-libsmbios',
  }

}
