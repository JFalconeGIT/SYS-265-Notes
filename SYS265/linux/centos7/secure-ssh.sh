#secure-ssh.sh
#author jayden.falcone
#creates a new ssh user using the $1 parameter
#adds a public key from the local repo or curled from remote repo
#removes root ability to ssh in 
#!/bin/bash

# ---- VARIABLES ----
USERNAME="sys265"
PUBKEY_SOURCE="linux/public-keys/id_rsa.pub"
HOMEDIR="/home/$USERNAME"
SSH_DIR="$HOMEDIR/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

# ---- REQUIRE ROOT ----
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

echo "Creating user: $USERNAME"

# ---- CREATE USER ----
if id "$USERNAME" &>/dev/null; then
    echo "User already exists"
else
    useradd -m -d "$HOMEDIR" -s /bin/bash "$USERNAME"
fi

# ---- CREATE SSH DIRECTORY ----
mkdir -p "$SSH_DIR"

# ---- COPY PUBLIC KEY ----
cp "$PUBKEY_SOURCE" "$AUTHORIZED_KEYS"

# ---- FIX PERMISSIONS (CRITICAL FOR SSH) ----
chmod 700 "$SSH_DIR"
chmod 600 "$AUTHORIZED_KEYS"
chown -R "$USERNAME:$USERNAME" "$SSH_DIR"

# ---- LOCK PASSWORD (KEY LOGIN ONLY) ----
passwd -l "$USERNAME"

echo "User

# -------- CHECK PARAMETER --------
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME="$1"
HOMEDIR="/home/$USERNAME"
SSH_DIR="$HOMEDIR/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

# Location of public key copied from web01 repo
PUBKEY_SOURCE="$(pwd)/linux/public-keys/id_rsa.pub"

# -------- REQUIRE ROOT --------
if [ "$EUID" -ne 0 ]; then
    echo "Run with sudo: sudo $0 <username>"
    exit 1
fi

echo "Creating secure SSH user: $USERNAME"

# -------- CREATE USER IF NOT EXISTS --------
if id "$USERNAME" &>/dev/null; then
    echo "User already exists."
else
    useradd -m -d "$HOMEDIR" -s /bin/bash "$USERNAME"
fi

# -------- CREATE SSH DIRECTORY --------
mkdir -p "$SSH_DIR"

# -------- INSTALL PUBLIC KEY --------
cp "$PUBKEY_SOURCE" "$AUTHORIZED_KEYS"

# -------- FIX PERMISSIONS (CRITICAL) --------
chmod 700 "$SSH_DIR"
chmod 600 "$AUTHORIZED_KEYS"
chown -R "$USERNAME:$USERNAME" "$SSH_DIR"

# -------- DISABLE PASSWORD LOGIN --------
passwd -l "$USERNAME" >/dev/null 2>&1

echo "✅ User $USERNAME created with passwordless SSH access."
