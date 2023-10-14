# fluxcd Integration Sandbox

# Reference

<li><link>https://fluxcd.io/flux/installation/</link></li>
<li><link>https://fluxcd.io/flux/installation/#github-and-github-enterprise</link></li>
<li><link>https://fluxcd.io/flux/guides/monitoring/</link></li>


<h2>1. Start Vagrant Sandbox and Scripts:</h2>

- `vagrant up`

<h2>2. Generate a <a href="https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens">personal access token (PAT)</a> that can create repositories by checking all permissions under repo. </h2>

- `export CR_PAT=<PAT_TOKEN>`
  
- `echo $CR_PAT | docker login ghcr.io -u $GITHUB_USER --password-stdin`

- `export GITHUB_USER=<USER>`

- `export GITHUB_TOKEN=12346789`

<h2>3. Start Minikube with Command:</h2>

- `minikube start --driver=docker`

## 4. Install Flux onto your cluster
<pre>flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=fluxcd_sandbox \
  --branch=main \
  --path=clusters/my-cluster_fluxcd \
  --personal
  --private=false
</pre>

<h2>5. Run Fluxcd Script to install Promethues Stack</h2>

- `bash ~/data/flux_setup.sh`

### You will see a new repository added:
![image](https://github.com/Dog-Gone-Earl/fluxcd_dev/assets/107069502/ec216e87-c474-4910-9e16-16f4478ca23f)

## 6. Clone the git repository

- `git clone https://github.com/$GITHUB_USER/fluxcd_sandbox.git`

## 7. Install A Custom Agent Image to Install the Community Fluxcd Integration

####  (Fluxcd Integration not installed by default on Agent)

- `docker build ~/data -t ghcr.io/$GITHUB_USER/agent:<AGENT_VERSION>-custom`

- `docker push ghcr.io/$GITHUB_USER/agent:<AGENT_VERSION>-custom`

#### (Replace `<AGENT_VERSION>` with your Agent Version Installed)

### Package will show in Github:
![image](https://github.com/Dog-Gone-Earl/fluxcd_dev/assets/107069502/2908a636-4924-42e5-b052-a964ad65981a)

Note: Make package visibility `public` in Package Settings

## Install DD-Agent with Helm

## 8. Create a Kubernetes Secret to store your Datadog API key and app key:

- `kubectl create secret generic datadog-secret --from-literal api-key=$DD_API_KEY --from-literal app-key=$DD_APP_KEY`

## 9. Run the command to deploy Agent

<pre>helm install 'REALEASE-NAME' \
 -f ~/data/datadog-values.yaml \
 --set targetSystem=linux \
 datadog/datadog</pre>

Note: Install will take a little time. Run `kubectl get pods` to verify completion
## 10. Change to `fluxcd_sandbox` directory

- `cd fluxcd_sandbox`

## 11. Create a GitRepository manifest pointing to podinfo repository’s master branch:
<p>This example uses a public repository <a href="https://github.com/stefanprodan/podinfo">https://github.com/stefanprodan/podinfo)</a> a, podinfo is a tiny web application made with Go.</p>

<pre>flux create source git podinfo \
  --url=https://github.com/stefanprodan/podinfo \
  --branch=master \
  --interval=30s \
  --export > ./clusters/my-cluster_fluxcd/podinfo-source.yaml</pre>

## 12. Commit and push the podinfo-source.yaml file to the fleet-infra repository:

- `git add -A && git commit -m "Add podinfo GitRepository"`

## Set Username/Password if prompted for github repo commits
- `git config --global user.email "you@example.com"`
- `git config --global user.name "Your Name"`
 - `git push`

### If Authentication is Needed:

- `Username for 'https://github.com': <GITHUB_USER>`

- `Password for 'https://<GITHUBE_USER>@github.com':<PAT_TOKEN>`
 
 ## 13. Deploy podinfo application
 
  <pre>flux create kustomization podinfo \
  --target-namespace=default \
  --source=podinfo \
  --path="./kustomize" \
  --prune=true \
  --interval=5m \
  --export > ./clusters/my-cluster_fluxcd/podinfo-kustomization.yaml</pre>

## 15. Commit and push the Kustomization manifest to the repository:

- `git add -A && git commit -m "Add podinfo Kustomization"`

- `git push`

### Watch Flux sync the application 

## 16. Use the flux get command to watch the podinfo app.

- `flux get kustomizations --watch`

## 17. Check that podinfo pod has been deployed on your cluster:

- `kubectl -n default get deployments,services`

<li>Changes made to the podinfo Kubernetes manifests in the master branch are reflected in your cluster.</li>

<li>When a Kubernetes manifest is removed from the podinfo repository, Flux removes it from your cluster. When you delete a  
    Kustomization from the fleet-infra repository, Flux removes all Kubernetes objects previously applied from that Kustomization.</li>

<li>When you alter the podinfo deployment using `kubectl edit`, the changes are reverted to match the state described in Git</li>

 
