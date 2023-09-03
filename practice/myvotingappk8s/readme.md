
 
 # my example voting app
 

 below is our senario:

 

![image](https://github.com/zizitizi/my-devops-Roadmap/assets/123273835/bd1771cc-f488-4a55-92d3-849f4e50c280)


 
 
 
 #  using stateful and service: 

in this senario we use deploy for vote and result , stateful for db and redis , service all exclude worker.


just download stateful dir and run:


     kubectl apply -f stateful/
   

to check status:


     kubectl get all
   

to remove svc:


     kubectl delete -f stateful/





 #  using just deployment and service: 
 
 in this senario we make deploy file for all 5 resource then write servic for all exclude worker. download both stateful and deploy directory.

 in  downloaded stateful folder delete statful yaml file and related svc file. replace them with file in folder deploy. then run:
 

    kubectl apply -f stateful/
    

to check status:


     kubectl get all
     

to remove svc:


     kubectl delete -f stateful/


