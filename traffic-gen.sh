
echo "deploy attacker"

kubectl run attacker  --image=rbenavente/evilpetclinic -n guestbook

PO=$(kubectl get po -n guestbook|grep frontend| awk '{ print $1 }')
P1=$(kubectl get po -n guestbook|grep attacker| awk '{ print $1 }')

if [[ $PO == *"No resources found"* ] or [ $P1 == *"No resources found"* ]]; then
   sleep 120
else
echo "scan ports"
kubectl exec -it $P1 -n guestbook -- sh -c "nmap -p 80,8080,8081,8082,8083,8084,6379,2375,10250,6443,9998 frontend.guestbook.svc.cluster.local"

echo "Generate legit traffic"
for i in {1..5}; do 
kubectl exec $PO -n guestbook -- bash -c "curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=get"
kubectl exec $PO -n guestbook -- bash -c "curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=set&value=,"
kubectl exec $PO -n guestbook -- bash -c "curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=get";  
done

echo "Generate non authorized traffic"
kubectl exec -i $P1 -n guestbook -- sh -c " curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=set&value=,,,"
kubectl exec $P1 -n guestbook -- sh -c "curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=get"
kubectl exec -i $P1 -n guestbook -- sh -c " curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=set&value=,,,,"

fi


//watch curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=set&value=,
