
## stateful app 

when we want keep alive session (java bean ,..) using sateful app. one of solution is websocket api that is stateful and conecctionbase. 


## run a databse in k8s

a deployment has a control-loop that manage to convert desired state to actual state. 

this is tutorial link:

https://chetak.hashnode.dev/database-on-kubernetes


when we use just one replica in db we can use deployment but not recommand. in multiple replica and more that 1 replica we should use statefulset to keep data continuous sync and persistent. 


in this site is yaml generator for k8s. its very usefull. for exam and other purpose in interview.

https://k8syaml.com/

but remember to delete label ads octupus 

octopusexport: OctopusExport





ai app to generate yaml file with cli and ai. you can install online version on master node k8s then use this to generate code and analyse. after insta;; we have command kubectl ai

https://github.com/sozercan/kubectl-ai


this is for scan all of k8s cluster analyse it for best practice and scurity problem and suggest best practice and bug.

https://k8sgpt.ai/


its a cli tools monitoring for k8s. like a btop. it can install on master or any place that have access to master. 


https://k9scli.io/


# networks or services in k8s

we call network in k8s, services. 




