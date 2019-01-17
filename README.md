# docker-wildfly-oracle
Dockerized Wildfly with Oracle driver developing environment, setting up a data source (using credential store, keystore) and basic auth. Autodeployment and Debugging.

Thanks to [SleepingTalent github](https://github.com/SleepingTalent/wildfly-with-oracle-driver) for the oracle driver solution.

Table of contents:

- [docker-wildfly-oracle](#docker-wildfly-oracle)
  - [Pre-reqs](#pre-reqs)
  - [Configure environment](#configure-environment)
  - [Database](#database)
  - [Application server](#application-server)
    - [BASIC AUTH](#basic-auth)
    - [Deployment and logs](#deployment-and-logs)
    - [Logging](#logging)
    - [Self-signed certificates](#self-signed-certificates)
    - [Remote debugging and admin console](#remote-debugging-and-admin-console)
  - [Recommended tools](#recommended-tools)
  - [Setup remote java application debugging](#setup-remote-java-application-debugging)

## Pre-reqs
 - Install Docker for Windows
> **Note!** As Docker for Windows 7 is running under Boot2Docker (a lightweight linux VM), container's URLs will be accessible through `192.168.99.100` while for Windows 10 will just be `localhost` as it runs "natively". You can run `docker-machine ip` to figure the dockerhost out anyway.


## Configure environment
Open bash in this project directory, then execute the following commands to create and run both containers `Oracle-XE` and `Wildfly` in Docker:

Create oracle-xe docker image:

    cd oracle
    docker build -t oracle-xe .
    cd ..

Create Wildfly docker image:
    
    cd wildfly
    docker build -t wildfly .
    cd ..

Once the images are created, only this step will be necessary to bootstrap the whole environment in the future:

    docker-compose up

## Database
Oracle-XE should be already running:
- host `localhost/192.168.99.100:1521`
- SID `XE`
- user `dockercrud`
- password `password`

Some example scripts (oracle/*.sql) to be executed at the creation time of the database are provided, have a look at them, they are self-explaining.

> **Note!** user and password + DB initialization configured in `oracle/00_create_database_schema.sql`.
> **Note 2!** a datasource has already been created in the wildfly image to access this database service in the file `oracle-driver-commands.cli`.

## Application server
`Wildfly` should also be running in 192.168.99.100:8080 (exposed in docker-compose). The most tricky part is probably in the `config-commands.cli` file, where both the ORACLE DATASOURCE (password added to a credential store, looks pretty okay) and the BASIC AUTH.

### BASIC AUTH
Basic auth, as well as the datasource, is configuered as an ELYTRON (new security framework for wildfly) subsystem; `config-commands.cli` file contains some comments to help you adapt it to your special needs. I point out there three different ways of getting basic auth users created (filesystem-realm, properties-realm or using wildfly's cli tool add-user.sh).

Everything is thought to keep all the "configurable values" in the `cli.properties` file, so you can maybe use environment variables when deploying or something like that.

### Deployment and logs
Volume `~/webapp:/opt/jboss/wildfly/standalone/deployments/` has been created so built wars can be placed in `c:/users/<user>/projects/docker-wildfly-oracle` locally and will be deployed in Wildfly container. The idea is you can point your IDE's target dir here so everything gets deployed as you build, zero effort.

A second volume `~/webapp:/opt/jboss/wildfly/standalone/log/` has been created so the logs from wildfly will be placed in `c:/users/<user>/projects/docker-wildfly-oracle/logs` locally and can be accessed. Some IDEs can configure directly this log into IDE's console.

### Logging
Some workaround for **logging** into the application-server is configuered as a `login module` in wildfly, have a look at line 29 in the `/wildfly/Dockerfile`. File `module.xml` (uncomment if necessary) defines it, which gets copied over, and added to the `standalone.xml` file in case you hae a `logging.jar` for example.

### Self-signed certificates
In case you need self-signed certificates, add to the root of the project a `keystore.jks` with your certificates, then uncomment lines 25 and 26 in `wildfly/Dockerfile` and 34,35 and 36 in `standalone.xml`.

### Remote debugging and admin console
**Remote debugging** is using port 8787 (also exposed in docker-compose)

**Admin console** will be served in 192.168.99.100:9990 (user `admin`, password `admin`)

## Recommended tools
IDE -> Eclipse Oxygen/IntelliJ
DB management -> Oracle SQL developer, DBeaver
Git management -> Git Bash

## Setup remote java application debugging
In your IDE, set the application as a remote java application.

In **Eclipse**, go to `Debug Configurations -> Remote Java Application:`
- Pick the project
- host: localhost/192.168.99.100 (windows 10/windows 7 docker)
- port: 8787

In **IntelliJ**, go to Run -> Debug -> Edit Configurations:
- click on + icon and select Remote
- specify a name
- specify port 8787
- in the Use module classpath drop down, select you application
- click Apply and OK
- select the Debug configuration and click on Debug icon.

At this point you should see in the console: Connected to the target VM, address: 'localhost:8787', transport: 'socket'
