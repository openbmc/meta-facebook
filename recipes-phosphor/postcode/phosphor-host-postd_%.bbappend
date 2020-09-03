FILESEXTRAPATHS_prepend_yosemitev2 := "${THISDIR}/${PN}/${MACHINE}:"

SRC_URI_append_yosemitev2 = " file://lpcsnoop.service"
SYSTEMD_SERVICE_${PN}_yosemitev2= "lpcsnoop.service"

do_install_append_yosemitev2() {
    install -m 0644 ${WORKDIR}/lpcsnoop.service ${D}${systemd_system_unitdir}
}
