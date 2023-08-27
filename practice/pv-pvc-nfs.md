
create folder pvnfs for organising yaml file and share storage directory on server that nfs 

apt install nfs-utils


mkdir pvnfs

# pv yaml file


vi pvnfs.yaml


        apiVersion: v1
        kind: PersistentVolume
        metadata:
          name: pv-nfs
          labels:
            type: nfs
        spec:
           storageClassName: nfs
           capacity:
              storage: 200Mi
           accessModes:
              - ReadWriteMany
           persistentVolumeReclaimPolicy: Recycle
           nfs:
              path: /root/pvnfs/nfspv
              server: 192.168.44.136


mkdir -p /root/pvnfs/nfspv

kubectl apply -f pvnfs.yaml


kubectl get pv -o wide


![image](https://github.com/zizitizi/my-devops-Roadmap/assets/123273835/002740d6-2249-4658-bb97-ece5887423df)



# pvc yaml file


vi pvcnfs.yml

        apiVersion: v1
        kind: PersistentVolumeClaim
        metadata:
          name: pvc-nfs
        spec:
          storageClassName: nfs
          accessModes:
             - ReadWriteMany
          resources:
            requests:
              storage: 10Mi
        

kubectl apply -f pvcnfs.yml

kubectl get pvc -o wide



![image](https://github.com/zizitizi/my-devops-Roadmap/assets/123273835/6d89ed8f-7eb9-4fb2-bbcd-50cbd73dcf45)




enjoy it!







 


