FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

#Enable multi-host support for yosemitev2 in the phosphor-host-postd
NUMBER_OF_HOST = "4"
EXTRA_OEMESON_yosemitev2 += "-Dnumber-of-host=${NUMBER_OF_HOST}"
EXTRA_OEMESON_yosemitev2 += "-Dsystemd-target=multi-user.target"
