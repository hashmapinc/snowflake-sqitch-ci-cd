# Workarounds and Limitations

[Sqitch](https://github.com/sqitchers/sqitch) is under active development. Support for Snowflake was added in October 2018 and many new features are on the way.
However, There are also some [issues](https://github.com/sqitchers/sqitch/issues), with plans to resolve them as well.

Here are some notes from the sqitch team:
-----

*   The [`docker-sqitch.sh`] shell script is the easiest way to run Sqitch from
    a Docker image. The script mounts the current directory and the home
    directory, so that it acts on the Sqitch project in the current directory
    and reads configuration from the home directory almost as if it was running
    natively on the local host. It also copies over most of the environment
    variables that Sqitch cares about, for transparent configuration.
*   By default, the container runs as the `sqitch` user, but when executed by
    `root`, [`docker-sqitch.sh`] runs the container as `root`. Depending on your
    permissions, you might need to use `root` in order for sqitch to read and
    write files. On Windows and macOS, the `sqitch` user should be fine. On
    Linux, if you find that the container cannot access configuration files in
    your home directory or write change scripts to the local directory, run
    `sudo docker-sqitch.sh` to run as the root user. Just be sure to `chown`
    files that Sqitch created for the consistency of your project.
*   If your engine falls back on the system username when connecting to the
    database (as the PostgreSQL engine does), you will likely want to set the
    username in sqitch target URIs, or set the proper [environment variables] to
    fall back on. Database authentication failures for the usernames `sqitch` or
    `root` are the hint you'll want to look for.
*   Custom images for [Oracle], [Snowflake], [Exasol], or [Vertica] can be built
    by downloading the appropriate binary files and using the `Dockerfiles` in
    the appropriately-named subdirectories of this repository.
*   In an effort to keep things as simple as possible, the only editor included
    and configured for use in the image is [nano]. This is a very simple, tiny
    text editor suitable for editing change descriptions and the like. Its
    interface always provides menus to make it easy to figure out how to use it.
    If you need another editor, this image isn't for you, but you can create
    one based on this image and add whatever editors you like.

Workarounds for running on Jenkins:
----

* The sqitch container is built to run with sqitch user.
  In our case, we provision ec2 slaves dynamically and then the docker executors run on them.
  Jenkins runs the container as root user, because sqitch users don't have access to write logs on the slave directory and if we run it as sqitch user, then we start to see errors.
  
* So to run the sqitch-snowflake container run on Jenkins, we make some changes to the [Snowflake-Dockerfile](https://github.com/sqitchers/docker-sqitch/blob/master/Dockerfile)

      FROM debian:stable-slim AS snow-build

      WORKDIR /work
      COPY *.tgz *.bash conf ./

      # Tell SnowSQL where to store its versions and config. Need to keep it inside
      # the image so it doesn't try to load the version from $HOME, which will
      # typically be mounted to point to the originating host.
      ENV WORKSPACE /var/snowsql

      # Set locale for Python triggers.
      ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

      # Install prereqs.
      ARG sf_account
      RUN apt-get -qq update \
          && apt-get -qq --no-install-recommends install odbcinst \
          # Configure ODBC. https://docs.snowflake.net/manuals/user-guide/odbc-linux.html
          && gunzip *.tgz && tar xf *.tar  \
          && mkdir odbc \
          && mv snowflake_odbc/lib snowflake_odbc/ErrorMessages odbc/ \
          && mv simba.snowflake.ini odbc/lib/ \
          && perl -i -pe "s/SF_ACCOUNT/$sf_account/g" odbc.ini \
          && cat odbc.ini >> /etc/odbc.ini \
          && cat odbcinst.ini >> /etc/odbcinst.ini \
          # Unpack and upgrade snowsql, then overwrite its config file.
          && sed -e '1,/^exit$/d' snowsql-*-linux_x86_64.bash | tar zxf - \
          && ./snowsql -Uv \
          && echo "[connections]\naccountname = $sf_account\n\n[options]\n" > /var/snowsql/.snowsql/config

      FROM sqitch/sqitch:latest

      # Install runtime dependencies, remove unnecesary files, and create log dir.
      USER root
      RUN apt-get -qq update \
          && apt-get -qq --no-install-recommends install unixodbc \
          && apt-get clean \
          && rm -rf /var/cache/apt/* /var/lib/apt/lists/* \
          && rm -rf /man /usr/share/man /usr/share/doc \
          # XXX Workaround for Snowflake missing table error code fixed in v1.0.0.
          && perl -i -pe 's/02000/42S02/' /lib/perl5/App/Sqitch/Engine/snowflake.pm \
          && mkdir -p /usr/lib/snowflake/odbc/log \
          && printf '#!/bin/sh\n/var/snowsql --config /var/.snowsql/config "$@"\n' > /bin/snowsql \
          && chmod +x /bin/snowsql

      # Install SnowSQL plus the ODDB driver and config.
      COPY --from=snow-build /work/snowsql /var/
      COPY --from=snow-build --chown=sqitch:sqitch /var/snowsql /var/
      COPY --from=snow-build /work/odbc /usr/lib/snowflake/odbc/
      COPY --from=snow-build /etc/odbc* /etc/

      # The .snowsql directory is copied to /var.
      USER sqitch
      ENV WORKSPACE /var
     
* Now, we run the docker container on slave as user `root`

        agent {
          docker {
            image 'hashmapinc/sqitch:snowflake-dev'
            args "-u root -v /var/run/docker.sock:/var/run/docker.sock --entrypoint=''"
          }
        }
        
* Then, we also need to run `snowsql --help` once so that it updates itself and is available to `root` user in the container

* Since, the slaves use the `ec2-user` by default, we'll also need to add this in the end of Jenkinsfile so that the slaves can clean up the workspace

        post {
            always {
              sh 'chmod -R 777 .'
            }
          }
                 
