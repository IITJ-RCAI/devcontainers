read -p "Enter devcontainer name: " name
if [ -z "$name" ]
then 
    echo 'Name cannot be blank please try again!' 
    exit 0 
fi
name=${name,,}

read -p "Enter devcontainer token/password [<generated>]: " TOKEN
if [ -z "$TOKEN" ]
then 
    TOKEN="<generated>"
fi

read -p "Enter number of GPUs (0/1/2)[0]: " gpus
gpus=${gpus:-0}
if ! [[ "$gpus" =~ ^[0-2]$ ]]
then 
    echo 'Only one of 0/1/2 allowed.' 
    exit 0 
fi 

mkdir -p $HOME/.devcontainer/${name}

cat <<EOF >$HOME/.devcontainer/${name}/kubectl.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: devcontainer-tls
data:
  # the data is abbreviated in this example
  cert.crt: |
        -----BEGIN CERTIFICATE-----
        MIIJWjCCCEKgAwIBAgIURCkVy6BLKdmWlW/OjQQSzZfo23kwDQYJKoZIhvcNAQEL
        BQAwRDELMAkGA1UEBhMCSU4xEjAQBgNVBAgMCU5ldyBEZWxoaTESMBAGA1UEBwwJ
        TmV3IERlbGhpMQ0wCwYDVQQKDARSQ0FJMB4XDTIxMDcyMDEzNDY0MFoXDTIzMTAy
        MzEzNDY0MFowRDELMAkGA1UEBhMCSU4xEjAQBgNVBAgMCU5ldyBEZWxoaTESMBAG
        A1UEBwwJTmV3IERlbGhpMQ0wCwYDVQQKDARSQ0FJMIIBIjANBgkqhkiG9w0BAQEF
        AAOCAQ8AMIIBCgKCAQEAr0v4+ZkdxSbtmGChWiES4rJowTlKG+goQbFRrcsyqcTB
        6ADFHOO0B364LaYvS24wSeE0tFWdy1zoAn8k63gqvKAlGa5/bSPq2e1E0v0gG2i+
        Pm7Sp4Xc3lMuSSsSU/1PxuJ6CAd2/LE0purIaooKUrxPWoPgrs2NcmH2w2qsDQ2E
        Q5OT3cwU6cKVVJqzg8pay+cOWuXRO87R5llXccXW5A/zRWIrn6WRmiULRB1iHen4
        iMsTeE9w7rD47Hc07f7wRSkd6BGV0GhavXWlimT+H/MMAPW8ptrRItSzs+Yi35+p
        2X4ECht9CwSP8pELt8zv+ExUwOgpLAddO1AxFCtnoQIDAQABo4IGQjCCBj4wHwYD
        VR0jBBgwFoAUaXpD7v8RTgjA+eMvaGswr82At8YwCQYDVR0TBAIwADALBgNVHQ8E
        BAMCBPAwggYBBgNVHREEggX4MIIF9IcECiAAAYcECiAAAocECiAAA4cECiAABIcE
        CiAABYcECiAABocECiAAB4cECiAACIcECiAACYcECiAACocECiAAC4cECiAADIcE
        CiAADYcECiAADocECiAAD4cECiAAEIcECiAAEYcECiAAEocECiAAE4cECiAAFIcE
        CiAAFYcECiAAFocECiAAF4cECiAAGIcECiAAGYcECiAAGocECiAAG4cECiAAHIcE
        CiAAHYcECiAAHocECiAAH4cECiAAIIcECiAAIYcECiAAIocECiAAI4cECiAAJIcE
        CiAAJYcECiAAJocECiAAJ4cECiAAKIcECiAAKYcECiAAKocECiAAK4cECiAALIcE
        CiAALYcECiAALocECiAAL4cECiAAMIcECiAAMYcECiAAMocECiAAM4cECiAANIcE
        CiAANYcECiAANocECiAAN4cECiAAOIcECiAAOYcECiAAOocECiAAO4cECiAAPIcE
        CiAAPYcECiAAPocECiAAP4cECiAAQIcECiAAQYcECiAAQocECiAAQ4cECiAARIcE
        CiAARYcECiAARocECiAAR4cECiAASIcECiAASYcECiAASocECiAAS4cECiAATIcE
        CiAATYcECiAATocECiAAT4cECiAAUIcECiAAUYcECiAAUocECiAAU4cECiAAVIcE
        CiAAVYcECiAAVocECiAAV4cECiAAWIcECiAAWYcECiAAWocECiAAW4cECiAAXIcE
        CiAAXYcECiAAXocECiAAX4cECiAAYIcECiAAYYcECiAAYocECiAAY4cECiAAZIcE
        CiAAZYcECiAAZocECiAAZ4cECiAAaIcECiAAaYcECiAAaocECiAAa4cECiAAbIcE
        CiAAbYcECiAAbocECiAAb4cECiAAcIcECiAAcYcECiAAcocECiAAc4cECiAAdIcE
        CiAAdYcECiAAdocECiAAd4cECiAAeIcECiAAeYcECiAAeocECiAAe4cECiAAfIcE
        CiAAfYcECiAAfocECiAAf4cECiAAgIcECiAAgYcECiAAgocECiAAg4cECiAAhIcE
        CiAAhYcECiAAhocECiAAh4cECiAAiIcECiAAiYcECiAAiocECiAAi4cECiAAjIcE
        CiAAjYcECiAAjocECiAAj4cECiAAkIcECiAAkYcECiAAkocECiAAk4cECiAAlIcE
        CiAAlYcECiAAlocECiAAl4cECiAAmIcECiAAmYcECiAAmocECiAAm4cECiAAnIcE
        CiAAnYcECiAAnocECiAAn4cECiAAoIcECiAAoYcECiAAoocECiAAo4cECiAApIcE
        CiAApYcECiAApocECiAAp4cECiAAqIcECiAAqYcECiAAqocECiAAq4cECiAArIcE
        CiAArYcECiAArocECiAAr4cECiAAsIcECiAAsYcECiAAsocECiAAs4cECiAAtIcE
        CiAAtYcECiAAtocECiAAt4cECiAAuIcECiAAuYcECiAAuocECiAAu4cECiAAvIcE
        CiAAvYcECiAAvocECiAAv4cECiAAwIcECiAAwYcECiAAwocECiAAw4cECiAAxIcE
        CiAAxYcECiAAxocECiAAx4cECiAAyIcECiAAyYcECiAAyocECiAAy4cECiAAzIcE
        CiAAzYcECiAAzocECiAAz4cECiAA0IcECiAA0YcECiAA0ocECiAA04cECiAA1IcE
        CiAA1YcECiAA1ocECiAA14cECiAA2IcECiAA2YcECiAA2ocECiAA24cECiAA3IcE
        CiAA3YcECiAA3ocECiAA34cECiAA4IcECiAA4YcECiAA4ocECiAA44cECiAA5IcE
        CiAA5YcECiAA5ocECiAA54cECiAA6IcECiAA6YcECiAA6ocECiAA64cECiAA7IcE
        CiAA7YcECiAA7ocECiAA74cECiAA8IcECiAA8YcECiAA8ocECiAA84cECiAA9IcE
        CiAA9YcECiAA9ocECiAA94cECiAA+IcECiAA+YcECiAA+ocECiAA+4cECiAA/IcE
        CiAA/YcECiAA/jANBgkqhkiG9w0BAQsFAAOCAQEAaXn9iGMAqqGFRV1RgE7OzphN
        JsKFBBaOoC2gTINSxfqtXf1/GCqXUfeNfY+4B4xsVuSVPnGKMJxwAu4/Lm2Plbxc
        ic2pTHPsNX7SnUPtOej5mNHpsWyhG2HKnVXMQOZlx6NOP4hUgP5eZtCkO8Zi3ldn
        jMrxGmucfUnr6FUZXWsm0gBYeg2sy6pSKU0dsp3ly4+c3hquv27f0RQ++K73+jvZ
        GyoEFgD9ddxUrmsobDuYb9beBtiUeeIc7WsDA/ynst3N84Lz28KISGz5Ufba1YpN
        ZNHibaf7fZaWZNheHCwIwzCu+OTDWzVqTFeyUrVhplK5wMFM77BPJodPh5RSMg==
        -----END CERTIFICATE-----
  cert.key: |
        -----BEGIN RSA PRIVATE KEY-----
        MIIEowIBAAKCAQEAr0v4+ZkdxSbtmGChWiES4rJowTlKG+goQbFRrcsyqcTB6ADF
        HOO0B364LaYvS24wSeE0tFWdy1zoAn8k63gqvKAlGa5/bSPq2e1E0v0gG2i+Pm7S
        p4Xc3lMuSSsSU/1PxuJ6CAd2/LE0purIaooKUrxPWoPgrs2NcmH2w2qsDQ2EQ5OT
        3cwU6cKVVJqzg8pay+cOWuXRO87R5llXccXW5A/zRWIrn6WRmiULRB1iHen4iMsT
        eE9w7rD47Hc07f7wRSkd6BGV0GhavXWlimT+H/MMAPW8ptrRItSzs+Yi35+p2X4E
        Cht9CwSP8pELt8zv+ExUwOgpLAddO1AxFCtnoQIDAQABAoIBAHxH4L0VUYX1k331
        BHBiAoG2+44CkAg5EFGC5eXRqpmyZceWxCk3RuwJa4rxx5YzCQlYIYW5LaaAt/0N
        J5/KEoKpB6StkqpOTLM1BRaRX7IPENIywCcFQRJe5vH5F4V0kpru9pW6tSFygWHW
        E0F1nNwLpjcGSMWl9iKiUdE6T8DwJ05cSoNd6QKqhSQOOCrMZd2cD84lc0+MEdAe
        0UFJGS19fPXx91/aJawOswgD2X+tlBbs/9CTzkThSD2ZFSCgzSB7iqViMIz66AKU
        7Yf5BD64ATFqDE20KezVRl462DA+SBs+w9ZBYR6moZkHUxCgaqqeSLPJjeQiVV53
        JerNIAECgYEA4jVaB8fvk1OI9uU8j2rD21H/Em0xnAcGDmMxxXmyNavJoX3W5f3l
        XYIzFuhaA5bI1lGFYdURLxLJAskHE6RKexdOHCxcX7tWc5C1LLvElQSs4eVMOWxH
        PIuob+vlrJveeOXpeUlpI7NDYv8TNPLVwWza8LRM29M5XAtnWkMsZzkCgYEAxmIg
        uhqTRRwcqUktrU3kjg3+p2ulvhUNVxqDERZBrUK6cv6ld/U5eSwbvqKwfvL9w1ZL
        6mwgd6xktzPT0UdKxeveS5n2UxbyOmgCJW4mVnafYIkWe96KdWDf0T/iitToufqY
        P+HQXnSgYX4yfRKcO4feERWskjVG/POLBNJ6W6kCgYAyF+B9EqCSPpB5JGCZ3enL
        esgCm5290KxdqUfPVFjLm+RF1+kr+2K8p2WK8B9m5hBJrbnc5WMtynorHLttdRdt
        VMbeZFB8fq7xXp1Qb7Bj06o5SB7uJHVOChtd1Z6B7+5/VWKzkjcvSbZliNkHA7Ok
        ZufBIBxZHdh48qmLio6duQKBgAxR78JfACJcmpMQzlti6PzBdb0j/EkPuaJdLSKU
        hUOjTzzw/4mxmv4hdR+jrt5TbNsCsvg9+s4z0JVoDJGEoeokuctsJlYGqMhjyS5V
        5t+bwk4WdWT/7w1XFM9D7me8zS8vluDwvyX+jC9BzRTjYPx5dZsOA4eY822mGk4U
        XDDxAoGBAKmJsKAuWR18RRlfogsQpSAGHBEME0pSfq7bJ34DqqZRVrQ4N6PEv4Is
        rBL3bu+2usw5RBgXE+0QgDIjcu12Qtqnol3YtPNGC1Nhe2FuOlrhqgr33CTuWHM8
        Cd0wsiltEFBb8L88nfYoTMFGQT4OIi7r4nq2NmH8qD/zh8k1G7D9
        -----END RSA PRIVATE KEY-----
