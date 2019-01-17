#!/bin/sh

JBOSS_HOME=/opt/jboss/wildfly
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}
JBOSS_CONFIG=${2:-"$JBOSS_MODE.xml"}

function wait_for_wildfly() {
  until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
    sleep 10
  done
}

echo "==> Setting Up Config User..."
$JBOSS_HOME/bin/add-user.sh --silent -e -u config -p config

echo "==> Starting WildFly..."
$JBOSS_HOME/bin/$JBOSS_MODE.sh -c $JBOSS_CONFIG > /dev/null &

echo "==> Waiting..."
wait_for_wildfly

echo "==> Executing..."
$JBOSS_CLI -c --user=config --password=config --file=$JBOSS_HOME/bin/config-commands.cli --properties=$JBOSS_HOME/bin/cli.properties

echo "==> Shutting down WildFly..."
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi

# Fix for Error: Could not rename /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current
rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history
