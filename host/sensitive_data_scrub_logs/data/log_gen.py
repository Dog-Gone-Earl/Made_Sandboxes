import json, time, os, datetime, random

global log_data, locf_time,x
x=0

log_data = open("/var/log/data.log", "a")

def print_j():
  
    #print(data[rand_val])

        
    val = {"firstName": "John",
        "lastName":"Smith",
        "address1": "220 DD Lane",
        "city": "New York",
        "PostalCode": "12345",
        "phone": "8888888888",
        "mobilePhone": "7777777777",
        "email": "j.smith@dd.com"
        }
    j_swap = json.dumps(val)
    log_data.write("\n"+str(val))
    print(j_swap)

while x < 10:
    print_j
    x +=1
    time.sleep(1)
    print_j()
