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

$JENKINS_BASE_URL/github-webhook

in generic it'll be:

$JENKINS_URL/generic-webhook-trigger/invoke 


in gitlab go in project setting> integration menu. check desired box and give it  Jenkins server URL for example:

http://30.40.50.2:8080/generic-webhook-trigger/invoke

then give it user and pass jenkins server then test setting. with this setting gitlab push the jenkins. also here you can set https with ssl setting.




2- periodically:

to recommnaded this method. in this method in multibranch in buils configuration in scan multibranch pipeline triggers check the box : periodically if not otherwise run and set the interval. 





note: maven is package builder or compiler for java. npm or nodejs is  package builder or compiler for javascript or js. pip or pip3 is  package builder or compiler for python or pypy or py.  dotnetframework is  package builder or compiler for microsoft .net  .


see below toturials and complete projects for jenkins and kuber ,..:

https://www.youtube.com/watch?v=8YyamgWdvFg

https://www.youtube.com/watch?v=XE_mAhxZpwU

https://www.youtube.com/watch?v=X7bg3JVsGIw

https://www.youtube.com/watch?v=X7bg3JVsGIw



blue ocean plugins:

is a gui graphical theme to jenkins to run pipeline see all in diagram and its user freindly.




# gitlab


gitlab has 2 versions :

gitlab-ce: comunity editions is complete free edition of gitlab

gitlab-ee: enterprise editions needs license and not free its for enterprise company. 


you can install it on linux docker or with helm .see installation in :

https://about.gitlab.com/install/


gitlab and jenkins need many resource then its recommand to install it in linux or k8s cluster to use nfs and use  high availablity feature and they data should be permanent.


stable is install gitlab in linix server.





githau is just cloud base its SaaS or software as service. but gitlab has cloud and self managed(self hosted). amazone has ready to use gitlab vm.


in linux use install from source documentation. default installation package for gitlab is gitlab-ee then you can use feature that paid. but if you want use just gtilab-ce in future then install gitlab-ce.


you install gitlab-ce install from this site: its good to learn and use:


https://computingforgeeks.com/how-to-install-gitlab-ce-on-ubuntu-linux/



after installation gitlab give you tools that called gitlab-ctl to manage it. to see status:

gitlab-ctl status  - same you can use start and stop ,..


gitlab needs 3.8 or 4 gig ram. gitlab installer default has : postgres - nginx - exporter - prometheus - redis ,... becaouse its important gitlab server should be under monitoring.


gitlab config file is in :

/etc/gitlab

vi gitlab.rb - to change setting like:


external_url 'http://iporadrees/'   - to set url that you want use git lab on it 

you can config email or smtp or slack or ssl or cert ,.... 


azure devops is complete pakage gitrepo ansible ci/cd nexus , now gitlab is same complete pakage.

github is repo base but gitlab is project base . every project may have many repo.

we can make user and or teams and assign them to a repo. access level is standard. every user or team can have 5 role:

1- owner: higher level access

2- maintainer: devops engineers -access setting

3- developr: push - pull -merge - clone 

4- reporter: readonly : pull - clone -  (not push)

5- guest: view only



in gitlab we have: projectname/reponame


if want use gitlab for just ci/cd same as jenkins in new project page:

Run CI/CD for external repository: Connect your external repository to GitLab CI/CD. 


other option is:

Create blank project: Create a blank project to store your files, plan your work, and collaborate on code, among other things.



Create from template: Create a project pre-populated with the necessary files to get you started quickly.



Import project: Migrate your data from an external source like GitHub, Bitbucket, or another instance of GitLab.




gitlab and github may be mirror then they be sysnc with each other . but in gtlab-ce mirror from gitlab to github is ok but from github to gitlab is not free.


auto devops is build ci to your pipeline but we disable it . its AI is not smart.


#### gitlab menu

issue is for isue the bug or problam


wiki can integrate with confluence to write document. 


code is write code and commit managment


build section is for devops that include: pipelines - jobs - pipeline editor - scheduled pipeline (same as cron job) - artifacts

in pipeline section we create pipeline. in jenkis to create pipeline first we go to our git repo create jenkinsfile there. so when we clone that repo in jenkins , its automatically detect jenkins file and run pipeline form that file and run stage and steps.


in all ci/cd pipeline we have specified file. that all have same context and infra . jobs stage steps,... : 

in gitlab : .gitlab-ci.yml

in github: .github-workflow.yml

in circle-ci : .circle-ci.yml


you can use template to write this file or write it ypurself from pipeline editor menu. if it exist then open it other wise click on configure pipeline to opne and create new file. its case sensitive:

Pipeline syntax is correct   - is check in backgroud your syntax

      stages:          # List of stages for jobs, and their order of execution- its == number of butons  - each stage contains jobs
        - build
        - test
        - deploy
      
      build-job:       # This job runs in the build stage, which runs first. In each job, we specify which stage this job belongs to. 
        stage: build
        script:                       # consist of desired commands
          - echo "Compiling the code..."
          - echo "Compile complete."
      
      unit-test-job:   # This job runs in the test stage.
        stage: test    # It only starts when the job in the build stage completes successfully.
        script:
          - echo "Running unit tests... This will take about 60 seconds."
          - sleep 60
          - echo "Code coverage is 90%"
      
      lint-test-job:   # This job also runs in the test stage.
        stage: test    # It can run at the same time as unit-test-job (in parallel).
        script:
          - echo "Linting code... This will take about 10 seconds."
          - sleep 10
          - echo "No lint issues found."
      
      deploy-job:      # This job runs in the deploy stage.
        stage: deploy  # It only runs when *both* jobs in the test stage complete successfully.
        environment: production
        script:
          - echo "Deploying application..."
          - echo "Application successfully deployed."




you can see build number and view pipeline. refresh to see update or retry to run again


*****each jobs contains:*****

stage: mandatory that revealed its belong to wich stage

before script: optional- it run before script that commamnly use for preconfigurations goals. for ex: docker login - ./preconfig.sh  - its dependancy for script

script: mandatory its run commands - if before scripts run succefully than script starts. for ex.: docker build -t tag .  -  docker push  - docker tag  - docker compose up -d (for deploy stage)

after script: optional -  then this always run. for : docker log out  - docker ps -a   - or send information email for admin


important note:

after script always run.

before script : failed --> script not run but after script runs




in setting integrations is very important for ex.: with slack or grafana or datadog ,.... if your app is not in this sections to integrate use webhook sections. integration is very important.


in integration for notify for ex.: with slack telgeram ,.... we get webhook from telegram and slack ,....

but in itegration for trigger in pipline with ci/cd for bitbucket ,... then we get webhook from gitlab. then add new in wehook menu in setting. 


in ci/cd menu in settings : runner is here. install runner in each stage servers with tag we call it in pipeline in job with tag. in label handel with label. handel called server . we add runner in this section and follow instrauction and run commnad to install it on servers.














































