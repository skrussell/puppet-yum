#
# Parent class for all Hewlett Packard Enterprise repos
#
class yum::repo::hpe (
	Stdlib::HTTPUrl $baseurl = 'http://downloads.linux.hpe.com/repo'
) {
	$repo_basename = 'hpe'

	$gpg_key_basename = 'PublicKey2048'
	$gpg_keys = [
		"puppet:///modules/yum/rpm-gpg/hp${gpg_key_basename}.pub",
		"puppet:///modules/yum/rpm-gpg/hp${gpg_key_basename}_key1.pub",
		"puppet:///modules/yum/rpm-gpg/hpe${gpg_key_basename}_key1.pub"
	]
}
