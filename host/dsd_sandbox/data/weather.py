from datadog import initialize, statsd
import time, random, os, mysql.connector

#Configuring Dogstatsd
options = {
    'statsd_host':'127.0.0.1',
    'statsd_port':8125
}

initialize(**options)

while True:

  temperature = round(random.uniform(70,90),0)
  humidity = round(random.uniform(30,40),0)
  pressure = round(random.uniform(800,1100),0)
 
  #Count
  statsd.increment('temperature.count.increment',temperature,tags=["environment:dev"])
  statsd.decrement('temperature.count.decrement',temperature,tags=["environment:dev"])  
  statsd.increment('humidity.count.increment',humidity,tags=["environment:dev"])
  statsd.decrement('humidity.count.decrement',humidity,tags=["environment:dev"])  
  statsd.increment('pressuse.count.increment',pressure,tags=["environment:dev"])
  statsd.decrement('pressure.count.decrement',pressure,tags=["environment:dev"]) 
 
  #Gauge
  statsd.gauge('temperature.gauge',temperature,tags=["environment:dev"])
  statsd.gauge('humidity.gauge',humidity,tags=["environment:dev"])
  statsd.gauge('pressure.gauge',pressure,tags=["environment:dev"])
 
  #Histogram (.avg, .median, .count, .max, .95percentile)
  statsd.histogram('temperature.histogram',temperature,tags=["environment:dev"])
  statsd.histogram('humidity.histogram',humidity,tags=["environment:dev"])
  statsd.histogram('pressure.histogram',pressure,tags=["environment:dev"])
  
  #Distribution (avg, count, max, min)
  statsd.distribution('temperature.distribution',temperature,tags=["environment:dev"])
  statsd.distribution('humidity.distribution',humidity,tags=["environment:dev"])
  statsd.distribution('pressure.distribution',pressure,tags=["environment:dev"])

  #Put Gauge data in mysql database/table
  mysql_user = os.getenv("MYSQL_USER") 
  mysql_pw = os.getenv("MYSQL_PW") 
  weather_db= 'weather_database'
  
  params = {
    'user': mysql_user, 
    'password': mysql_pw,
    'database': weather_db
}

  cnx = mysql.connector.connect(**params)
  cursor = cnx.cursor()
  add_weather = ("INSERT INTO weather_table " "(temp,humidity,pressure) " "VALUES ( %(temp)s, %(humi)s, %(psi)s)")
  
  weather_data = {
    'temp' : temperature,
    'humi' : humidity,
    'psi' : pressure
  }
  
  cursor.execute(add_weather, weather_data)
  weather_id = cursor.lastrowid
  
  cnx.commit()
  cursor.close()
  cnx.close()

  print(temperature, humidity, pressure)

  time.sleep(.5)