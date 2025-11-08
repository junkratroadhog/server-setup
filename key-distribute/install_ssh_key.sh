#!/bin/bash

# Usage:
# ./add_ssh_key_single_host.sh -k /path/to/id_rsa.pub -u "user1 user2" -h hostname_or_ip

while getopts k:u:h: flag
do
    case "${flag}" in
        k) PUBKEY=${OPTARG};;
        u) USERS=${OPTARG};;
        h) HOST=${OPTARG};;
        *) echo "Usage: $0 -k <pubkey_file> -u \"user1 user2\" -h <hostname_or_ip>"; exit 1;;
    esac
done

# Check required parameters
if [ -z "$PUBKEY" ] || [ -z "$USERS" ] || [ -z "$HOST" ]; then
    echo "Missing required arguments!"
    echo "Usage: $0 -k <pubkey_file> -u \"user1 user2\" -h <hostname_or_ip>"
    exit 1
fi

# Check if public key file exists
if [ ! -f "$PUBKEY" ]; then
    echo "Public key file $PUBKEY does not exist!"
    exit 1
fi

# Read the public key into a variable
PUBKEY_CONTENT=$(cat "$PUBKEY")

# Loop through each user
for USER in $USERS; do
    echo "Adding key for user: $USER on host: $HOST"
    ssh "$USER@$HOST" "
        mkdir -p ~/.ssh &&
        chmod 700 ~/.ssh &&
        touch ~/.ssh/authorized_keys &&
        grep -qxF '$PUBKEY_CONTENT' ~/.ssh/authorized_keys || echo '$PUBKEY_CONTENT' >> ~/.ssh/authorized_keys &&
        chmod 600 ~/.ssh/authorized_keys
    "
    if [ $? -eq 0 ]; then
        echo "  ✅ Key added successfully for $USER@$HOST"
    else
        echo "  ❌ Failed to add key for $USER@$HOST"
    fi
done

echo "All done!"
