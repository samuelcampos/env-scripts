# Export environment variables
export JAVA_HOME=$(/usr/libexec/java_home)

# Maven aliases & tweeks
# - https://zeroturnaround.com/rebellabs/your-maven-build-is-slow-speed-it-up/
# - http://blog.dblazejewski.com/2015/08/how-to-make-your-maven-build-fast-again/
export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"

# -DskipTests=true          : Don't run the unit tests
# -Dmaven.test.skip=true    : Don't compile nor run the unit tests

alias mdu="mvn versions:display-dependency-updates"                                 # maven dependency updates
alias mcict="mvn -T 1C clean install -DskipTests=true"                              # maven clean install skip test execution but compile them
alias mist="mvn -T 1C install -DskipTests=true -Dmaven.test.skip=true"              # maven install skip test execution and compilation
alias mfi="mist -nsu"                                                               # maven install skip tests
alias mcfi="mvn -T 1C clean install -DskipTests=true -Dmaven.test.skip=true -nsu"   # maven clean install skip tests