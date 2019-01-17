connect system/oracle;

create user DOCKERWILDFLY identified by "password";

grant dba, resource, connect to DOCKERWILDFLY;

create user DOCKERCRUD identified by "password";

connect DOCKERWILDFLY/password;

CREATE SCHEMA AUTHORIZATION DOCKERWILDFLY;