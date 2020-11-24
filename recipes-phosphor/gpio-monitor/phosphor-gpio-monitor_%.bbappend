FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/${MACHINE}:"

SRC_URI_append = "file://phosphor-multi-gpio-monitor.json"
SRC_URI_append = "file://hand_switch_position.service"
SRC_URI_append = "file://phosphor-multi-gpio-monitor.service"
SRC_URI_append = "file://hand_switch_position.sh"
SRC_URI_append = "file://hand_switch_position_sol.sh"
SRC_URI_append = "file://hand_switch_position_sol.service"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "hand_switch_position.service phosphor-multi-gpio-monitor.service hand_switch_position_sol.service"



do_install_append() {

     install -m 0755 -d ${D}/usr/share/phosphor-gpio-monitor

     install -m 0644 -D ${WORKDIR}/phosphor-multi-gpio-monitor.json \
                   ${D}/usr/share/phosphor-gpio-monitor

     install -m 0644 -D ${WORKDIR}/hand_switch_position.service \
                   ${D}/lib/systemd/system

     install -m 0755 -D ${WORKDIR}/hand_switch_position.sh \
                   ${D}/usr/bin

     install -m 0755 -D ${WORKDIR}/hand_switch_position_sol.sh \
                   ${D}/usr/bin

     install -m 0644 -D ${WORKDIR}/hand_switch_position_sol.service \
                   ${D}/lib/systemd/system

     install -m 0644 -D ${WORKDIR}/phosphor-multi-gpio-monitor.service \
                   ${D}/lib/systemd/system
}

FILES_${PN}  += "/lib/systemd/system/phosphor-gpio-monitor@.service"
FILES_${PN}  += "/lib/systemd/system/phosphor-gpio-presence@.service"
