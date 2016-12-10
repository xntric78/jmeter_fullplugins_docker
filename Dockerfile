FROM ubuntu:15.04
FROM openjdk:8

ENV JMETER_VERSION 3.1
ENV JMETER_HOME /usr/local/apache-jmeter-${JMETER_VERSION}
ENV JMETER_PLUGINS ${JMETER_HOME}/lib/ext
ENV PATH ${JMETER_HOME}/bin:${PATH}
ENV JMETER_LOG jmeter.log
ENV IP 127.0.0.1
ENV RMI_PORT 1099

RUN apt-get -y update && \
	apt-get -y install wget

RUN wget http://apache.cs.utah.edu/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz && \
	tar -xzf apache-jmeter-${JMETER_VERSION}.tgz -C /usr/local/

RUN wget https://repo1.maven.org/maven2/kg/apc/cmdrunner/2.0/cmdrunner-2.0.jar && \
  mv cmdrunner-2.0.jar ${JMETER_HOME}/lib/cmdrunner-2.0.jar

RUN wget https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/0.11/jmeter-plugins-manager-0.11.jar && \
  mv jmeter-plugins-manager-0.11.jar ${JMETER_PLUGINS}/jmeter-plugins-manager-0.11.jar

RUN java -cp ${JMETER_PLUGINS}/jmeter-plugins-manager-0.11.jar org.jmeterplugins.repository.PluginManagerCMDInstaller

RUN ${JMETER_HOME}/bin/PluginsManagerCMD.sh install jpgc-graphs-basic, jpgc-graphs-additional, jpgc-autostop, \
    jpgc-sense, blazemeter-debugger, jpgc-cmd, jpgc-graphs-composite, jpgc-csl, jpgc-functions, jpgc-casutg, \
		jpgc-dbmon, jpgc-graphs-dist, jpgc-dummy, jmeter-ftp, jpgc-filterresults, jpgc-ffw, jpgc-ggl, jmeter-http, \
		jpgc-httpraw, jpgc-sts, jpgc-hadoop, jpgc-fifo, jmeter-jdbc, jpgc-jms, jmeter-jms, jpgc-jmxmon, jmeter-core, \
		jpgc-json, jmeter-junit, jmeter-java, jpgc-graphs-vs, jmeter-ldap, jpgc-lockfile, jmeter-mail, \
		jpgc-mergeresults, jmeter-mongodb, jpgc-oauth, jmeter-native, jpgc-pde, jpgc-prmctl, jpgc-perfmon, \
		jpgc-plugins-manager, jpgc-webdriver, jpgc-synthesis, jmeter-tcp, jpgc-plancheck, jpgc-tst, jpgc-udp, \
		jpgc-csvars, jmeter-components, jpgc-wsc, jpgc-xml, jpgc-standard

RUN rm -rf apache-jmeter-${JMETER_VERSION}.tgz && \
	apt-get -y --purge autoremove && \
	apt-get -y clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH $PATH:$JMETER_BIN

WORKDIR $JMETER_HOME

EXPOSE $RMI_PORT

RUN touch $JMETER_HOME/$JMETER_LOG
