#!/bin/bash

# Export environment variables
export JAVA_HOME=$(/usr/libexec/java_home)

# Maven aliases
alias mvnUpdates="mvn versions:display-dependency-updates"
alias mvnFastInstall="mvn install -DskipTests=true -nsu -o"