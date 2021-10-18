node {
    def app
   
   environment {
        guestbook = "${env.ns}"
    }
    
    stage('Startup Process') {
        sh 'rm -f -r -d *'
        sh 'rm -f -r -d .[!.]* ..?*'
    }

    stage('cloneRepository') {
        checkout scm
    }
	
// 	    stage('Build image') {
//         //This builds the actual image; synonymous to docker build on the command line
//         app = docker.build("rbenavente/gb-frontend-cns:${env.BUILD_NUMBER}_build", " .")
//         echo app.id
//     }

//     stage('Scan Image for Vul and Malware') {
//         try {
//             prismaCloudScanImage ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', ignoreImageBuildTime: true, image: "rbenavente/gb-frontend-cns:${env.BUILD_NUMBER}_build", key: '', logLevel: 'debug', podmanPath: '', project: '', resultsFile: 'prisma-cloud-scan-results.json'
//         } finally {
//             prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
//         }
//     }

//    stage('Scan image with twistcli') {
//        withCredentials([usernamePassword(credentialsId: 'twistlock_creds', passwordVariable: 'TL_PASS', usernameVariable: 'TL_USER')]) {
//            sh 'curl -k -u $TL_USER:$TL_PASS --output ./twistcli https://$TL_CONSOLE/api/v1/util/twistcli'
//            sh 'sudo chmod a+x ./twistcli'
//            sh "./twistcli images scan --u $TL_USER --p $TL_PASS --address https://$TL_CONSOLE --details rbenavente/gb-frontend-cns:${env.BUILD_NUMBER}_build"
//        }
//    }

//     stage('Push image to the registry') {
        //Finally, we'll push the image with two tags. 1st, the incremental build number from Jenkins, then 2nd, the 'latest' tag.
//        try {
//             docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-rbenavente') {
//                 app.push("${env.BUILD_NUMBER}")
//                 app.push("latest")
//             }
//         }catch(error) {
//             echo "1st push failed, retrying"
//             retry(5) {
//                 docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-rbenavente') {
//                     app.push("${env.BUILD_NUMBER}")
//                     app.push("latest")
//                 }
//             }
//        }
//    }
	
	

	
  stage('Scan TF to Deploy GKE ) {
  withDockerContainer(args: '-u root --privileged -v /var/run/docker.sock:/var/run/docker.sock', image: 'kennethreitz/pipenv:latest') {              
                //  sh "/run.sh cadc031b-f0a7-5fe1-9085-e0801fc52131 https://github.com/rbenavente/shiftleft-guestbook-demo"
   sh "pipenv install"
   sh "pipenv run pip install bridgecrew"
   sh "pipenv run bridgecrew --directory ./files  --bc-api-key cadc031b-f0a7-5fe1-9085-e0801fc52131 --repo-id rbenavente/shiftleft-guestbook-demo -o junitxml > result.xml || true"
   junit "result.xml"  
            
        }
   }
  stage('Scan k8s manifest') {
  withDockerContainer(image: 'bridgecrew/jenkins_bridgecrew_runner:latest') {              
                  sh "/run.sh cadc031b-f0a7-5fe1-9085-e0801fc52131 https://github.com/rbenavente/shiftleft-guestbook-demo"
               
            
        }
}	
    stage('Deploy Guestbook App') {
    withKubeConfig([credentialsId: 'k8s_config',
                    caCertificate: '',
                    serverUrl: '',
                    contextName: '',
                    clusterName: '',
                    namespace: ''
                    ]) {
            sh "kubectl create namespace ${env.ns} --dry-run -o yaml | kubectl apply -f -  && \
            kubectl apply -f redis-leader-deployment.yaml -n ${env.ns} && \
            kubectl apply -f redis-leader-service.yaml -n ${env.ns} && \
            kubectl apply -f redis-follower-deployment.yaml -n ${env.ns} && \
            kubectl apply -f redis-follower-service.yaml -n ${env.ns} && \
            kubectl apply -f frontend-deployment.yaml -n ${env.ns} && \
            kubectl apply -f frontend-service.yaml -n ${env.ns}"
        }
    }

    stage('Get Microsegmentation Creds') {
        withCredentials([file(credentialsId: 'pipeline.creds', variable: 'APOCTL_CREDS')]) {
            sh "cp \$APOCTL_CREDS $WORKSPACE/default.creds"
        }       
    }

    stage('Policy as Code: Create Ruleset for Guestbook App') {
        sh 'curl -o apoctl https://download.aporeto.com/apoctl/linux/apoctl'
        sh 'chmod +x apoctl'
        withEnv(["APOCTL_CREDS=$WORKSPACE/default.creds"]) {
            sh "./apoctl api import -n /${env.tenant}/${env.cloudAccount}/${env.group}/${env.ns} -f guestbook-ruleset.yaml \
                --set tenant=${env.tenant} --set cloudAccount=${env.cloudAccount} --set group=${env.group} --set ns=${env.ns}"
        }
    }
   stage('Generate traffic') {
        sh('chmod +x ./traffic-gen.sh && ./traffic-gen.sh')
    }
    
    stage('Finish Process') {
        sh 'rm -f -r -d *'
        sh 'rm -f -r -d .[!.]* ..?*'
    }
}
