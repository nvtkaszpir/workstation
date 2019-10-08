#!/usr/bin/env groovy

def job_desc = """
Jenkins multibranch job for 'workstation'
<br/>
<a href='https://github.com/nvtkaszpir/workstation'>github</a>
"""

pipeline {

  agent { label 'libvirt' }

  options {
    timeout(time: 1, unit: 'HOURS')
    disableConcurrentBuilds()
    ansiColor('xterm')
    timestamps() // breaks ansiColor plugin
    lock resource: 'workstation'

  }

  // notice that parameters are dynamically updated in first stage
  // parameters {
  // }

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

      steps {
        sh '''
        # python version is taken from .python-version
        pyenv virtualenv ws
        pyenv activate ws
        pip install -r requirements.txt
        '''
      }
    }

    stage('quick-tests') {

      parallel {
        stage('yamllint'){
          steps {
            sh '''
            pyenv activate ws
            yamllint .
            '''
          }
        }
        stage('ansible-lint'){
          steps {
            sh '''
            pyenv activate ws
            ansible-lint desktop.yaml
            '''
          }
        }

        stage('vagrant info'){
          steps {
            sh '''

            export | sort

            vagrant version
            vagrant plugin list

            vagrant plugin install vagrant-libvirt --plugin-clean-sources --plugin-version 0.0.45
            '''
          }
        }

      }
    }

    stage('test'){
      steps {
        sh '''
        pyenv activate ws

        export VM_TEARDOWN=true
        scripts/test_in_vagrant.sh

        '''
      }
    }




  }


  post {
    always {
      sh '''
      vagrant destroy -f
      pyenv virtualenv-delete -f ws
      '''

      archiveArtifacts allowEmptyArchive: true,  artifacts: '**/reports/*', excludes: '**/*.gitkeep', fingerprint: true
      deleteDir()
    }
  }
}
