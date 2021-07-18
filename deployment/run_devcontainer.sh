read -p "Enter devcontainer name: " name
if [ -z "$name" ]
then 
    echo 'Name cannot be blank please try again!' 
    exit 0 
fi
name=${name,,}

read -p "Enter devcontainer token/password (lower case)[<generated>]: " token
if [ -z "$token" ]
then 
    token="<generated>"
fi
token=${token,,}

read -p "Enter number of GPUs (0/1/2)[0]: " gpus
gpus=${gpus:-0}
if ! [[ "$gpus" =~ ^[0-2]$ ]]
then 
    echo 'Only one of 0/1/2 allowed.' 
    exit 0 
fi 

mkdir -p $HOME/.devcontainer/${name}

cat <<EOF >$HOME/.devcontainer/${name}/kubectl.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: devcontainer-$name
spec:
  template:
    spec:
      containers:
      - name: $(whoami)-$name
        image: mltooling/ml-workspace-gpu:latest
        # imagePullPolicy: Always
        env:
          - name: SHUTDOWN_INACTIVE_KERNELS
            value: "true"
          - name: AUTHENTICATE_VIA_JUPYTER
            value: "${token}"
#           - name: WORKSPACE_SSL_ENABLED
#             value: "true"
        resources:
          limits:
            nvidia.com/gpu: "$gpus"
        volumeMounts:
        - name: data
          mountPath: /workspace/data
        - name: nfs
          mountPath: /workspace/storage
        - name: home
          mountPath: /home
      volumes:
      - name: data
        hostPath:
          path: /raid/$(whoami)
          type: Directory
      - name: nfs
        hostPath:
          path: /DATA1/$(whoami)
          type: Directory
      - name: home
        hostPath:
          path: /home/$(whoami)
          type: Directory
      restartPolicy: Never
  backoffLimit: 1
EOF

cd $HOME/.devcontainer/${name}
kubectl apply -f kubectl.yaml

# Get pod data
POD_NAME=$(kubectl get pods --selector=job-name=devcontainer-$name --output=jsonpath='{.items[-1].metadata.name}')

POD_PHASE=$(kubectl get pods --selector=job-name=devcontainer-$name --output=jsonpath='{.items[-1].status.phase}')
until [[ $POD_PHASE == Running ]]
do
  echo "Waiting for pod to start..."
  sleep 5
  POD_PHASE=$(kubectl get pods --selector=job-name=devcontainer-$name --output=jsonpath='{.items[-1].status.phase}')
done

POD_IP=$(kubectl get pods --selector=job-name=devcontainer-$name --output=jsonpath='{.items[-1].status.podIP}')

TOKEN=$(kubectl logs $POD_NAME | sed -nE 's/http:\/\/localhost:80.0\/\?token=//p')
while [ -z $TOKEN ]
do
  echo "Waiting for pod to start..."
  sleep 5
  TOKEN=$(kubectl logs $POD_NAME | sed -nE 's/ *http:\/\/localhost:80.0\/\?token=//p')
done
TOKEN=${${TOKEN##+( )}%%+( )}

echo "Devcontainer running in pod '$POD_NAME' at ip: $POD_IP"
echo "Connect at: https://${POD_IP}:8080/?token=$TOKEN"
