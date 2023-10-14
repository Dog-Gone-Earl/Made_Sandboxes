# Dog-Gone-Earl/Secrets_Management

## What this VM does
### Datadog Mysql Connection with Secrets Management

<li>Live example of using Secrets Management with the Agent</li>
<li>Mysql Database will be created</li>
<li>Datadog Agent will be installed on Sandbox</li>
<li>Agent will collect <code>username/password</code> from Python executable <code>.py</code> file for Mysql Integration</li>

![image](https://github.com/Dog-Gone-Earl/Secrets_Management/assets/107069502/9da16fab-6c3e-4869-a414-48779a6ee3a2)

### <code>mysql.d/conf.yaml</code> Configuration
![image](https://github.com/Dog-Gone-Earl/Secrets_Management/assets/107069502/457bb408-e880-4283-98e3-4172f4b5609b)

<pic of Mysql yaml config>
  
<Show datadog-agent secret command output>
  
<show Agent status showing config>
  
## VM type: Linux Jammy

## Special Instructions

### Run Command:
<pre>
git clone https://github.com/Dog-Gone-Earl/Secrets_Management.git </pre>
<pre>cd Secrets_Management</pre>
<pre>./run.sh up</pre>

  
## If you receive a permissions error:
<pre>chmod 770 run.sh && ./run.sh up</pre>

## SSH into Sandbox
<pre>./run.sh ssh</pre>
  
### Confirm Secrets Being Used:
<pre>
sudo datadog-agent secret</pre>

![image](https://github.com/Dog-Gone-Earl/Secrets_Management/assets/107069502/f0519f2a-38a2-49e7-aa71-375c2ec401bf)

## Secrets Managaement Documentation
  <li><link>https://docs.datadoghq.com/agent/guide/secrets-management/?tab=linux#pagetitle</li></link>
  <li><link>https://datadoghq.atlassian.net/wiki/spaces/TS/pages/887259347/Secrets+Management+How-To+s</li></link>
  <li><link>https://datadoghq.atlassian.net/wiki/spaces/TS/pages/328436442/Using+secrets+management+on+Windows</li></link>
  <li><link>https://datadoghq.atlassian.net/wiki/spaces/TS/pages/1141900074/How+to+use+Kubernetes+Secrets+for+Secrets+Management</li></link>