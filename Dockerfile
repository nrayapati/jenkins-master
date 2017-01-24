FROM jenkinsci/jenkins:2.32

USER root

ENV MAVEN_VERSION 3.3.9
RUN cd /usr/local; wget -q -O - http://mirrors.ibiblio.org/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xvfz - && \
    ln -sv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven

WORKDIR /tmp/files

RUN chown -R jenkins.jenkins .
USER jenkins
RUN echo '<settings><mirrors><mirror><id>central</id><url>http://repo.jenkins-ci.org/simple/repo1-cache/</url><mirrorOf>central</mirrorOf></mirror></mirrors><localRepository>/usr/share/jenkins/ref/.m2/repository</localRepository></settings>' > settings.xml 
COPY plugins.txt ./
RUN /usr/local/bin/install-plugins.sh $(cat plugins.txt)

ADD JENKINS_HOME /usr/share/jenkins/ref

USER root
RUN chown -R jenkins.jenkins /usr/share/jenkins/ref
COPY run.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/run.sh

USER jenkins
CMD /usr/local/bin/run.sh

EXPOSE 8080 8081 9418