---
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
          - name: WORKSPACE_SSL_ENABLED
            value: "true"
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
        # Shared memory hack
        # https://stackoverflow.com/a/46434614/10027894
        - mountPath: /dev/shm
          name: dshm
        # TLS keys mount
        - name: tls
          mountPath: "/resources/ssl"
          readOnly: true
      volumes:
      # TLS keys
      - name: tls
        configMap:
          name: devcontainer-tls
          # An array of keys from the ConfigMap to create as files
          items:
          - key: "cert.crt"
            path: "cert.crt"
          - key: "cert.key"
            path: "cert.key"
      # Shared memory hack
      # https://stackoverflow.com/a/46434614/10027894
      # https://github.com/kubernetes/kubernetes/pull/63641
      - name: dshm
        emptyDir:
          sizeLimit: "350Mi"
          medium: Memory
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

while [ $TOKEN = "<generated>" ]
do
  echo "Waiting for pod to start..."
  sleep 5
  TOKEN=$(kubectl logs $POD_NAME | sed -nE 's/ *http:\/\/localhost:80.0\/\?token=//p')
  TOKEN=${${TOKEN##+( )}%%+( )}
done

echo "Devcontainer running in pod '$POD_NAME' at ip: $POD_IP"
echo "Connect at: https://${POD_IP}:8080/?token=$TOKEN"
