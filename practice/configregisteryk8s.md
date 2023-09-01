this file is about change config file of k8s to change dockerhyb repo for docker.ir



Using a private registry
Private registries may require keys to read images from them.
Credentials can be provided in several ways:

Configuring Nodes to Authenticate to a Private Registry
all pods can read any configured private registries
requires node configuration by cluster administrator
Kubelet Credential Provider to dynamically fetch credentials for private registries
kubelet can be configured to use credential provider exec plugin for the respective private registry.
Pre-pulled Images
all pods can use any images cached on a node
requires root access to all nodes to set up
Specifying ImagePullSecrets on a Pod
only pods which provide own keys can access the private registry
Vendor-specific or local extensions
if you're using a custom node configuration, you (or your cloud provider) can implement your mechanism for authenticating the node to the container registry.
These options are explained in more detail below.

Configuring nodes to authenticate to a private registry
Specific instructions for setting credentials depends on the container runtime and registry you chose to use. You should refer to your solution's documentation for the most accurate information.

For an example of configuring a private container image registry, see the Pull an Image from a Private Registry task. That example uses a private registry in Docker Hub.

Kubelet credential provider for authenticated image pulls
Note: This approach is especially suitable when kubelet needs to fetch registry credentials dynamically. Most commonly used for registries provided by cloud providers where auth tokens are short-lived.
You can configure the kubelet to invoke a plugin binary to dynamically fetch registry credentials for a container image. This is the most robust and versatile way to fetch credentials for private registries, but also requires kubelet-level configuration to enable.

See Configure a kubelet image credential provider for more details.

Interpretation of config.json
The interpretation of config.json varies between the original Docker implementation and the Kubernetes interpretation. In Docker, the auths keys can only specify root URLs, whereas Kubernetes allows glob URLs as well as prefix-matched paths. This means that a config.json like this is valid:

{
    "auths": {
        "*my-registry.io/images": {
            "auth": "…"
        }
    }
}
The root URL (*my-registry.io) is matched by using the following syntax:

pattern:
    { term }

term:
    '*'         matches any sequence of non-Separator characters
    '?'         matches any single non-Separator character
    '[' [ '^' ] { character-range } ']'
                character class (must be non-empty)
    c           matches character c (c != '*', '?', '\\', '[')
    '\\' c      matches character c

character-range:
    c           matches character c (c != '\\', '-', ']')
    '\\' c      matches character c
    lo '-' hi   matches character c for lo <= c <= hi
Image pull operations would now pass the credentials to the CRI container runtime for every valid pattern. For example the following container image names would match successfully:

my-registry.io/images
my-registry.io/images/my-image
my-registry.io/images/another-image
sub.my-registry.io/images/my-image
a.sub.my-registry.io/images/my-image
The kubelet performs image pulls sequentially for every found credential. This means, that multiple entries in config.json are possible, too:

{
    "auths": {
        "my-registry.io/images": {
            "auth": "…"
        },
        "my-registry.io/images/subpath": {
            "auth": "…"
        }
    }
}
If now a container specifies an image my-registry.io/images/subpath/my-image to be pulled, then the kubelet will try to download them from both authentication sources if one of them fails.

Pre-pulled images
Note: This approach is suitable if you can control node configuration. It will not work reliably if your cloud provider manages nodes and replaces them automatically.
By default, the kubelet tries to pull each image from the specified registry. However, if the imagePullPolicy property of the container is set to IfNotPresent or Never, then a local image is used (preferentially or exclusively, respectively).

If you want to rely on pre-pulled images as a substitute for registry authentication, you must ensure all nodes in the cluster have the same pre-pulled images.

This can be used to preload certain images for speed or as an alternative to authenticating to a private registry.

All pods will have read access to any pre-pulled images.

Specifying imagePullSecrets on a Pod
Note: This is the recommended approach to run containers based on images in private registries.
Kubernetes supports specifying container image registry keys on a Pod. imagePullSecrets must all be in the same namespace as the Pod. The referenced Secrets must be of type kubernetes.io/dockercfg or kubernetes.io/dockerconfigjson.

Creating a Secret with a Docker config
You need to know the username, registry password and client email address for authenticating to the registry, as well as its hostname. Run the following command, substituting the appropriate uppercase values:

kubectl create secret docker-registry <name> \
  --docker-server=DOCKER_REGISTRY_SERVER \
  --docker-username=DOCKER_USER \
  --docker-password=DOCKER_PASSWORD \
  --docker-email=DOCKER_EMAIL
If you already have a Docker credentials file then, rather than using the above command, you can import the credentials file as a Kubernetes Secrets.
Create a Secret based on existing Docker credentials explains how to set this up.

