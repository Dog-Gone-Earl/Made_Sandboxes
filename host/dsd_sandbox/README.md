# dogstatsd_mysql_dbm

## What this VM does
### <h3>Dogstatsd (Python) and Mysql DBM Metrics</h3>
- Based on [Python Weather App 1.0](https://datadoghq.atlassian.net/wiki/spaces/TS/pages/2789376418/Dogstatsd+Exercise+Python)<p></p>


### This VM will spin up a Ubuntu VM to run:
- Python Weather Application to simulate collecting temperature, humidity, and pressure values
- Mimicking raspberry pi Sense HAT functionality ([Sense HAT](https://www.raspberrypi.com/products/sense-hat/))
  - Submit Dogstatsd (Python) metrics that are also being sent to Mysql database
  - Agent collects Mysql metrcis and Mysql DBM metrics
- Using current version Agent 7

## VM type: Linux Ubuntu (hajowieland/ubuntu-jammy-arm)

## Special Instructions

- Make sure that both `api/app key` is in `~/.sandbox.conf.sh` file

### 1. Configure your `datadog_user`,`datadog_pw`, `mysql_user`, and `mysql_user_pw` parameters in `setup.sh` file:

![image](https://github.com/Dog-Gone-Earl/Made_Sandboxes/assets/107069502/ec0196ad-d947-4fe7-8df6-fd544acad9b2)

### 2. Run commands
<pre>./run.sh up
./run.sh ssh </pre>

### 3. Once sandbox is deployed, run command:

<pre>python3 weather.py</pre>
<h3>Default Gauge Metrics Being Sent (other options commented out to be tried as well):</h3>

- `statsd.gauge('temperature.gauge',temperature,tags=["environment:dev"])  #temperature.gauge`
- `statsd.gauge('humidity.gauge',humidity, tags=["environment:dev"])       #humidity.gauge`
- `statsd.gauge('pressure.gauge',pressure, tags=["environment:dev"])       #pressure.gauge`
### Terminal output will be data being sent to Datadog thru Dogstatsd and metrics to Mysql database
-  `(temperature, humidity, pressure)`
-  Metrics should generate for mysql (overview dashboard), mysql database monitoring, and custom Dogstatsd metrics
### 4. To stop Python app:
<pre>ctrl+c</pre>
