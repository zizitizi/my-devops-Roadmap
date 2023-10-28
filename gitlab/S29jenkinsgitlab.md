CD/CD :


every where we use gitlab . but for wondows app and .net base application azure devops recommanded that have good fature for it.

but .netcore that announce in 2016 in can insyall on linux and use in docker image. then we use for all purpose gitlab . but in some company they force to use windows app we use azure devops.but usually:

  if mostly use windows servers --> azure devops 

  if mostly use linux servers --> gitlab

  

# jenkins2

to reset jenkins admin user password and change it to no pass:


sudo vi /var/lib/jenkins/config.xml

change parameter useSecurity to false


systemctl restart jenkins


***practcie*** install jenkins in docker or with helm. be careful minimum ram is 2.5 or higher 3 or 4 .


then resfresh and goto site 127.0.0.1:8090 again to enter jenkins .



in jenkons security section is in manage jenkins menu. in system we have global setting and configs (git url- plugins, ssh ,...)

if we install kubernetes cli then we should read its documentation to use its config in ci/cd. but we study k8s before. but in git lab no need to use specific k8s configuration commmand. gitlab use k8s command in it . one of reason that we use gitlab instead of jenkins is that its simple and clear.


master=built-in node= 2 excuter in default

slave= 4 excuter in default

excuter help us to run pipeline in parallel. we can change default in mange jenkins>nodes>built-in node>configure


when you define new project you can go to configuration menu > sourcecode mangement > aive git repo adress. if its public no need to credential. but if its private then provide credential in specified box.

after clone that project we can write en excute shell : ls -l then goto menu press build now. see result in cosole out put menu.

jenkins clone projects in /var/lib/jenkins/workspace/devops/projectname/

also you can check it with:

cd /var/lib/jenkins/workspace/devops/projectname/;ls -l


### we have tree project type in jenkins:

#### free style: 

just clone project from git repo and execute specified commands. (commonly not known as pipeline it usualy use for scripting)-Simple, Single Tasks
Like, run tests


#### pipeline: 

is use for ci/cd pieline. that is like butun box to play actions to go next stages.Configure Whole Delivery Flow Like, Test | Build | Package | Deploy … -Just for a Single Branch. we mergs stage tother for ex.: build butom - deploy buton - and or test butun. you can configure to gitlab or github or jenkins triggers in project configuration > general menu. commonly git repo send notification to ci/cd.


pipeline write there or send from scm(source code mangment-git repo,..) here. for example docker file or docker compose ,... to build ,...


to add new node to jenkins check if it have install java v11 or 17 on it.



in jenkins use groovy language for write config file.

we use Declarative Pipeline format file.

build and deploy stage is mandatory and would be. but other stage is optional. sample stage:

build- deploy - ip(for external network) - test

in build stage we have this steps:

git ( git repo server url )  - clone ( to specified server) - docker (dockerise-build file) - push ( to hub)

in deploy stage we have this steps:

run that image- in kuber or docker 0r docker compose or docker swarm - in with resource service or deployment ,.. - 

stages are dockerise box. 

pipeline {
   agent any
   stages {
      stage('build') {
          steps{
            //
            }
          }
      stage('test') {
          steps{
            //
            }
          }  
             stage('deploy') {
          steps{
            //
            }
          }    
        }
}


            
then git repo is include:

1- sorce code 
2- ci/cd pipeline file( jenkins file - or gitlab-ci.yaml file- workflow.yml - circle-ci.yml - or ,...) - includes stages and steps
3- docker file- project file should be containerize
4- yaml file ( kuber)
5- compose file



sample stages( here we have 4 buttun):

1- docker build
2- docker push 
3- kubectl apply -f
4- test
.
.
.
.



another jenkins file format is :Scripted Pipeline

node {
  stage ('build') {
    //
    }
  stage ('deploy') {
    //
    }
}


you can test it in definitions> pipeline script> hello word(sample pipeline)


or try sample pipeline:

