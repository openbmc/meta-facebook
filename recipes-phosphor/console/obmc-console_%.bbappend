FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_yosemitev2 = " file://client.2200.conf \
                              file://client.2201.conf \
                              file://client.2202.conf \
                              file://client.2203.conf \
                              file://server.ttyS0.conf \
                              file://server.ttyS1.conf \
                              file://server.ttyS2.conf \
                              file://server.ttyS3.conf \
"

SRC_URI_remove_yosemitev2 = "[file://${BPN}.conf]file://${BPN}.conf"

REGISTERED_SERVICES_${PN}_append_yosemitev2 = " obmc_console_guests:tcp:2201:"

SYSTEMD_SERVICE_${PN}_append_tiogapass = " obmc-console@ttyS2.service "

SYSTEMD_SERVICE_${PN}_append_yosemitev2 = " obmc-console@ttyS0.service \
                                            obmc-console@ttyS1.service \
                                            obmc-console@ttyS2.service \
                                            obmc-console@ttyS3.service \
                                            obmc-console-ssh@2200.service \
                                            obmc-console-ssh@2201.service \
                                            obmc-console-ssh@2202.service \
                                            obmc-console-ssh@2203.service \
"

SYSTEMD_SERVICE_${PN}_remove_yosemitev2 = "obmc-console-ssh.socket"

FILES_${PN}_remove_yosemitev2 = "/lib/systemd/system/obmc-console-ssh@.service.d/use-socket.conf"

EXTRA_OECONF_append_yosemitev2 = " --enable-concurrent-servers"

do_install_append_tiogapass() {

        # Install configuration for the servers and clients. Keep commandline
        # compatibility with previous configurations by defaulting to not
        # specifying a socket-id for VUART0/2200
        install -m 0755 -d ${D}${sysconfdir}/${BPN}

        # Link the custom configuration to the required location
        ln -sr ${D}${sysconfdir}/${BPN}.conf ${D}${sysconfdir}/${BPN}/server.ttyS2.conf
}

do_install_append_yosemitev2() {

        # Install configuration for the servers and clients. Keep commandline
        # compatibility with previous configurations by defaulting to not
        # specifying a socket-id for VUART0/2200
        install -m 0755 -d ${D}${sysconfdir}/${BPN}

        # We need to populate socket-id for remaining consoles
        install -m 0644 ${WORKDIR}/client.2200.conf ${D}${sysconfdir}/${BPN}/
        install -m 0644 ${WORKDIR}/client.2201.conf ${D}${sysconfdir}/${BPN}/
        install -m 0644 ${WORKDIR}/client.2202.conf ${D}${sysconfdir}/${BPN}/
        install -m 0644 ${WORKDIR}/client.2203.conf ${D}${sysconfdir}/${BPN}/

        # Install configuration for remaining servers.
        install -m 0644 ${WORKDIR}/server.ttyS0.conf ${D}${sysconfdir}/${BPN}/
        install -m 0644 ${WORKDIR}/server.ttyS1.conf ${D}${sysconfdir}/${BPN}/
        install -m 0644 ${WORKDIR}/server.ttyS2.conf ${D}${sysconfdir}/${BPN}/
        install -m 0644 ${WORKDIR}/server.ttyS3.conf ${D}${sysconfdir}/${BPN}/
}
