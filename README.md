CI/CD on snowflake using Sqitch and Jenkins
============================================

Repository to demonstrate CI/CD on snowflake using [sqitch](https://sqitch.org/) and [Jenkins](https://jenkins.io/).

## Authors

- Prem Dubey
- Chris Herrera

### Table of Contents

- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Getting Help](#getting-help)
- [Documentation](#documentation)

## Requirements

* Jenkins Setup
  - We need to have a Jenkins Server, which can schedule executors via docker.
  
* Docker image for sqitch-snowflake
  - The executor used in this demonstration is a docker container which contains sqitch, snowflake odbc driver, and the snowsql client.
    Visit [docker-sqitch](https://github.com/sqitchers/docker-sqitch) on instructions on how to build the docker image. There might be some customizations required depending upon your Jenkins Setup.
    See [Caveats.md](/Caveats.md).
    
    
    [Docker Image](https://cloud.docker.com/u/hashmapinc/repository/docker/hashmapinc/sqitch) with tag `snowflake-dev` can be used for similar use case.
    [Docker Image](https://cloud.docker.com/u/hashmapinc/repository/docker/hashmapinc/sqitch) with tag `snowflake` is the as it is image after building from [docker-sqitch](https://github.com/sqitchers/docker-sqitch) for snowflake with default Dockerfile
    
* Git Client
  - We will also need the git client for communicating with github
  
* Snowflake account
  - If you do not have a snowflake account, You can sign up for one by visiting [Snowflake Free Trial](https://trial.snowflake.com/?_ga=2.198251247.151166467.1558600181-331987107.1558493529)
    This will get you 30 days of free trial worth $400
    

## Getting Started

- [Sqitch](https://sqitch.org/) is a database change management application. It
currently supports PostgreSQL 8.4+, SQLite 3.7.11+, MySQL 5.0+, Oracle 10g+,
Firebird 2.0+, Vertica 6.0+, Exasol 6.0+ and Snowflake.
- [Jenkins](https://jenkins.io/) is an open source automation tool written in Java with plugins built for Continuous Integration purpose. 
- [Snowflake](https://www.snowflake.com/) is the only data warehouse built for the cloud for all your data & all your users. Learn more about our purpose-built SQL cloud data warehouse.
- [Introduction to Sqitch on Snowflake](https://sqitch.org/docs/manual/sqitchtutorial-snowflake/) 
  - It is highly recommended that you go through the this tutorial by makers of sqitch. This explains how to use sqitch to manage database change on Snowflake
  

## Getting Help

You can submit issues or questions via GitHub Issues [here](https://github.com/hashmapinc/snow-cd/issues).


You can also drop an email to `prem.dubey@hashmapinc.com`


## Documentation

See [Documentation](https://snowflake-sqitch-ci-cd.readthedocs.io/en/latest/) for the latest updates and a detailed How-To-Guide.
