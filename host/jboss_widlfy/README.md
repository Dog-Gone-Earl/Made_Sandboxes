# jboss_widfly

# sandbox/vagrant/agent7

## What this VM does

- Spins up Jboss/Widly on sandbox

## VM type: os_or_distribution

- hajowieland/ubuntu-jammy-arm

## Special Instructions

### Run 
```
sudo chmod 770 run.sh; ./run.sh up; ./run.sh ssh
```

### 1. Once completed run script to setup jboss/wildfly Admin user
```
sudo /opt/wildfly/bin/add-user.sh
``` 

### 2. Enter `a` to begin configuring jboss/wildfly user
![image](https://github.com/Dog-Gone-Earl/jboss_widfly/assets/107069502/6d9c6e81-fa14-4a0b-8603-52a44f020506)

### 3. Enter `user` and `password` for logging into to jboss/wildfly
![image](https://github.com/Dog-Gone-Earl/jboss_widfly/assets/107069502/dcfec23f-ab6d-4512-b3f2-ea7b3be3296a)

### 4. Select `enter` and type `yes` in prompts
![image](https://github.com/Dog-Gone-Earl/jboss_widfly/assets/107069502/dc11f644-689e-42cb-8470-c1ed17148180)
### Can confirm ports `8080` and `9990` are open with commands

```
ss -tunelp | grep 8080

ss -tunelp | grep 9990
```
![image](https://github.com/Dog-Gone-Earl/jboss_widfly/assets/107069502/53914dd1-3f52-4fe5-9e01-8b8a2275b25b)

### 5. Run script to setup the `user` and `password` in jboss/wildfly `.yaml` file
- Also sets `/opt/wildfly/bin/` to your `$PATH` to run WildFly scripts from your current shell session
```
bash ~/data/jboss_user.sh ;source ~/.bashrc
```
![image](https://github.com/Dog-Gone-Earl/jboss_widfly/assets/107069502/56de5acf-feeb-40e5-b92f-fc1d5100cafd)

#### - Can run command to login to jboss/wildfly
```
jboss-cli.sh --connect
```
#### - Type in version to see application information

```
version
```
![image](https://github.com/Dog-Gone-Earl/jboss_widfly/assets/107069502/2c377f4a-5858-4432-a1f0-cb88ec103a31)

#### - Can also check status with the command
```
sudo systemctl status wildfly
```
### 6. Check Agent status
```
sudo datadog-agent status
```
![image](https://github.com/Dog-Gone-Earl/jboss_widfly/assets/107069502/a33ed441-6bf5-4f59-be21-35877f975fa5)

### Agent will recognize jboss/wildfly integration, enable OOTB dashboard, service check and logs.

### Have the Agent Tail Older jboss/wildfly Initialization logs
```
sudo cp /opt/wildfly/standalone/log/server.log /opt/wildfly/standalone/log/server2.log
```

# Future Update
- Deploy Java quickstart application to generate metrics





