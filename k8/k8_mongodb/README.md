# k8_mongo
Mongo Integration with Kubernetes Agent

<pre>
vagrant up
minikube start --driver=docker 
export DD_API={API_KEY}
helm install ddmongo -f data/values.yaml  --set datadog.apiKey=${DD_API} datadog/datadog && kubectl apply -f data/mongo_ad_v2.yaml #AD v2
helm install ddmongo -f data/values.yaml  --set datadog.apiKey=${DD_API} datadog/datadog && kubectl apply -f data/mongo_ad_v1.yaml #AD v1
kubectl exec -it {dd_pod} agent check mongo</pre>
