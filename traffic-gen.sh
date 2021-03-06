
echo "deploy attacker"

kubectl run attacker  --image=rbenavente/gb-frontend-cns:v1 -n guestbook

PO=$(kubectl get po -n guestbook|grep frontend| awk '{ print $1 }')
P1=$(kubectl get po -n guestbook|grep attacker| awk '{ print $1 }')

if [[ $PO == *"No resources found"* ] or [ $P1 == *"No resources found"* ]]; then
   sleep 180
else


echo "Generate legit traffic"
# // For your own image xxxx/gb-guestbook-cns the entrypoint.sh automatically generate http request but we need to enable apache2 server on the container
kubectl exec $PO -n guestbook -- bash  -c "service apache2 start"

# // For default images frm grc.io registry:
# for i in {1..5}; do
# kubectl exec $PO -n guestbook -- bash -c "curl -m 2  frontend.guestbook.svc.cluster.local/guestbook.php?cmd=get"
# kubectl exec $PO -n guestbook -- bash -c "curl -m 2  frontend.guestbook.svc.cluster.local/guestbook.php?cmd=set&value=,";  
# done

echo "Generate non authorized traffic"
#  // For the custom image user/gb-frontend-cns:v1: the entrypoint.sh automatically generate http request

echo "scan ports"
kubectl exec -it $P1 -n guestbook -- sh -c "nmap -p 80,8080,8081,8082,8083,8084,6379,2375,10250,6443,9998 frontend.guestbook.svc.cluster.local"

# // For default images from grc.io registry gcr.io/google_samples/gb-frontend:v5: 
# kubectl exec -i $P1 -n guestbook -- sh -c "curl -m 1 frontend.guestbook.svc.cluster.local/guestbook.php?cmd=set&value=,,,"
# kubectl exec $P1 -n guestbook -- sh -c "curl -m 1 frontend.guestbook.svc.cluster.local/guestbook.php?cmd=get"
# kubectl exec -i $P1 -n guestbook -- sh -c "curl -m 1 frontend.guestbook.svc.cluster.local/guestbook.php?cmd=set&value=,,,,"

fi


//watch curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=set&value=,
