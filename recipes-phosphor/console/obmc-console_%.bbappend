FILESEXTRAPATHS_prepend_tiogapass := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend_yosemitev2 := "${THISDIR}/${PN}:"

OBMC_CONSOLE_HOST_TTY = "ttyS2"

SRC_URI_append_yosemitev2 = " file://client.2200.conf \
			              file://client.2201.conf \
			              file://client.2202.conf \
			              file://client.2203.conf \
                                      file://client.2204.conf \
                                      file://server.ttyVUART0.conf \
                                      file://server.ttyVUART1.conf \
                                      file://server.ttyVUART2.conf \
                                      file://server.ttyVUART3.conf \
                                      file://server.ttyVUART4.conf \
                                      file://obmc-consolettyS0.service \   
			              file://obmc-consolettyS1.service \    
			              file://obmc-consolettyS2.service \  
			              file://obmc-consolettyS3.service \                                            
"
		

SRC_URI_remove = "[file://${BPN}.conf]file://${BPN}.conf"

REGISTERED_SERVICES_${PN}_append_yosemitev2 = " obmc_console_guests:tcp:2201:"

SYSTEMD_SERVICE_${PN}_append_yosemitev2 = " obmc-consolettyS0.service \  
					    obmc-consolettyS1.service \ 
					    obmc-consolettyS2.service \ 
					    obmc-consolettyS3.service \ 
					    obmc-console-ssh@2200.service \
			               obmc-console-ssh@2201.service \
					    obmc-console-ssh@2202.service \
					    obmc-console-ssh@2203.service \	                     
"

SYSTEMD_SERVICE_${PN}_remove_yosemitev2 = "obmc-console-ssh.socket"

FILES_${PN}_remove_yosemitev2 = "/lib/systemd/system/obmc-console-ssh@.service.d/use-socket.conf"

EXTRA_OECONF_append_yosemitev2 = " --enable-concurrent-servers"


do_install_append_yosemitev2(){

        # Install service files 
        install -m 0644 ${WORKDIR}/obmc-consolettyS0.service ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/obmc-consolettyS1.service ${D}${systemd_system_unitdir}
	install -m 0644 ${WORKDIR}/obmc-consolettyS2.service ${D}${systemd_system_unitdir}
	install -m 0644 ${WORKDIR}/obmc-consolettyS3.service ${D}${systemd_system_unitdir}
      
        # Install configuration for the servers and clients. Keep commandline
        # compatibility with previous configurations by defaulting to not
        # specifying a socket-id for VUART0/2200
        install -m 0755 -d ${D}${sysconfdir}/${BPN}

        # Remove the default client configuration as we don't to define a
        # socket-id for the 2200 console
        rm -f ${D}${sysconfdir}/${BPN}/client.2200.conf

        # However, now link to /dev/null as a way of not specifying a
        # socket-id while having a configuration file present. We need to
        # provide a configuration path to meet the requirements of the packaged
        # unit file.
        ln -sr ${D}/dev/null ${D}${sysconfdir}/${BPN}/client.2200.conf
        

        # We need to populate socket-id for remaining consoles
        install -m 0644 ${WORKDIR}/client.2200.conf ${D}${sysconfdir}/${BPN}/
        install -m 0644 ${WORKDIR}/client.2201.conf ${D}${sysconfdir}/${BPN}/
	install -m 0644 ${WORKDIR}/client.2202.conf ${D}${sysconfdir}/${BPN}/
	install -m 0644 ${WORKDIR}/client.2203.conf ${D}${sysconfdir}/${BPN}/
        install -m 0644 ${WORKDIR}/client.2204.conf ${D}${sysconfdir}/${BPN}/
       

        # Install configuration for remaining servers.
        install -m 0644 ${WORKDIR}/server.ttyVUART0.conf ${D}${sysconfdir}/${BPN}/
        install -m 0644 ${WORKDIR}/server.ttyVUART1.conf ${D}${sysconfdir}/${BPN}/
        install -m 0644 ${WORKDIR}/server.ttyVUART2.conf ${D}${sysconfdir}/${BPN}/
	install -m 0644 ${WORKDIR}/server.ttyVUART3.conf ${D}${sysconfdir}/${BPN}/
        install -m 0644 ${WORKDIR}/server.ttyVUART4.conf ${D}${sysconfdir}/${BPN}/
 
}
