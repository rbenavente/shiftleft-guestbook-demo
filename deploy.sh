#!/bin/sh

# this sample is from:
# https://kubernetes.io/docs/tutorials/stateless-application/guestbook/

kubectl create namespace guestbook --dry-run=client -o yaml | kubectl apply -f - && \
kubectl apply -f redis-leader-deployment.yaml -n guestbook && \
kubectl apply -f redis-leader-service.yaml -n guestbook && \
kubectl apply -f redis-follower-deployment.yaml -n guestbook && \
kubectl apply -f redis-follower-service.yaml -n guestbook && \
kubectl apply -f frontend-deployment.yaml -n guestbook && \
kubectl apply -f frontend-service.yaml -n guestbook && \

kubectl get pods -n guestbook && \
kubectl get service -n guestbook