This is particularly useful if you are using multiple private container registries, as kubectl create secret docker-registry creates a Secret that only works with a single private registry.

Note: Pods can only reference image pull secrets in their own namespace, so this process needs to be done one time per namespace.
Referring to an imagePullSecrets on a Pod
Now, you can create pods which reference that secret by adding an imagePullSecrets section to a Pod definition. Each item in the imagePullSecrets array can only reference a Secret in the same namespace.

For example:

cat <<EOF > pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: foo
  namespace: awesomeapps
spec:
  containers:
    - name: foo
      image: janedoe/awesomeapp:v1
  imagePullSecrets:
    - name: myregistrykey
EOF

cat <<EOF >> ./kustomization.yaml
resources:
- pod.yaml
EOF
This needs to be done for each pod that is using a private registry.

However, setting of this field can be automated by setting the imagePullSecrets in a ServiceAccount resource.

Check Add ImagePullSecrets to a Service Account for detailed instructions.

You can use this in conjunction with a per-node .docker/config.json. The credentials will be merged.

Use cases
There are a number of solutions for configuring private registries. Here are some common use cases and suggested solutions.

Cluster running only non-proprietary (e.g. open-source) images. No need to hide images.
Use public images from a public registry
No configuration required.
Some cloud providers automatically cache or mirror public images, which improves availability and reduces the time to pull images.
Cluster running some proprietary images which should be hidden to those outside the company, but visible to all cluster users.
Use a hosted private registry
Manual configuration may be required on the nodes that need to access to private registry
Or, run an internal private registry behind your firewall with open read access.
No Kubernetes configuration is required.
Use a hosted container image registry service that controls image access
It will work better with cluster autoscaling than manual node configuration.
Or, on a cluster where changing the node configuration is inconvenient, use imagePullSecrets.
Cluster with proprietary images, a few of which require stricter access control.
Ensure AlwaysPullImages admission controller is active. Otherwise, all Pods potentially have access to all images.
Move sensitive data into a "Secret" resource, instead of packaging it in an image.
A multi-tenant cluster where each tenant needs own private registry.
Ensure AlwaysPullImages admission controller is active. Otherwise, all Pods of all tenants potentially have access to all images.
Run a private registry with authorization required.
Generate registry credential for each tenant, put into secret, and populate secret to each tenant namespace.
The tenant adds that secret to imagePullSecrets of each namespace.
If you need access to multiple registries, you can create one secret for each registry.



Legacy built-in kubelet credential provider
In older versions of Kubernetes, the kubelet had a direct integration with cloud provider credentials. This gave it the ability to dynamically fetch credentials for image registries.

There were three built-in implementations of the kubelet credential provider integration: ACR (Azure Container Registry), ECR (Elastic Container Registry), and GCR (Google Container Registry).

For more information on the legacy mechanism, read the documentation for the version of Kubernetes that you are using. Kubernetes v1.26 through to v1.28 do not include the legacy mechanism, so you would need to either:

configure a kubelet image credential provider on each node
specify image pull credentials using imagePullSecrets and at least one Secret




Pull an Image from a Private Registry
This page shows how to create a Pod that uses a Secret to pull an image from a private container image registry or repository. There are many private registries in use. This task uses Docker Hub as an example registry.

🛇 This item links to a third party project or product that is not part of Kubernetes itself. More information
Before you begin
You need to have a Kubernetes cluster, and the kubectl command-line tool must be configured to communicate with your cluster. It is recommended to run this tutorial on a cluster with at least two nodes that are not acting as control plane hosts. If you do not already have a cluster, you can create one by using minikube or you can use one of these Kubernetes playgrounds:

Killercoda
Play with Kubernetes
To do this exercise, you need the docker command line tool, and a Docker ID for which you know the password.

If you are using a different private container registry, you need the command line tool for that registry and any login information for the registry.

Log in to Docker Hub
On your laptop, you must authenticate with a registry in order to pull a private image.

Use the docker tool to log in to Docker Hub. See the log in section of Docker ID accounts for more information.

docker login
When prompted, enter your Docker ID, and then the credential you want to use (access token, or the password for your Docker ID).

The login process creates or updates a config.json file that holds an authorization token. Review how Kubernetes interprets this file.

View the config.json file:

cat ~/.docker/config.json
The output contains a section similar to this:

{
    "auths": {
        "https://index.docker.io/v1/": {
            "auth": "c3R...zE2"
        }
    }
}
Note: If you use a Docker credentials store, you won't see that auth entry but a credsStore entry with the name of the store as value. In that case, you can create a secret directly. See Create a Secret by providing credentials on the command line.
Create a Secret based on existing credentials
A Kubernetes cluster uses the Secret of kubernetes.io/dockerconfigjson type to authenticate with a container registry to pull a private image.

