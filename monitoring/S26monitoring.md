


# chef

automation tools in ruby and erlang. Chef is best suited for organizations that have a heterogenous infrastructure. 

agaent based and service based. ohai is chef agent. just speed of config is best than ansible  couse chef ssl but ansible ssh base.

knife tools in chef that used to connect is ssl base. chef playbook is reciepe. cookbook is multiple reciepe. in ansible multiple play is playbook.

# puppet

is ssl base that means good speed. agent based and servce base. puppet server is heavy and used alot of resource in machines. ruby language. DSL used.

multiple catalouge make manifest. used in cloud and heavy virtualization (up 250 server) in many servers used for deep freeze for config on client.


puppet masters check config every 5  minute to check if it change then restore to your admin config.

most important prons from ansible is config freeze in puppet.


# saltstack

Saltstack is Python based while the instructions are written in YAML or it’s DSL. CDK (cloud development kit) is used here to translate yml or other language to DSL.

multiple state make pillars. ssl baesd and saltstack agent is grains.


# terraform 

is the same to ansible . teraform has provides that act same as ansible modules. you can add providers to your teraform from teraform registery from address :

https://registry.terraform.io/


we can USE TERAFFORM WITHOUT INSTALL from its cloud . or install it on linux from cli. write your config in terraform cloud and say it to read form gitlab and bring it ,....


terraform is ssh based but it can login with ssl too( in aws has token base). teraform is used in cloud providers. its config language is HCL (hashicorp config language) and its simple and human readable. 

also here terraform has CDK and then can translate your yml file to HCL. 

terraform do versioning in deployment. and track resource change. rollback easily. apply .tf . if dont deesires then rollback with destroy .tf

infrastructure provisioning. that can do config managmnet (same as ansible ) too. 

can login with ipmi port to  server on cloud (or ilo) and run os and vm.. we can work with hcl or yml or json. 


	Chef	Puppet	Ansible	Saltstack	Terraform
Architecture	Server/Client	Server/Client	Server Only	Server/Client	Server/Client
Ease of Setup	Moderate	Moderate	Very Easy	Moderate	Very Easy
Language	Specify how to do a task	Specify only what to do	Specify how to do a task	Specify only what to do	Specify how to do a task
Scalability	Scalable	Scalable	Scalable	Scalable	Scalable
Management	Tough as it requires to learn Ruby DSL	Tough as it requires to learn Puppet DSL	Very Easy by YAML	Agnostic & Simple	JSON (YAML)
Interoperability	High	High	High	High	High
Cloud Availability	Amazon	Amazon, Azure	Amazon	None	Amazon
Communication	Knife Tool	SSL	SSH	SSH	SSH


































