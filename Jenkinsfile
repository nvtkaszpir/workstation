#!/usr/bin/env groovy

def job_desc = """
Jenkins multibranch job for 'workstation'
<br/>
<a href='https://github.com/nvtkaszpir/workstation'>github</a>
"""

pipeline {

  agent { label 'libvirt' }

  options {
    timeout(time: 4, unit: 'HOURS')
    disableConcurrentBuilds()
    ansiColor('xterm')
    timestamps() // breaks ansiColor plugin
    lock resource: 'workstation'

  }

  // notice that parameters are dynamically updated in first stage
  // parameters {
  // }

  environment {
    PYENV_VIRTUALENV_DISABLE_PROMPT=1
  }
  
  stages {

    stage('Reconfig job'){
      steps {
        script{
          def job = Jenkins.instance.getItemByFullName(job_name)
          // change description
          def pr_desc = ""
          if ( env.CHANGE_ID != null) {
            pr_desc += "<br/>"
            pr_desc += "<br/>"
            pr_desc += "<br/>"
            pr_desc += "<h2>Change URL: <a href='${env.CHANGE_URL}'>${env.CHANGE_TITLE}</a></h2><br/>"
          }
          job.setDescription(job_desc + pr_desc)
          job.save()
        }
      }
    }


    stage('review') {
      when {
        // run review step if this is PR and the PR is not from repo owner
        expression { (env.CHANGE_ID != null) && (env.CHANGE_AUTHOR != 'nvtkaszpir') }
      }

      steps {
        script {
          approve = input(message: "Continue with build?", submitter: 'kaszpir', parameters: [
            choice(
              name: 'result',
              choices: ["No", "Yes"].join("\n"),
              description: "Please review the code and continue build if it looks good."
            )
          ])

          if (approve == "Yes") {
            println "Review stage approved."
          }
          else
          {
            currentBuild.result = 'ABORTED'
            error("Review stage not approved.")
          }
        }
      }
    }



    stage('pyenv') {

      parallel {
        stage('markdownlint') {
          steps {
            sh '''#!/bin/bash -l
            docker run -v $PWD:/markdown:ro 06kellyjac/markdownlint-cli .
            '''
          }
        }

        stage('pyenv') {
          steps {
            sh '''#!/bin/bash -l
            # python version is taken from .python-version
            pyenv install -s
            pyenv virtualenv ws
            pyenv activate ws
            pip install --upgrade pip==20.3.3
            hash -r
            pip install -r requirements.txt
            '''
          }
        }

        stage('vagrant info'){
          steps {
            sh '''#!/bin/bash -l

            export | sort

            vagrant version
            vagrant plugin list | grep vagrant-libvirt \
              || vagrant plugin install vagrant-libvirt --plugin-version 0.0.45
            '''
          }
        }
      }
    }

    stage('quick-tests') {

      parallel {
        stage('yamllint'){
          steps {
            sh '''#!/bin/bash -l
            pyenv activate ws
            yamllint .
            '''
          }
        }
        stage('ansible-lint'){
          steps {
            sh '''#!/bin/bash -l
            pyenv activate ws
            ansible-lint desktop.yml
            '''
          }
        }

      }
    }

    stage('test'){
      steps {
        sh '''#!/bin/bash -l
        pyenv activate ws

        export VM_TEARDOWN=true
        scripts/test_in_vagrant.sh

        '''
      }

      post {
        always {
          sh '''#!/bin/bash -l
          vagrant destroy -f
          '''
        }
      }
    }

  }


  post {
    always {
      sh '''#!/bin/bash -l
      pyenv virtualenv-delete -f ws
      '''

      archiveArtifacts allowEmptyArchive: true,  artifacts: 'reports/**/*.*', excludes: '**/*.gitkeep', fingerprint: true
      deleteDir()
    }
  }
}