pipeline {
   agent any
   stages {
      stage('build') {
          steps{
            echo 'building the applications'
            }
          }
      stage('test') {
          steps{
            echo 'testing the applications'
            }
          }  
             stage('deploy') {
          steps{
            echo 'deploying the applications'
            }
          }    
        }
}



important its test in real world dont use agent any. use specified node name instead.



in real world senario we have:

build | test | deploy

dev   |dev   | dev

stg   | stg  | stg

prod  |prod  | prod




dev servers environmet to code

stg environmet to test( test bed) 

prod servers (deploy to public)


then we have these server: build | test | deploy

also in build server we have 3 server -  then here we have 3 jenkins file and specified node to specified wher we git or push ,.... these 3 jenkins file are same just difference is in lable name node in agent seciton we can not merge these 3. they are separate file (but in gitlab we can merge):

dev-build-server 

stg-build-server

prod-build-server



in menu status you can see that box or button and its timing that made in pipeline. raw is added if we run pipeline again it manitane status 10or 15 raw.


we can define post actions:

3 post attribute: success - failure - always

for example after complete pipeline email admin

then try:


pipeline {
   agent any
   stages {
      stage('build') {
          steps{
            echo 'building the applications'
            }
          }
      stage('test') {
          steps{
            echo 'testing the applications'
            }
          }  
             stage('deploy') {
          steps{
            echo 'deploying the applications'
            }
          }    
        }
   post {
     success { 
         mail -s "successfule finneshed pipelein" root@localhost
   }
     failure { 
         mail -s "failed finneshed pipeline" root@localhost
   }
     always { 
         mail -s "just finneshed pipeline" root@localhost
         echo 'finished'
   }
        
}



we can define conditions:

when {
   experssions {
       }
     }

     
Here, test steps will be execute just if BRANCH_NAME variable equals to ‘dev’.
Two expressions can use with || or &&.


git flow or branching system is:

- branch name in real: 3 brach use commonly: main for prod. of ok get downtime to affect site to see costomers.
- staging for stg (qa test it same as productions) - on branch work then if ok merge to prod.
- develop for dev ( devlopers use this and test) - branch(for example hotfix) work then merge to stage


dev and stg is always further then main.

### environemental variable

Environmental Variables can used in jenkins file to call it you shoud use ${VAR}


VAR = '1.2'

### credential

we have docker login push logout then we need credential then we can provide it in jenkins file( not recommanded). we define credential alwayes in mange jenkins>credentials menu

scope system global can use in all projects.


but if we define this in project setting page then it used just in that project

user name password cred and give id then we can call that cres with that id.


First, define Credentials in Jenkins GUI.
Second, add a new Env Variable with value “credentials(‘Credential_ID’)”



#### multibranch pipline:

Like Pipeline Just for Multibranch. if we have for example 3 branch : main stg dev then we have jenkins file for each and specific pipline for them: jenkinsfile-main , jenkinsfile-stg , jenkinsfile-dev . multi branch in more smart then its recognize branches. but if we use simple pipline type to multibranch project we should write script and use condition.




to see all environmet variable in your jenkons type in browser:

http://127.0.0.1:8090/env-vars.html/


for example you can use   BUILD_NUMBER in tag when you want push . dockertag:buildnumber. when developers use latest tag we can found specified tag in pipline with this var.



### Ways of Triggers a Build

1- webhook:


webhooks in apps is a type of api that when we put in gitlab when we have new commit then gitlab calls jenkins wehook to run pipline automatically. we use automatic pipeline in dev and stg environmets. in production or main becouse we need to get downtime then we do it manually coomonly in midnight. to use this feature we should add related plugin to jenkins. maybe github or gitlab or bitbucket ,.. plugins. in dashboard in manage jenkins in available pluging in generic webhook trigger that this is generic webhook and work with github gitlab , bitbucket , jira ,... too. install it. and dont forget to check the restart jenkins options in next download page. restart may take a while. 

whitelist enables if you set 0.0.0.0/0 every one can tiggers the webhook it. 


you can install discord notifier plugin to notify you in discord every change in pipeline

same we can integrate gitlab and slack too.




2- periodically:

to recommnaded this method.


































