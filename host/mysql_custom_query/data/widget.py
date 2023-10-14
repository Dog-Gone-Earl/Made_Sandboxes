

"""
Your team has opened a new data region for e-commerce sale of digital widgets
You want to track the creation/purchases of product1 in this region compared to other 2
Your accounting team wants a real-time dashboard to track the db entries of product1

custom query: select quan,parts from widget_database.parts_table where parts='1gF78';
sudo mysql -uroot --execute="select quan,parts from widget_database.parts_table where parts='1gF78';"

"""

import time
import random
import mysql.connector


while True:

  quantity=random.randrange(1,9)
  part= ["1gF78", "9pV19","5eM40"]
  price= 19.99

  #Put Gauge data in mysql database
  cnx = mysql.connector.connect(user='parts_buyer', password='Datadog2023', database='widget_database')
  cursor = cnx.cursor()
  
  add_purchase = ("INSERT INTO parts_table " "(quan,parts,price) " "VALUES ( %(quan)s, %(parts)s, %(prices)s)")
  
  cust = {
    'quan' : quantity,
    'parts' : part(random.randrange(0,2)),
    'price' : price
  }
  
  cursor.execute(add_purchase, cust)
  weather_id = cursor.lastrowid
  
  cnx.commit()
  cursor.close()
  cnx.close()

  print(quantity, part, price)

  time.sleep(10)
