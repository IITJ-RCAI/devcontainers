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
        MIIQizCCDHOgAwIBAgIIG4E17/R0L0swDQYJKoZIhvcNAQENBQAwRzEbMBkGA1UE
        AxMSSmFpZGVlcCBTaW5naCBIZWVyMSgwJgYJKoZIhvcNAQkBFhlqYWlkZWVzaW5n
        aGhlZXJAZ21haWwuY29tMB4XDTIxMTIyNzE1MjgwMFoXDTIyMTIyNzE1MjgwMFow
        FTETMBEGA1UEAxMKZGd4MnNlcnZlcjCCBCIwDQYJKoZIhvcNAQEBBQADggQPADCC
        BAoCggQBAOWreml86GqaMlC/EKXmUetthM7VdKk+oX1PhehfejE7hU8XRCpEtarh
        zInKugBTyu/6ZGJjxQ0bkGlpABa2EnTOO0lN+Gy+MrC9kay5+MNvp1LhrSGF1Rup
        LdVSNaCdDLkJ9j7jyEvj+ttYnKefgO1TFk7te2ylVy8L4aiqDtBLcZC2KFufp9bl
        A74BN8JBdpWpe6+J+BLLBR5k+8seDQ8wc2lqyF5RZ4G56IZQbGnxMbkZiX5EQzya
        zRUiHbpUXawQttJCiUFdLFenxL/kJCstDFKDD8HohiBbzgnvFgmdEASuvgIRzuZ7
        UjJ7OfI//HYIMYPb7kXCacSfEYZ3H4qJG4g8OajdcraMcQyTB+t+DnV3E5Y2YwcI
        q0OL1ZtIUDqSK0+AsCT7Rjod+M0TjXvHC9wEbdAzJ7C1yLsy0GSLnv3LliTp/th7
        9+rYOiDSxkT2uBcKH9iD9DttsNAXW//KjFtCcXjtMke86xakuIL6v6ldqeejamsW
        ih50ZQ8NPNWXch66h6ULmqOwrqXiHMMk1YGSjgjRcmIAbB1ipoXBxK2fN8yfyKP4
        SgR13IVbR8qhaLxPLlChHGmJ6fRvoQydQ/GXjoThJMw6MRVx92qSURm0QlTeY7ik
        8/q/RCMxrwXhnmbT03H0Q5knLHQiQAlMjF5wTAIdjscyfuzkK9/2/6N6BTVdTRFZ
        bzhX3RFpMwhtd6H3YNTRu9eevFh1yndsr0Btdg2cZ+SE/qUWw2+dYBk+V6tRjR8q
        JxV0jyaILujO0scy+kKNloY+RgrWX2Nmd3jvLOO64sbcEkoQk7NEOEjZZQHMEhnR
        1rbxW23OrYssHt4A79dk4cTnVWS+zdajMdFGtISYz+1mG54Oib3NuQ0GAu4W8XbQ
        RAbiWvbFvs/gOlGjsyIU72aoIyhmom6PznL4EwIt6kbPgQePGR4JQ7UTJlH8k9gv
        slHAvUN5u78EZejU+Q9QO25Z7UL/3DfeVNRc3MyVg7bE5KxiK+D4PQ/aGLTX2YUs
        HpuKEGibNiss6GH/cQPZkw5XaEqhzEUJ9piSLJzmCZxX5t0e7/L4lnip0mW5s8Fx
        KyaD/s7HT929ybc42yQly2mWNczJ3tNlO3a39knJ7wfFdVUZLRLuIDkTzKZQOpMS
        DvCBR+pBdxPi3ow9IMXg2HK9aplTXxP3TrXKf4EYRv19UPAmFWrA99wYHsGwQ2oG
        OKznDFkZ0m6wZ3B2VaKP2cwxVemrhs5lMO0We1OR0OL0bdh5n+0KioUX8X+qnwVt
        IIHIB9waJUJ6cRbxlpiN+CAsh3+fwnvLJU71AluE9/bfZPBARUUcfxDDLLdY3Lcb
        1gmN7ThtpVME6nUKd9y1Gj6ZXh3tMucCAwEAAaOCB6swggenMAwGA1UdEwEB/wQC
        MAAwHQYDVR0OBBYEFOOAf2tc+fi06L/cMUPRwAVropUbMAwGA1UdDwQFAwMH/4Aw
        ggEwBgNVHSUEggEnMIIBIwYIKwYBBQUHAwEGCCsGAQUFBwMCBggrBgEFBQcDAwYI
        KwYBBQUHAwQGCCsGAQUFBwMIBgorBgEEAYI3AgEVBgorBgEEAYI3AgEWBgorBgEE
        AYI3CgMBBgorBgEEAYI3CgMDBgorBgEEAYI3CgMEBglghkgBhvhCBAEGCysGAQQB
        gjcKAwQBBggrBgEFBQcDBQYIKwYBBQUHAwYGCCsGAQUFBwMHBggrBgEFBQgCAgYK
        KwYBBAGCNxQCAgYIKwYBBQUHAwkGCCsGAQUFBwMNBggrBgEFBQcDDgYHKwYBBQID
        BQYHKwYBBQIDBAYIKwYBBQUHAxUGCSqGSIb3LwEBBQYKKwYBBAGCNwoDDAYKKwYB
        BAGCN0MBAQYKKwYBBAGCN0MBAjCCBgEGA1UdEQSCBfgwggX0hwQKIAABhwQKIAAC
        hwQKIAADhwQKIAAEhwQKIAAFhwQKIAAGhwQKIAAHhwQKIAAIhwQKIAAJhwQKIAAK
        hwQKIAALhwQKIAAMhwQKIAANhwQKIAAOhwQKIAAPhwQKIAAQhwQKIAARhwQKIAAS
        hwQKIAAThwQKIAAUhwQKIAAVhwQKIAAWhwQKIAAXhwQKIAAYhwQKIAAZhwQKIAAa
        hwQKIAAbhwQKIAAchwQKIAAdhwQKIAAehwQKIAAfhwQKIAAghwQKIAAhhwQKIAAi
        hwQKIAAjhwQKIAAkhwQKIAAlhwQKIAAmhwQKIAAnhwQKIAAohwQKIAAphwQKIAAq
        hwQKIAArhwQKIAAshwQKIAAthwQKIAAuhwQKIAAvhwQKIAAwhwQKIAAxhwQKIAAy
        hwQKIAAzhwQKIAA0hwQKIAA1hwQKIAA2hwQKIAA3hwQKIAA4hwQKIAA5hwQKIAA6
        hwQKIAA7hwQKIAA8hwQKIAA9hwQKIAA+hwQKIAA/hwQKIABAhwQKIABBhwQKIABC
        hwQKIABDhwQKIABEhwQKIABFhwQKIABGhwQKIABHhwQKIABIhwQKIABJhwQKIABK
        hwQKIABLhwQKIABMhwQKIABNhwQKIABOhwQKIABPhwQKIABQhwQKIABRhwQKIABS
        hwQKIABThwQKIABUhwQKIABVhwQKIABWhwQKIABXhwQKIABYhwQKIABZhwQKIABa
        hwQKIABbhwQKIABchwQKIABdhwQKIABehwQKIABfhwQKIABghwQKIABhhwQKIABi
        hwQKIABjhwQKIABkhwQKIABlhwQKIABmhwQKIABnhwQKIABohwQKIABphwQKIABq
        hwQKIABrhwQKIABshwQKIABthwQKIABuhwQKIABvhwQKIABwhwQKIABxhwQKIABy
        hwQKIABzhwQKIAB0hwQKIAB1hwQKIAB2hwQKIAB3hwQKIAB4hwQKIAB5hwQKIAB6
        hwQKIAB7hwQKIAB8hwQKIAB9hwQKIAB+hwQKIAB/hwQKIACAhwQKIACBhwQKIACC
        hwQKIACDhwQKIACEhwQKIACFhwQKIACGhwQKIACHhwQKIACIhwQKIACJhwQKIACK
        hwQKIACLhwQKIACMhwQKIACNhwQKIACOhwQKIACPhwQKIACQhwQKIACRhwQKIACS
        hwQKIACThwQKIACUhwQKIACVhwQKIACWhwQKIACXhwQKIACYhwQKIACZhwQKIACa
        hwQKIACbhwQKIACchwQKIACdhwQKIACehwQKIACfhwQKIACghwQKIAChhwQKIACi
        hwQKIACjhwQKIACkhwQKIAClhwQKIACmhwQKIACnhwQKIACohwQKIACphwQKIACq
        hwQKIACrhwQKIACshwQKIACthwQKIACuhwQKIACvhwQKIACwhwQKIACxhwQKIACy
        hwQKIACzhwQKIAC0hwQKIAC1hwQKIAC2hwQKIAC3hwQKIAC4hwQKIAC5hwQKIAC6
        hwQKIAC7hwQKIAC8hwQKIAC9hwQKIAC+hwQKIAC/hwQKIADAhwQKIADBhwQKIADC
        hwQKIADDhwQKIADEhwQKIADFhwQKIADGhwQKIADHhwQKIADIhwQKIADJhwQKIADK
        hwQKIADLhwQKIADMhwQKIADNhwQKIADOhwQKIADPhwQKIADQhwQKIADRhwQKIADS
        hwQKIADThwQKIADUhwQKIADVhwQKIADWhwQKIADXhwQKIADYhwQKIADZhwQKIADa
        hwQKIADbhwQKIADchwQKIADdhwQKIADehwQKIADfhwQKIADghwQKIADhhwQKIADi
        hwQKIADjhwQKIADkhwQKIADlhwQKIADmhwQKIADnhwQKIADohwQKIADphwQKIADq
        hwQKIADrhwQKIADshwQKIADthwQKIADuhwQKIADvhwQKIADwhwQKIADxhwQKIADy
        hwQKIADzhwQKIAD0hwQKIAD1hwQKIAD2hwQKIAD3hwQKIAD4hwQKIAD5hwQKIAD6
        hwQKIAD7hwQKIAD8hwQKIAD9hwQKIAD+MBEGCWCGSAGG+EIBAQQEAwIA9zAeBglg
        hkgBhvhCAQ0EERYPeGNhIGNlcnRpZmljYXRlMA0GCSqGSIb3DQEBDQUAA4IEAQCV
        NCKNICbHemimmoMSCV8mJ/Hh00x3/wPsDfKmRckDcT9t0ZgP941MihiiwbW/K/iF
        4qtJXFjbvLPviLh/3moSXmXl2qPUnmJ5wr8BqIxCqwi5eIkxExsnHG4w6yxsVSem
        SKKl+nZs7uydMfJc+Jt7KMGZ2eEzJWaO/D03ek0GePK5ZZ8P8u5x30Yup1Ahbu5I
        z3DeCClLCKTjpTQ+26LaGS1r4t7+4lCEt3BlGm4SfuG/rphb5IpgGYwptqwHFT5v
        Z1jBhkhWC5gbrXAiUu4PbassZWZcrTqKgdlGZZDaNKlg0KQOcFSsRPmmqdPCsKa9
        jGx+7tKWi6wbFvUv7B+RCKQAKlmKIkZertCQbC8LO1o3HEVql+Pl4oiQwh0iDGNf
        6wtzkZjsNnqD3f+jesz35fuKMHZ40m7bgyp2837H0SHNFvXa2HDw0kSKkLoStoX+
        f4xr8Cs0ZyqpkZu6giRwIsN6oFrYHa+TcxiUR7s8QBLOq2ePnsTdm9/AfKaKaUD5
        cPx/c6+mk1x5tP4x9njcLUn0jSdfsg8VqAQQhNAKreCyaqYGNkdZZ7mpyiQ3IDrB
        NJM+As9mhc9x65sqswVUkPFo7VJXZG3eG+Njc1bHUO2wvnQgB2nlnucjniBwt7df
        sY3vj0+vR5OJbIOFDhOjOkUBknI2svJzICi1DTZRaQOsfcfzGOVkbbYnLKaC3XKQ
        CdaT2diP1edHPN1ia8Y68y4D8BWikd0reoUuMith3Qvzf9Vdpipry7Pr+wNiEqJA
        DYE3z+2BOXFhxo0u1aYnyUlXGRpmko9tOmBHr/QasB2p+HCueBPjcmu/pdpFUrc9
        U5iTNpFeZoSrsQ5HQkU4zpFp3B/PQspUB4IAFY99GDZCcrWbSGIVScTa1JRfdne7
        XNsEmO8TU5AtSSo9MTTQE+Qus5WK/xajfIZZTQEvsH7lDMu5jpJvY94EB7x1iOfZ
        /R0L9UmXZB4TLd4DcN9U6UIAHUo+su6DuIeVNGQCmdyydJsQI1A1+JiGQb+yiuIL
        4IFmpiHHxnaJhMrDAlScblMWbPSrkUBchaRqdh3EkuSKgZtGj7Og0YKcNhoJpJQl
        TrlwlIr+ANz/HQMtRPlwixddOujkLHHSCJfHfs40001XVdLmNBTVkRlhHgwQk4Ry
        U25C2/T5mYSmVnmsj8bdEjrIIDFSE6WboGBL/+TC7LwwQjdMAiNHvOg3ovZ6A9gs
        4SdTsNDvHzu3aZNcOXyHRp1sBG4/rJdtKpN3CErN04Qu2MiKH+jHDqWgzQ26d75b
        u+XG100rBe+csTMSZVam6Ycx2J7Xqoc2npki7b/Yt36hNUpJDZLvIKseHnWIj4IS
        1UIdFTFtMoq7G4LHdZ1e
        -----END CERTIFICATE-----
  cert.key: |
        -----BEGIN RSA PRIVATE KEY-----
        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
        -----END RSA PRIVATE KEY-----
---
apiVersion: batch/v1
kind: Job
metadata:
  name: devcontainer-$name
spec:
  template:
    spec:
      dnsConfig:
        nameservers:
          - 1.1.1.1
          - 8.8.8.8
      containers:
      - name: $(whoami)-$name
        image: mltooling/ml-workspace-gpu:0.13.2
        # imagePullPolicy: Always
        env:
          - name: SHUTDOWN_INACTIVE_KERNELS
            value: "7200"
          - name: TENSORBOARD_PROXY_URL
            value: "/tools/%PORT%/"
          - name: AUTHENTICATE_VIA_JUPYTER
            value: "${token}"
          - name: WORKSPACE_SSL_ENABLED
            value: "true"
          - name: SERVICE_URL
            value: "https://open-vsx.org/vscode/gallery"
          - name: ITEM_URL
            value: "https://open-vsx.org/vscode/item"
        resources:
          requests:
            ephemeral-storage: 30Gi
          limits:
            nvidia.com/gpu: "$gpus"
        volumeMounts:
        - name: data
          mountPath: /workspace/data
        - name: data
          mountPath: /workspace/.workspace
          subPath: .workspace
        - name: data
          mountPath: /opt/conda/pkgs
          subPath: .conda_pkgs
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
