#!/bin/sh

kubectl delete deployment -l app=redis  -n guestbook && \
kubectl delete service -l app=redis  -n guestbook && \
kubectl delete deployment frontend  -n guestbook && \
kubectl delete service frontend  -n guestbook && \
kubectl delete namespace guestbook
