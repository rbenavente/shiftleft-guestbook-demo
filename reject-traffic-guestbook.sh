echo "Reject traffic by default on K8s namespace"

PO=$(./apoctl api get namespace /${env.tenant}/${env.cloudAccount}/${env.group}/${env.ns} -c ID -o yaml |grep ID| awk '{ print $2 }')
./apoctl api update namespace $P0 --namespace /${env.tenant}/${env.cloudAccount}/${env.group} -k  'defaultPUIncomingTrafficAction=Reject' 
./apoctl api update namespace $P0 --namespace /${env.tenant}/${env.cloudAccount}/${env.group} -k  'defaultPUOutgoingTrafficAction=Reject' 
