# Get server IP and username
read -p "Enter DGX server ip: " DGX_IP
read -p "Enter DGX server username: " DGX_USER

# Get tunnel port
read -p "Enter local SSH tunnel port[8089]: " T_PORT
if [ -z $T_PORT ]
then
    T_PORT=8089
fi

# Asy if new devcontainer creation is required
read -p "Would you like to create a new devcontainer?[Y/n]: " IS_NEW_CONTAINER
if [ -z $IS_NEW_CONTAINER ] || [ $IS_NEW_CONTAINER = 'y' ] || [ $IS_NEW_CONTAINER = 'Y']
then
    ssh $DGX_USER@$DGX_IP -t 'source <(curl -s https://raw.githubusercontent.com/IITJ-RCAI/devcontainers/main/deployment/run_devcontainer.sh)'
fi

echo "Building ssh tunnel..."
echo "
This terminal will now serves as a tunnel proxy to the DGX server.
Please login to ssh once again at the prompt.
Do not close this terminal untill you are working. If you end up closing this terminal, you can re-run this script and specify 'n' at the create new devcontainer prompt.

To connect to the devcontainer you must configure your browser to use a SOCKS5 proxy via this URL,
socks5://localhost:$T_PORT
"

# Build ssh tunnel and run command
ssh -NTD $T_PORT $DGX_USER@$DGX_IP

echo "SSH tunnel closed."
echo "NOTE: If you created a devcontainer, it is still running...! Remember to stop it when you are done."
read -p "Press enter to continue..."