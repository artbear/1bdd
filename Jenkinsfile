#!groovy
node("slave") {
    // ВНИМАНИЕ:
    // Jenkins и его ноды нужно запускать с кодировкой UTF-8
    //      строка конфигурации для запуска Jenkins
    //      <arguments>-Xrs -Xmx256m -Dhudson.lifecycle=hudson.lifecycle.WindowsServiceLifecycle -Dmail.smtp.starttls.enable=true -Dfile.encoding=UTF-8 -jar "%BASE%\jenkins.war" --httpPort=8080 --webroot="%BASE%\war" </arguments>
    //
    //      строка для запуска нод
    //      @"C:\Program Files (x86)\Jenkins\jre\bin\java.exe" -Dfile.encoding=UTF-8 -jar slave.jar -jnlpUrl http://localhost:8080/computer/slave/slave-agent.jnlp -secret XXX
    //      подставляйте свой путь к java, порту Jenkins и секретному ключу
    //
    // Если запускать Jenkins не в режиме UTF-8, тогда нужно поменять метод cmd в конце кода, применив комментарий к методу

    def isUnix = isUnix();
    
    stage "checkout"

    checkout scm
    cmd('git submodule update --init')

    stage "checkout 1testrunner"
    checkout([$class: 'GitSCM', branches: [[name: '*/develop']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: '1testrunner']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/artbear/1testrunner.git']]])

    stage "testing with testrunner.os"

    command = """oscript ./1testrunner/testrunner.os -runall ./tests xddReportPath ./tests"""
    cmd(command)

    step([$class: 'JUnitResultArchiver', testResults: '**/tests/*.xml'])

    stage "exec all features"

    command = """oscript ./src/bdd.os ./features/core -out ./bdd-exec.log -junit-out ./bdd-exec.xml"""

    def errors = []
    try{
        cmd(command)
    } catch (e) {
         errors << "BDD status : ${e}"
    }

    if (errors.size() > 0) {
        currentBuild.result = 'UNSTABLE'
        for (int i = 0; i < errors.size(); i++) {
            echo errors[i]
        }
    }           

    stage "exec libs features"

    command = """oscript ./src/bdd.os ./features/lib -out ./bdd-lib.log -junit-out ./bdd-lib.xml"""

    def errors = []
    try{
        cmd(command)
    } catch (e) {
         errors << "BDD status (lib) : ${e}"
    }

    if (errors.size() > 0) {
        currentBuild.result = 'UNSTABLE'
        for (int i = 0; i < errors.size(); i++) {
            echo errors[i]
        }
    }           

    step([$class: 'ArtifactArchiver', artifacts: '**/bdd-exec.log', fingerprint: true])
    step([$class: 'ArtifactArchiver', artifacts: '**/bdd-lib.log', fingerprint: true])
    step([$class: 'JUnitResultArchiver', testResults: '**/bdd*.xml'])
}

def cmd(command) {
    // TODO при запуске Jenkins не в режиме UTF-8 нужно написать chcp 1251 вместо chcp 65001
    if (isUnix()){ sh "${command}" } else {bat "chcp 65001\n${command}"}
}
