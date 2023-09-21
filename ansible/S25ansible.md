

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



# lininfile module




















