 #### my example voting app

 below is our senario:



i make 2 dir in this dir in first one i use db as statfulSet in second db as service

if u wnat use just deployment and svc then use option dir deploy

if u wnat use stateful and svc then use option dir statuful


 # 1- using deployment and service: 
 
 first make deploy file for all 5 resource then write servic for all exclude worker.


 # 2- using stateful and service: 

use deploy for vote and result , stateful for db and redis , service all exclude worker.
 
