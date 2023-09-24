

# rest of ansible builtin module




hint: in yaml file if we have not arguments then just write name of module with : .

      tasks:
        - name: pinging
          ping:




sample for copy module:

                  tasks:
                    - name: copy new fiel
                      copy:
                        src: /home/test.sh
                        dest: /tmp
                        force: yes # if file exist in dest then ansible not hinging it will replace and overwrite- best practice
                        backup: yes  # save timestamp and permssion and ownership will kept for that file. if no they not kept - best practice
                        
                  
                    - name: aading execute permission
                      shell: "chmod +x /tmp/test.sh"
                  
                    - name: execute that script
                      script: /tmp/test.sh
    
    
    


 execute that script you can use script or shell module. if you give that file exec permission you can use script but if not you should use shell module to gice it exec permission

in 21th september we should chech for change in time in server. then if not change we change it manually by this method . writing script and excute on server in ansible.


shell module is deprecated we use file module instead. file )pythonic command) performance is better that shell:

                  - name: add permission
                    file:
                       src: /tmp/test.sh
                       mode: 775   - which is in src file permission
                    


# ansible playbook handlers:

use to write reapteable task one time in yml file and call it in any task with notify: nameOfAppreciateHandler . periority is not important in yml it compile in python.



                  hosts: all
                    become: yes
                    tasks:
                      - name: install vsftpd on ubuntu
                        apt: name=vsftpd update_cache=yes state=latest
                        ignore_errors: yes
                        notify: start vsftpd
                  
                      - name: install vsftpd on centos
                        yum: name=vsftpd state=latest
                        ignore_errors: yes
                        notify: start vsftpd
                  
                    handlers:
                      - name: start vsftpd
                        service: name=vsftpd enabled=yes state=started




***important note:***to cut and paste lines in vim use d in scape mode to cut and use p to paste it in place in escape mode . to cut 3 line use 3d to cute 5 line use 5d. to cut entire file use a big number for example 50d to cut all . use u to undo. in visual mode you can use curser and arrow down to select. y copy d cut p paste in v mode.




ignore_errors: yes   - to ignore error in task to prevent break ansible play commmand.


list of ansible built in module:

https://github.com/ansible/ansible/tree/devel/lib/ansible/modules


we can write extra module in python for ansible also we van download third party module for ansible galaxy:


https://galaxy.ansible.com/


for example search amazon or kubernetes and add it to use its command in ansible playbook. find specified module copy that command in your shell and paste it to use it directly in ansible:

ansible-galaxy collection install amazon.aws   - it is official and has gran tick then it is better one to run.

for example mysql has 7 main module istall it on your system and you can direct query to mysql from ansible.

ansible-galaxy collection install community.mysql


kubernetes module in find filter by collection and download count to see official result:

