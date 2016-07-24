#!groovy
node("slave") {
    def isUnix = isUnix();
    
    stage "checkout"

    checkout scm
    if (isUnix) {sh 'git submodule update --init'} else {bat "git submodule update --init"}

    stage "checkout oscript-library for testrunner.os"
    checkout([$class: 'GitSCM', branches: [[name: '*/develop']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'oscript-library']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/EvilBeaver/oscript-library.git']]])

    stage "testing with testrunner.os"

    command = """oscript ./oscript-library/tests/testrunner.os -runall ./tests xddReportPath ./tests"""
    if (isUnix) {sh "${command}"} else {bat "@chcp 1251 > nul \n${command} \n exit /b %ERRORLEVEL%"}       

    step([$class: 'JUnitResultArchiver', testResults: '**/tests/*.xml'])

    stage "exec all features"

    command = """oscript ./src/bdd.os ./features/core -out ./bdd-exec.log"""

    def errors = []
    try{
        if (isUnix){
            sh "${command}"
        } else {
            bat "@chcp 1251 > nul \n${command}\n exit /b %ERRORLEVEL% "
        }
    } catch (e) {
         errors << "BDD status : ${e}"
    }

    if (errors.size() > 0) {
        currentBuild.result = 'UNSTABLE'
        for (int i = 0; i < errors.size(); i++) {
            echo errors[i]
        }
    }           

    step([$class: 'ArtifactArchiver', artifacts: '**/bdd-exec.log', fingerprint: true])
}