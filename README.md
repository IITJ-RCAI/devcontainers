# Development Containers

Powered by,

- [ml-workspace](https://github.com/ml-tooling/ml-workspace)

To use run the following command,

`bash -c "source <(curl -s https://raw.githubusercontent.com/IITJ-RCAI/devcontainers/main/deployment/run.sh)"`

## Shutdown

Please shutdown the devcontainer when your work with it is done.

To shutdown, use the following command in the terminal inside the devcontainer,

`supervisorctl shutdown`

> Note that shutting down the container doesn't delete the Kubectl Job.

## Enabling HTTPS

To enable trusted HTTPS you need to install the roo CA certificate in your computer,
- Download [rootCS.pem](/deployment/cert/rootCA.pem)
- Install this certificate file in your browser under trusted root CAs.
  - See this guide for chrome: [Add a Root Certificate in Google Chrome](https://docs.vmware.com/en/VMware-Adapter-for-SAP-Landscape-Management/2.0.1/Installation-and-Administration-Guide-for-VLA-Administrators/GUID-D60F08AD-6E54-4959-A272-458D08B8B038.html)