[https://galaxy.ansible.com/community/kubernetes
](https://galaxy.ansible.com/kubernetes/core)



ansible-galaxy collection install kubernetes.core

use content to see its object and man file.

or install docker module to run docker compose directly with docker-compose file in server to run it. no need to write yml file for it.



famous catagory module example:


Categories	Module Categories
System	User	Group	Iptables	Mount	Ping	Systemd	Service	Hostname
Commands	Command	Expect	Raw	Script	Shell			
Files	Acl	Archive	Find	Copy	Replace	Stat	File	Unarchive
Database	MySQL	MongoDB	MSSQL	PostgreSQL	ProxySQL	Vertica		
Cloud	Amazon	Azure	Google	Linode	OpenStack	VMware	Docker	Atomic
Windows	Win_copy	Win_command	Win_msi	Win_ping	Win_msq	Win_shell	Win_path	Win_service



# lineinfile module

attach new line in a file. also need to grep some exp and replace it in a file. we can use it instead sed command in ansible. here backup: yes means ansible take backup file with all time and permission with name that file + random number + dtae time+~ that no other app can not read this file. and then change the main file.

                  #Sample Ansible lineinfile-module.yaml
                  
                    name: Add DNS server
                    hosts: localhost
                    tasks:
                      -  name: Add DNS server to resolv.conf
                         lineinfile:
                           path: /etc/resolv.conf
                           line: 'nameserver 8.8.8.8'
                           
         
         


ansible-playbook playbook4.yml -K    - to run it.




read :

ansible-doc lineinfile




- line
        The line to insert/replace into the file.
        Required for `state=present'.
        If `backrefs' is set, may contain backreferences that will get expanded with the `regexp' capture groups if the
        regexp matches.
        (Aliases: value)[Default: (null)]
        type: str

- mode
        The permissions the resulting file or directory should have.
        For those used to `/usr/bin/chmod' remember that modes are actually octal numbers. You must either add a leading
        zero so that Ansible's YAML parser knows it is an octal number (like `0644' or `01777') or quote it (like `'644'' or
        `'1777'') so Ansible receives a string and can do its own conversion from string into number.
        Giving Ansible a number without following one of these rules will end up with a decimal number which will have
        unexpected results.
        As of Ansible 1.8, the mode may be specified as a symbolic mode (for example, `u+rwx' or `u=rw,g=r,o=r').
        [Default: (null)]
        type: raw

- others
        All arguments accepted by the [ansible.builtin.file] module also work here.
        [Default: (null)]
        type: str

- owner
        Name of the user that should own the file/directory, as would be fed to `chown'.
        [Default: (null)]
        type: str

= path
        The file to modify.
        Before Ansible 2.3 this option was only usable as `dest', `destfile' and `name'.
        (Aliases: dest, destfile, name)
        type: path

- regexp


to grep specified text find. sample option is to use : 

- firstmatch or insert after or insert before.


- and regexp use to grep.


sample delete specified line:

                  - name: playbook4
                    hosts: all
                    become: yes
                    tasks:
                      - name: delete a spec line
                        lineinfile:
                            path: /etc/resolv.conf
                            regex: 'nameserver 9.9.9.9'
                            backup: yes
                            state: absent  #default if not write is present and add to file




ansible-playbook playbook4.yml -K

to replace a line:

                  - name: playbook4
                    hosts: all
                    become: yes
                    tasks:
                      - name: delete a spec line and replace
                        replace:
                            path: /etc/resolv.conf
                            regex: 'nameserver 9.9.9.9'
                            backup: yes
                            replace: 'nameserver 9.9.1.1'
  


ansible-playbook playbook4.yml -K



# mail module:

send mail from mail server to out.first run a mail server in your server or use external mail server. use for notify in ansible play book as end task to ensure all play are execute succefully or use it with condition if a tsk run succefully or not. and...




                  name: sending mail 
                    hosts: localhost
                    tasks:
                      - name: sending mail to root
                        mail:
                           subject: 'System has been successfully configured’
                           delegate_to: localhost
                         
                      - name: Sending an e-mail using Gmail SMTP servers
                        mail:
                          host: smtp.gmail.com
                          port: 587
                          username: ansible@sematec.com
                          password: mysecret
                          to: John Smith <john.smith@example.com>
                          subject: Ansible-report
                          body: 'System has been successfully provisioned.'
                        delegate_to: localhost

ansible-playbook mail-module.yaml


                  
                  - name: mail playbook
                    hosts: ubuntu3
                  
                    tasks:
                      - name: install mailutils
                        become: yes
                        apt:
                          name: mailutils
                          update_cache: yes
                          state: present
                  
                      - name: mail to root
                        mail:
                          to: root
                          subject: "Sending mail to root user"
                          body: "This is a test message"
                        delegate_to: 192.168.1.130



      


# Ansible FIREWALL Module Example:




                  name: Set Firewall Configurations
                    hosts: centos
                    become: yes
                    tasks:
                      -  firewalld:
                           service: https
                           permanent: true
                           state: enabled
                      
                      -  firewalld:
                           port: 8080/tcp
                           permanent: true
                           state: disabled
                                    
                      -  firewalld:
                           source: 192.168.100.0/24
                           zone: internal
                           state: enabled 
         
         

ansible-playbook firewall-module.yaml


# variable in ansible

Variables can be defined in three below scopes:

1- Global Scope: Variables set from the Command-Line or Ansible Configuration. write in inventory but not in front of hosts . vaes write in rest of inventoy.

2- Play Scope: Variables set in the Play & relates structures. best practice play scope with file vars.

3- Host Scope: Variables set on Host Groups & Individual Hosts by inventory.


we can call variables by {{ var }} .

we can define multiple var in  vi /etc/ansible/hosts - one time for ever. that is called host level variable.


sample  for host level:


 vi /etc/ansible/hosts

zizi51 ansible_host=192.168.44.151
zizi ansible_host=192.168.44.136 ansible_user=ansible http_port=80 myname=arash
zizi50 ansible_host=192.168.44.150 ansible_ssh_pass=123 ansible_sudo_pass=123


and in playbook call with:

    -  firewalld:
         port: "{{ http_port }}/tcp"
         permanent: true
         state: disabled
         
         
  
sample for play scope level:

  name: Set Firewall Configurations
  hosts: centos
  become: true
  vars:
    http_port: 8080
    snmp_port: 161-162
    internal_ip_range: 192.168.100.0
  tasks:
    -  firewalld:
         service: https
         permanent: true






#test for apt module
- name: test-apt
  hosts: all
  become: true

  vars:
    app_name: "vsftpd"

  handlers:
    - name: start vsftpd
      service: name=vsftpd enabled=yes state=started

  tasks:
    - name: install {{ app_name }}
      apt:
         name: {{ app_name }}
         state: latest
         update_cache: yes
      ignore_errors: yes
      notify: start vsftpd




or we can ser vars in file and call that file in var section in playbook.

vi vars_file.yaml
http_port: 8080
snmp_port: 161-162
internal_ip_range: 192.168.100.0



vi firewall-playbook.yaml

  name: Set Firewall Configurations
  hosts: centos
  become: true
  vars_files:
    - vars.yaml
  tasks:
    -  firewalld:
         service: https
         permanent: true



sample for global level:


in file  vi /etc/ansible/hosts

                  zizi51 ansible_host=192.168.44.151
                  zizi ansible_host=192.168.44.136 ansible_user=ansible http_port=80 myname=arash
                  zizi50 ansible_host=192.168.44.150 ansible_ssh_pass=123 ansible_sudo_pass=123
                  app_name=vsftpd
                  http_port=80 
                  myname=arash





### filter facts:


ansible zizi -m setup


to filetr for ex. os family do:

ansible all -m setup -a "filter=*family"


### debug

debug message is for print output . debug : msg=... ==is same as echo. we can write a meesage end of playbook to see if entire of playbook runs successfully. have many arguments like: msg - var - register,...


- name: pingplaybook
  hosts: all
  tasks:
    - ping:

    - name: printing masseg
      debug:
         msg: "helow from zizi51"


- hosts: ubuntu2

  tasks:
  - debug:
      var: ansible_facts  -->Or can filter like Var: ansible_facts[“cmdline”]









## register

is multiple line variable. out put of relaed command is set in register. then we can call it later by register name in for ex. debug messeage.




note : 

to use content to file use | to use all below content as content message for that file. ex.:

                  copy:
                     content: |
                         hi from zizi51
                         today is suny day
                         my name is chatgpb
                     dest: /tmp/tst.txt
                         

       


- hosts: centos
  vars:
    - var_thing: "eldorado"

  tasks:
    - name: say something
      command: echo -e "{{ var_thing }}!\n Do you believe {{ var_thing }} exist?!\nI like to know about {{ var_thing }}"
      register: results1

    - name: show results
      debug: msg={{ results1 }}



you can Filter stdout_lines: debug: msg={{ results1.stdout_lines }}  - note that mesg= not msg:



another example you can use kubeadm init for command that save stdout to exract jion token and commadn from it. 5 task use lineinfile and regex too. redirection works just with shell command . also swapp off ,.. . use lineinfile and replace instead of sed. do backup yes for your tasks. curl==get-url


echo -e "hi\nto you\nbye"  - write in multiple line

in out put of ansible playbook message we see:

stderr_lines: use to see error lines   - useful

stdout_lines: to see output line and its usefull


all indentation got by dot. for ex.:

{{ result1.stdout_lines }}

# condition in ansible:







      










