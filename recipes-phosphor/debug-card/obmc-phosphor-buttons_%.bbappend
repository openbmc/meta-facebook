FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/${MACHINE}:"

SRC_URI_append_yosemitev2 = " file://gpio_defs.json"


EXTRA_OECMAKE_append_yosemitev2 ="-DMULTI_HOST_FRONTPANEL=ON"
EXTRA_OECMAKE_append_yosemitev2 +="-DCHASSIS_SYSTEM_RESET_ENABLED=ON"
EXTRA_OECMAKE_append_yosemitev2 +="-DTOTAL_NUMBER_OF_HOST=4"


SYSTEMD_PACKAGES_yosemitev2 = "${PN}"
SYSTEMD_SERVICE_${PN}_yosemitev2 = "phosphor-button-handler.service xyz.openbmc_project.Chassis.Buttons.service"

do_install_append_yosemitev2() {

     install -m 0755 -d ${D}/etc/default/obmc/gpio
     install -m 0644 -D ${WORKDIR}/gpio_defs.json \
                   ${D}/etc/default/obmc/gpio
}
