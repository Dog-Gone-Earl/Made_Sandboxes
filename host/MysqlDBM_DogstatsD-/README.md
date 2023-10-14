# dogstatsd_mysql_dbm


# directory/to/your/vm

## What this VM does
### <h3>Dogstatsd (Python) and Mysql DBM Metrics</h3>
- Based on Python Weather App 1.0
(https://datadoghq.atlassian.net/wiki/spaces/TS/pages/2789376418/Dogstatsd+Exercise+Python)<p></p>


### This VM will spin up a Ubuntu VM to run:
- Python Weather App 2.0 
  - Submit Dogstatsd (Python) metrics
  - Submit Mysql and Mysql DBM metrics from Database and Dogstatsd metric inserts to database
- Using current version Agent 7

## VM type: Linux Ubuntu (uwbbi/bionic-arm64)

## Special Instructions

- Make sure that both `api/app key` is in `~/.sandbox.conf.sh` file
- `cd` to directory and in terminal then launch `./run.sh up`
- Once sandbox configuration completed run `./run.sh ssh` to ssh into VM
- ### run command:
<pre>python3 data/weather.py</pre>
- <h3>Dogstatsd Metric Names:</h3>
<pre>
  statsd.gauge('temperature.gauge',temperature,tags=["environment:dev"])  #temperature.gauge
  statsd.gauge('humidity.gauge',humidity, tags=["environment:dev"])       #humidity.gauge
  statsd.gauge('pressure.gauge',pressure, tags=["environment:dev"])       #pressure.gauge</pre>
- Terminal Output will be Dogstatsd data being sent to Datadog `(temperature, humidity, pressure)`
- ### To stop Python app:
<pre>ctrl+c</pre>
