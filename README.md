# microseg-guestbook-demo
Demo to deploy a guestbook app and secure the full app lifecycle including microsegmentation ruleset

This Repo is aimed to demonstrate the shift left capabilities of both Prisma Cloud and Bridgecrewdemo. You can simulate the deployment of  a GKE cluster from a vulnerable terraform  template and then  you will  deploy  the google  guestbook microservice on the cluster.   

You can use this demo to cover these use cases:
 - CI/CD Integration for image scanning for  vulnerability and malware protection
 - CI/CD Integration for IaC scanning:  Terraform and K8s yaml
 - Policy-as-Code in CI/CD for microsegmentation
 - Microsegmentation

You can find this files:

- Dockerfile:  Dockerfile from gcr.io/google_samples/gb-frontend:v5 to add intended malicious binaries.
- GKE vuln.tf: Vulnerable TF template to deploy a GKE cluster with errors that can be fixed by Bridgecrew.   If you integrate your repo with Bridgecrew you could also  show the remediation capabilities 
- Jenkinsfile: the script to run the full demo.
- Jenkinsfile-deployenforcer: the script to automate the deployment of the enforcers.
- PaC-jenkinsfile:  script to run only Policy as Code demo with microsegmentation.
- Guestbook Manifests: 
  -- redis-follower-deployment.yaml
  -- redis-follower-service.yaml
  -- redis-leader-deployment.yaml
  -- redis-leader-service.yaml
  -- frontend-deployment.yaml
  --  frontend-service.yaml
  -- reject-traffic-guestbook.sh
- Ruleset and External Networks for Microsegmentation:
 --dns-ruleset.yaml
 --guestbook-ruleset.yaml
- traffic-gen.sh: generate legit and non-authorize traffic


