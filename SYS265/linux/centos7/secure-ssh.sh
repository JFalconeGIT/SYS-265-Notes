#secure-ssh.sh
#author jayden.falcone
#creates a new ssh user using the $1 parameter
#adds a public key from the local repo or curled from remote repo
#removes root ability to ssh in 
echo "# -------- VARIABLES --------
$user = "sys265"
$pubKeyPath = "/home/jayden/SYS-265-Notes/SYS265/linux/public-keys/id_rsa.pub"

# -------- CREATE USER --------
sudo useradd -m -d /home/$user -s /bin/bash $user

# -------- CREATE .ssh DIRECTORY --------
sudo mkdir -p /home/$user/.ssh

# -------- COPY PUBLIC KEY --------
sudo cp $pubKeyPath /home/$user/.ssh/authorized_keys

# -------- FIX PERMISSIONS (REQUIRED FOR SSH) --------
sudo chmod 700 /home/$user/.ssh
sudo chmod 600 /home/$user/.ssh/authorized_keys
sudo chown -R $user`:$user /home/$user/.ssh

# -------- DISABLE PASSWORD LOGIN --------
sudo passwd -l $user

Write-Host "User $user created with RSA key-only login."" 
