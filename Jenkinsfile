#!/usr/bin/env groovy

pipeline {
    agent none
    stages {
        stage('Terraform FMT') {
            agent { label 'terraform' }
            steps {
                sh 'terraform fmt --check --diff'
            }
        }
        stage('Terraform validate') {
            agent { label 'terraform' }
            steps {
                sh 'terraform init'
                sh 'terraform validate -check-variables=false'
            }
        }
        stage('Validate variables.tf descriptions') {
            agent { label "tfdescsan" }
            steps {
                sh 'tfdescsan --test --tsv https://dcos-terraform-mappings.mesosphere.com/ --var variables.tf --cloud "$(echo ${JOB_NAME##*/terraform-} | sed -E "s/(rm)?-.*//")"'
            }
        }
        stage('Validate outputs.tf descriptions') {
            agent { label "tfdescsan" }
            steps {
                sh 'tfdescsan --test --tsv https://dcos-terraform-mappings.mesosphere.com/ --var outputs.tf --cloud "$(echo ${JOB_NAME##*/terraform-} | sed -E "s/(rm)?-.*//")"'
            }
        }
    }
}
