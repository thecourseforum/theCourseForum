#!/bin/bash

mysql -u root -p <<QUERY 
drop database if exists thecourseforum_development;drop database if exists thecourseforum_production;
create database thecourseforum_development;
create database thecourseforum_production;
use thecourseforum_development;
source ./sql/thecourseforum_development.sql
use thecourseforum_production;
source ./sql/thecourseforum_production.sql;
QUERY