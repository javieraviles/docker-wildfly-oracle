FROM jboss/wildfly:11.0.0.Final


ADD ojdbc7.jar /opt/jboss/wildfly/
ADD config-commands.cli /opt/jboss/wildfly/bin/
ADD cli.properties /opt/jboss/wildfly/bin/

#Uncomment next line in case want to create user/roles out of property files in a properties realm
# ADD users.properties /opt/jboss/wildfly/standalone/configuration/
# ADD roles.properties /opt/jboss/wildfly/standalone/configuration/
ADD config.sh /opt/jboss/wildfly/

# Change the ownership of added files/dirs to `jboss`
USER root

# Fix for Error: Could not rename /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history

RUN chown -R jboss:jboss /opt/jboss/wildfly
RUN chmod +x /opt/jboss/wildfly/ojdbc7.jar
RUN chmod +x /opt/jboss/wildfly/bin/config-commands.cli
RUN chmod +x /opt/jboss/wildfly/bin/cli.properties
RUN chmod +x /opt/jboss/wildfly/config.sh

# If you need for example self-signed certificates, configure certificates
# RUN mkdir -p $JBOSS_HOME/config
# ADD keystore.jks $JBOSS_HOME/config

# configure logging module 
RUN mkdir -p  $JBOSS_HOME/modules/com/docker/wildfly/commons/main
ADD module.xml $JBOSS_HOME/modules/com/docker/wildfly/commons/main
# if added a logging.jar uncomment this and module.xml
# ADD logging.jar $JBOSS_HOME/modules/com/docker/wildfly/commons/main

RUN mkdir -p $JBOSS_HOME/standalone/configuration/
ADD standalone.xml $JBOSS_HOME/standalone/configuration/
RUN echo "JAVA_OPTS=\"\$JAVA_OPTS -Dlogging.root=$JBOSS_HOME/standalone/log\"" >> $JBOSS_HOME/bin/standalone.conf

# Run CLI wildfly configuration 
RUN /opt/jboss/wildfly/config.sh

# Fix for Error: Could not rename /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history

RUN /opt/jboss/wildfly/bin/add-user.sh admin admin --silent

# Uncomment next line if war file is in the same dir as the Dockerfile and want to autodeploy
# ADD your-war-file-name.war /opt/jboss/wildfly/standalone/deployments/

EXPOSE 8080 9990 9999 8009 45700 7600 57600

EXPOSE 23364/udp 55200/udp 54200/udp 45688/udp

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
