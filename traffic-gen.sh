
PO=$(kubectl get po -n guestbook|grep frontend| awk '{ print $1 }')

 echo "Generate legit traffic"
 echo "$PO"
 kubectl exec -it $PO -n guestbook -- bash -c "watch curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=get"



echo "deploy attacker"
kubectl run attacker  --image=rbenavente/evilpetclinic -n guestbook

P1=$(kubectl get po -n guestbook|grep attacker| awk '{ print $1 }')
echo "$P1"
echo "scan ports"
kubectl exec -it $P1 -n guestbook -- sh -c "nmap -p 80,8080,8081,8082,8083,8084,6379, 2375,10250,6443,9998 frontend.guestbook.svc.cluster.local"
kubectl exec -it $P1 -n guestbook -- sh -c "watch curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=set&value=,"
kubectl exec -it $P1 -n guestbook -- sh -c "watch curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=get"

command || true





//watch curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=set&value=,