If you already ran docker login, you can copy that credential into Kubernetes:

kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=<path/to/.docker/config.json> \
    --type=kubernetes.io/dockerconfigjson
If you need more control (for example, to set a namespace or a label on the new secret) then you can customise the Secret before storing it. Be sure to:

set the name of the data item to .dockerconfigjson
base64 encode the Docker configuration file and then paste that string, unbroken as the value for field data[".dockerconfigjson"]
set type to kubernetes.io/dockerconfigjson
Example:

apiVersion: v1
kind: Secret
metadata:
  name: myregistrykey
  namespace: awesomeapps
data:
  .dockerconfigjson: UmVhbGx5IHJlYWxseSByZWVlZWVlZWVlZWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGx5eXl5eXl5eXl5eXl5eXl5eXl5eSBsbGxsbGxsbGxsbGxsbG9vb29vb29vb29vb29vb29vb29vb29vb29vb25ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubmdnZ2dnZ2dnZ2dnZ2dnZ2dnZ2cgYXV0aCBrZXlzCg==
type: kubernetes.io/dockerconfigjson
If you get the error message error: no objects passed to create, it may mean the base64 encoded string is invalid. If you get an error message like Secret "myregistrykey" is invalid: data[.dockerconfigjson]: invalid value ..., it means the base64 encoded string in the data was successfully decoded, but could not be parsed as a .docker/config.json file.

Create a Secret by providing credentials on the command line
Create this Secret, naming it regcred:

kubectl create secret docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
where:

<your-registry-server> is your Private Docker Registry FQDN. Use https://index.docker.io/v1/ for DockerHub.
<your-name> is your Docker username.
<your-pword> is your Docker password.
<your-email> is your Docker email.
You have successfully set your Docker credentials in the cluster as a Secret called regcred.

Note: Typing secrets on the command line may store them in your shell history unprotected, and those secrets might also be visible to other users on your PC during the time that kubectl is running.
Inspecting the Secret regcred
To understand the contents of the regcred Secret you created, start by viewing the Secret in YAML format:

kubectl get secret regcred --output=yaml
The output is similar to this:

apiVersion: v1
kind: Secret
metadata:
  ...
  name: regcred
  ...
data:
  .dockerconfigjson: eyJodHRwczovL2luZGV4L ... J0QUl6RTIifX0=
type: kubernetes.io/dockerconfigjson
The value of the .dockerconfigjson field is a base64 representation of your Docker credentials.

To understand what is in the .dockerconfigjson field, convert the secret data to a readable format:

kubectl get secret regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode
The output is similar to this:

{"auths":{"your.private.registry.example.com":{"username":"janedoe","password":"xxxxxxxxxxx","email":"jdoe@example.com","auth":"c3R...zE2"}}}
To understand what is in the auth field, convert the base64-encoded data to a readable format:

echo "c3R...zE2" | base64 --decode
The output, username and password concatenated with a :, is similar to this:

janedoe:xxxxxxxxxxx
Notice that the Secret data contains the authorization token similar to your local ~/.docker/config.json file.

You have successfully set your Docker credentials as a Secret called regcred in the cluster.

Create a Pod that uses your Secret
Here is a manifest for an example Pod that needs access to your Docker credentials in regcred:

pods/private-reg-pod.yaml Copy pods/private-reg-pod.yaml to clipboard
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

Download the above file onto your computer:

curl -L -o my-private-reg-pod.yaml https://k8s.io/examples/pods/private-reg-pod.yaml
In file my-private-reg-pod.yaml, replace <your-private-image> with the path to an image in a private registry such as:

your.private.registry.example.com/janedoe/jdoe-private:v1
To pull the image from the private registry, Kubernetes needs credentials. The imagePullSecrets field in the configuration file specifies that Kubernetes should get the credentials from a Secret named regcred.

Create a Pod that uses your Secret, and verify that the Pod is running:

kubectl apply -f my-private-reg-pod.yaml
kubectl get pod private-reg
Note:
In case the Pod fails to start with the status ImagePullBackOff, view the Pod events:

kubectl describe pod private-reg
If you then see an event with the reason set to FailedToRetrieveImagePullSecret, Kubernetes can't find a Secret with name (regcred, in this example). If you specify that a Pod needs image pull credentials, the kubelet checks that it can access that Secret before attempting to pull the image.

Make sure that the Secret you have specified exists, and that its name is spelled properly.

Events:
  ...  Reason                           ...  Message
       ------                                -------
  ...  FailedToRetrieveImagePullSecret  ...  Unable to retrieve some image pull secrets (<reg




