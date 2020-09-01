FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

FILES_${PN} += " /lib/systemd/system/xyz.openbmc_project.State.Boot.PostCode.service "
FILES_${PN} += " /lib/systemd/system/xyz.openbmc_project.State.Boot.PostCode@.service "
