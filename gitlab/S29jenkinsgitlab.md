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


we have tree project type in jenkins:

free style: just clone project from git repo and execute specified commands. (commonly not known as pipeline it usualy use for scripting)-Simple, Single Tasks
Like, run tests


pipeline: is use for ci/cd pieline. that is like butun box to play actions to go next stages.Configure Whole Delivery Flow Like, Test | Build | Package | Deploy … -Just for a Single Branch. we mergs stage tother for ex.: build butom - deploy buton - and or test butun. you can configure to gitlab or github or jenkins triggers in project configuration > general menu. commonly git repo send notification to ci/cd.


pipeline write there or send from scm(source code mangment-git repo,..) here. for example docker file or docker compose ,... to build ,...


to add new node to jenkins check if it have install java v11 or 17 on it.

































