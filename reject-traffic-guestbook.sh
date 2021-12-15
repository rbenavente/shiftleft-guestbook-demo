echo "Reject traffic by default on K8s namespace"
apoctl auth verify
echo "${env.tenant}/${env.cloudAccount}/${env.group}/${env.ns}"
PO=$(apoctl api list namespace --recursive -f name==/${env.tenant}/${env.cloudAccount}/${env.group}/${env.ns} -c ID -o yaml | awk '{ print $3 }')
echo "$P0"
apoctl api update namespace $P0 --namespace /${env.tenant}/${env.cloudAccount}/${env.group} -k  'defaultPUIncomingTrafficAction=Reject' 
apoctl api update namespace $P0 --namespace /${env.tenant}/${env.cloudAccount}/${env.group} -k  'defaultPUOutgoingTrafficAction=Reject' 
