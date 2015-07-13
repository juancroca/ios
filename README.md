# README
If you want to quickly test this project, use the docker-compose approach... it's easiest :-)

## Running locally (non-Docker)
To execute the server in normal mode, follow these steps:

1. Install SBT: (http://www.scala-sbt.org/release/tutorial/Setup.html) and Postgres (https://wiki.postgresql.org/wiki/Detailed_installation_guides)
2. Clone the distribution server code:
```
$ mkdir ~/IoS
$ cd ~/IoS
$ git clone https://github.com/joroKr21/IoS-Algorithm.git
$ cd IoS-Algorithm
```   
3. Run the Jetty server (takes a while the first time; it downloads dependencies)
```
$ sbt
> container:start
```
4. Get this repository
```
$ cd ~/IoS
$ git clone https://github.com/juancroca/ios.git
```
5. Edit your hosts file (on Linux/OSX it's located in ```/etc/hosts```), add this line:
```
127.0.0.1   ruby scala db
```
6. Edit the config/databases.yml file (look at config/databases.example.yml for an example) to match your Postgres installation.
7. Run the following commands to setup all dependencies
```
$ cd ~/IoS/ios
$ bundle install
$ rake db:drop; rake db:create; rake db:setup;
```
8. Run the server
```
$ rails s
```

That's it; you can now visit your running server on http://localhost:3000 !

## Running in Docker
To run in Docker compose, do:
```
$ docker-compose build
$ docker compose up

# Get the CONTAINER ID of the ruby container
$ docker ps

$ docker exec <<CONTAINER ID>> /bin/sh -c 'export RAILS_ENV=production; cd /home/app/webapp; rake db:setup;'
```
To run ```bash```, do:
```
$ docker exec -t -i <<CONTAINER ID>> bash
```
That should get you going :)
