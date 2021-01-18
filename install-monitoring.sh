#! /bin/bash

# Please read https://www.metricfire.com/blog/how-to-deploy-prometheus-on-kubernetes/?GAID=1189927494.1610920465

kubectl apply -f prometheus/monitoring-namespace.yaml

kubectl get namespaces


# The next step is to setup the configuration map.
# A ConfigMap in Kubernetes provides configuration data to all of the pods in a deployment. 


kubectl apply -f prometheus/prometheus-config2.yaml


# Next, we're going to set up a role to give access to all the Kubernetes resources 
# and a service account to apply the role to, both in the monitoring namespace.
# Specifically we'll set up a ClusterRole: 
# a normal role only gives access to resources within the same namespace, 
# and Prometheus will need access to nodes and pods from across the cluster 
# to get all the metrics we’re going to provide.


kubectl apply -f prometheus/prometheus-roles.yaml


# So now we’re ready! We have a namespace to put everything in, 
# we have the configuration, and we have a default service account with a cluster role bound to it. 
# We’re ready to deploy Prometheus itself.

# The deployment file contains details for a ReplicaSet,
# including a PodTemplate to apply to all the pods in the set. 
# The ReplicaSet data is contained in the first “spec” section of the file. 

kubectl apply -f prometheus/prometheus-deployment.yaml


# There’s one thing left to do before we can start looking at our metrics in Prometheus.
# At the moment we don’t have access to Prometheus, since it’s running in a cluster. 
# We can set up a service called a NodePort which will allow access to prometheus
# via the node IP address. 

kubectl apply -f prometheus/prometheus-nodeservice.yaml


kubectl apply -f prometheus/node-exporter-daemonset.yaml

# kubectl replace -f prometheus/prometheus-config2.yaml

