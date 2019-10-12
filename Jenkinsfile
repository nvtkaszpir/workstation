#!/usr/bin/env groovy

def job_desc = """
Jenkins multibranch job for 'workstation'
<br/>
<a href='https://github.com/nvtkaszpir/workstation'>github</a>
"""

pipeline {

  agent { label 'libvirt' }

  options {
    timeout(time: 2, unit: 'HOURS')
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
    V_CPU = 2
    V_MEM = 512
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
    stage('pyenv') {

      parallel {
        stage('pyenv') {
          steps {
            sh '''#!/bin/bash -l
            # python version is taken from .python-version
            pyenv virtualenv ws
            pyenv activate ws
            pyenv install --upgrade pip==19.2.3
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
            vagrant plugin list

            vagrant plugin install vagrant-libvirt --plugin-version 0.0.45
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
            ansible-lint desktop.yaml
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

      archiveArtifacts allowEmptyArchive: true,  artifacts: '**/reports/*', excludes: '**/*.gitkeep', fingerprint: true
      deleteDir()
    }
  }
}
