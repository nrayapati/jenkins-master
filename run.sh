#!/bin/bash

git daemon --verbose --enable=receive-pack --base-path=/tmp/files --export-all &

# TODO without this JENKINS-24752 workaround, it takes too long to provision.
# (Do not add hudson.model.LoadStatistics.decay=0.1; in that case we overprovision slaves which never get used, and OnceRetentionStrategy.check disconnects them after an idle timeout.)
export JAVA_OPTS="-Xmx1024m -Djava.awt.headless=true -Dgroovy.use.classvalue=true -Dorg.apache.commons.jelly.tags.fmt.timeZone=US/Central -Duser.timezone=US/Central -Dhudson.model.LoadStatistics.clock=1000 -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -Dhudson.model.ParametersAction.keepUndefinedParameters=true"

/usr/local/bin/jenkins.sh
