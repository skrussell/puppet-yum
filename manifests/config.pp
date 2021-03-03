#
# Manage configuration entries in yum.conf
#
define yum::config (
	Variant[Boolean,Integer,String] $value,
	Enum['absent','present'] $ensure = 'present',
	String $key = $name,
	String $section = 'main'
) {
	include yum
	$conf_file = $yum::config_file

	if ($key == 'exclude') {
		$multi_value = true
	} else {
		$multi_value = false
	}

	if ($value =~ Boolean) {
		$use_value = bool2num($value)
	} else {
		$use_value = $value
	}

	if ($ensure == 'present') {
		if ($multi_value) {
			$ini_title = "ensure_${key}_contains_${use_value}"
		} else {
			$ini_title = "set_${key}"
		}
	} else {
		if ($multi_value) {
			$ini_title = "ensure_${use_value}_absent_from_${key}"
		} else {
			$ini_title = "unset_${key}"
		}
	}
	if ($multi_value) {
		ini_subsetting { $ini_title:
			ensure               => $ensure,
			path                 => $conf_file,
			section              => $section,
			setting              => $key,
			subsetting           => $use_value,
			subsetting_separator => ' '
		}
	} else {
		ini_setting { $ini_title:
			ensure  => $ensure,
			path    => $conf_file,
			section => $section,
			setting => $key,
			value   => $use_value
		}
	}
}
