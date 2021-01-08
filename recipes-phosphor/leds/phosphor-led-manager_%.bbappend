FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_yosemitev2 = " file://led-group-config.json"
SRC_URI_append_yosemitev2 = " file://power_status_led.service"
SRC_URI_append_yosemitev2 = " file://power_status_led.sh"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN}_append_yosemitev2 = "power_status_led.service"

EXTRA_OECONF += " --enable-use-json"
RDEPENDS_${PN} += "bash"

do_install_append_yosemitev2() {

    install -m 0755 -d ${D}/usr/share/phosphor-led-manager

    install -m 0644 -D ${WORKDIR}/led-group-config.json \
                   ${D}/usr/share/phosphor-led-manager

    install -m 0644 -D ${WORKDIR}/power_status_led.service \
                   ${D}/lib/systemd/system

    install -m 0755 -D ${WORKDIR}/power_status_led.sh \
                   ${D}/usr/bin
}
