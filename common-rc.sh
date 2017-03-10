#!/bin/bash

# Export environment variables
export JAVA_HOME=$(/usr/libexec/java_home)
#export JAVA_HOME=$(/usr/libexec/java_home -v 1.8.0_111)

# Maven aliases
alias mdu="mvn versions:display-dependency-updates"
alias mfi="mvn install -DskipTests=true -nsu -o"