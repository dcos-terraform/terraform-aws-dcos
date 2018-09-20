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
                sh 'tfdescsan --test --tsv https://dcos-terraform-mappings.mesosphere.com/ --var variables.tf'
            }
        }
        stage('Validate outputs.tf descriptions') {
            agent { label "tfdescsan" }
            steps {
                sh 'tfdescsan --test --tsv https://dcos-terraform-mappings.mesosphere.com/ --var outputs.tf'
            }
        }
    }
}
