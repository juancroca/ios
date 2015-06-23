FROM lukasz/docker-scala

WORKDIR /myapp
RUN ["git", "clone", "https://github.com/joroKr21/IoS-Algorithm.git", "."]

CMD ["sbt", "run", "jetty"]
