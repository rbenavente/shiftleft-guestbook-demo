#/bin/bash!
while true; do curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=get; done
