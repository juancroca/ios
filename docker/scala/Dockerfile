FROM lukasz/docker-scala

WORKDIR /myapp

# Clone the IoS scale repository into the current folder
RUN ["git", "clone", "https://github.com/joroKr21/IoS-Algorithm.git", "."]

# Run Spray
CMD ["sbt", "run", "re-start"]
