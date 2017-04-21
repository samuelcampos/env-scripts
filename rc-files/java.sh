# Export environment variables
export JAVA_HOME=$(/usr/libexec/java_home)
#export JAVA_HOME=$(/usr/libexec/java_home -v 1.8.0_111)

# Maven aliases & tweeks
# - https://zeroturnaround.com/rebellabs/your-maven-build-is-slow-speed-it-up/
# - http://blog.dblazejewski.com/2015/08/how-to-make-your-maven-build-fast-again/
export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
alias mdu="mvn versions:display-dependency-updates" # maven dependency updates
alias mist="mvn -T 1C install -DskipTests=true"     # maven install skip tests
alias mfi="mist -nsu -o"                            # maven install skip tests offline
alias mcfi="mvn -T 1C clean install -DskipTests=true -nsu -o" # maven clean install skip tests offline