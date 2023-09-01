

# Kubernetes: Pull an Image from a Private Registry using Yaml and Helm File
to do this change we have 3 options:

## Method 1 – Change docker config default registry (depracted due to k8s 1.27 use containerd instead of docker)

To change the default registry for Docker to a private registry that requires authentication, you can follow these steps:

Create or edit the /etc/docker/daemon.json file on your Docker host machine.
Add the following lines to the file, replacing your-registry with the URL of your private registry and your-username and your-password with your registry credentials:

            {
              "auths": {
                "your-registry": {
                  "auth": "your-username:your-password"
                }
              },
              "registry-mirrors": ["https://your-registry"]
            }

Note that the auths key is used to specify the credentials for your private registry, and the registry-mirrors key is used to specify the URL of the registry.

Save the file and exit.
Restart the Docker daemon to apply the changes:

            $ sudo systemctl restart docker
            
Verify that the configuration has been applied by running the docker info command. You should see the URL of your registry listed under “Registry Mirrors”.

            $ docker info
            ...
            Registry Mirrors:
              https://your-registry/
            ...

With this configuration, Docker will use your private registry as the default registry for pulling images and will authenticate with your registry credentials.


## Method 2 – Create a Secret based on existing credentials using in Pod Spec


cat ~/.docker/config.json

The output contains a section similar to this:


{
    "auths": {
        "https://index.docker.io/v1/": {
            "auth": "c3R...zE2"
        }
    }
}



***Create a Secret based on existing credentials***


kubectl create secret generic regcred     --from-file=.dockerconfigjson=/root/.docker/config.json     --type=kubernetes.io/dockerconfigjson



***Create a Secret by providing credentials on the command line***

Create this Secret, naming it regcred:

kubectl create secret docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>

where:

**<your-registry-server> is your Private Docker Registry FQDN. Use https://index.docker.io/v1/ for DockerHub.
<your-name> is your Docker username.
<your-pword> is your Docker password.
<your-email> is your Docker email.
You have successfully set your Docker credentials in the cluster as a Secret called regcred.
**


to verigy regcred:


kubectl get secret regcred --output=yaml


kubectl get secret regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode


#### for using it in a pod or object do:

Create a Pod that uses your Secret 

Here is a manifest for an example Pod that needs access to your Docker credentials in regcred:


                                    
                                    apiVersion: v1
                                    kind: Pod
                                    metadata:
                                      name: private-reg
                                    spec:
                                      containers:
                                      - name: private-reg-container
                                        image: <your-private-image>
                                      imagePullSecrets:
                                      - name: regcred
                                    
                                    

kubectl apply -f my-private-reg-pod.yaml


kubectl get pod private-reg


#### to tshoot some error:

In case the Pod fails to start with the status ImagePullBackOff, view the Pod events:


kubectl describe pod private-reg


If you then see an event with the reason set to FailedToRetrieveImagePullSecret, Kubernetes can't find a Secret with name (regcred, in this example). If you specify that a Pod needs image pull credentials, the kubelet checks that it can access that Secret before attempting to pull the image.

Make sure that the Secret you have specified exists, and that its name is spelled properly.


## Method 3 – Create a Secret based on existing credentials using Helm chart

![image](https://github.com/zizitizi/my-devops-Roadmap/assets/123273835/b652d4ea-6849-4a53-bff6-5ab361fbdb97)

            Reference - https://helm.sh/docs/howto/charts_tips_and_tricks/#creating-image-pull-secrets
            
            imageCredentials:
              registry: quay.io
              username: someone
              password: sillyness
              email: someone@host.com
              
            We then define our helper template as follows:
            
            {{- define "imagePullSecret" }}
            {{- with .Values.imageCredentials }}
            {{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
            {{- end }}
            {{- end }}
            
            
            Finally, we use the helper template in a larger template to create the Secret manifest:
            
            apiVersion: v1
            kind: Secret
            metadata:
              name: myregistrykey
            type: kubernetes.io/dockerconfigjson
            data:
              .dockerconfigjson: {{ template "imagePullSecret" . }}

###########################################################################################################################

###########################################################################################################################




            ## Global Docker image parameters
            ## Please, note that this will override the image parameters, including dependencies, configured to use the global value
            ## Current available global Docker image parameters: imageRegistry and imagePullSecrets
            ##
            # global:
            #   imageRegistry: myRegistryName
            #   imagePullSecrets:
            #     - myRegistryKeySecretName
            #   storageClass: myStorageClass
            
            ## Bitnami Ghost image version
            ## ref: https://hub.docker.com/r/bitnami/ghost/tags/
            ##
            image:
              registry: docker.io
              repository: bitnami/ghost
              tag: 3.9.0-debian-10-r0
              ## Specify a imagePullPolicy
              ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
              ## ref: http://kubernetes.io/docs/user-guide/images/#pre-pulling-images
              ##
              pullPolicy: IfNotPresent
              ## Optionally specify an array of imagePullSecrets.
              ## Secrets must be manually created in the namespace.
              ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
              ##
              # pullSecrets:
              #   - myRegistryKeySecretName



https://kubernetes.io/docs/concepts/containers/images/

https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/





