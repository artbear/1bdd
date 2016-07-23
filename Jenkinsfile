#!groovy
node("slave") {
    def isUnix = isUnix();
    stage "checkout"

    // if (env.DISPLAY) {
    //     println env.DISPLAY;
    // } else {
    //     env.DISPLAY=":1"
    // }
    // env.RUNNER_ENV="production";

    checkout scm
    if (isUnix) {sh 'git submodule update --init'} else {bat "git submodule update --init"}
    // stage "init base"

    // //checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'SubmoduleOption', disableSubmodules: false, recursiveSubmodules: true, reference: '', trackingSubmodules: true]], submoduleCfg: [], userRemoteConfigs: [[url: 'http://git.http.service.consul/shenja/vanessa-behavior.git']]])
    // echo "${env.WORKSPACE}"

    // def srcpath = "./lib/cf/";
    // if (env.SRCPATH){
    //     srcpath = env.SRCPATH;
    // }
    // def v8version = "";
    // if (env.V8VERSION) {
    //     v8version = "--v8version ${env.V8VERSION}"
    // }
    // def command = "oscript tools/init.os init-dev ${v8version} --src "+srcpath
    // timestamps {
    //     if (isUnix){
    //         sh "${command}"
    //     } else {
    //         bat "chcp 1251\n${command}"
    //     }
    // }

    stage "exec all features"
    echo "exec all features from project"
    echo "${env.WORKSPACE}"

    command = """oscript ./src/bdd.os ./features/core -out ./exec.log"""
    if (isUnix) {sh "${command}"} else {bat "chcp 1251 \n${command}"}       

    stage "testing with testrunner.os"
    echo "testing with testrunner.os"
    echo "${env.WORKSPACE}"

    command = """oscript ../oscript-library/tests/testrunner.os -runall ./tests"""
    if (isUnix) {sh "${command}"} else {bat "chcp 1251 \n${command}"}       
    
    // stage "build"
    // echo "build catalogs"
    // command = """oscript tools/runner.os compileepf ${v8version} --ibname /F"./build/ib" ./ ./build/out/ """
    // if (isUnix) {sh "${command}"} else {bat "chcp 1251 \n${command}"}       
    
    // stage "test"
    // command = """oscript tools/runner.os xunit "./build/out/Tests" ${v8version} --ibname /F"./build/ib" --path ./build/out/xddTestRunner.epf  --report ./build/report.xml"""
    // if (isUnix){ sh "${command}" } else {bat "chcp 1251\n${command}"}
    // step([$class: 'JUnitResultArchiver', testResults: '**/build/report.xml'])
}