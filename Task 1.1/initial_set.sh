#!/bin/bash
#set users and passwords 
for user in "$@"; do
    sudo useradd -m -s /bin/bash -N "$user" &&
    sudo usermod -a -G users "$user" &&
    pass=$(openssl rand -base64 6) &&
    echo "$user:$pass" | sudo chpasswd && echo "$user:$pass" >> user_password.txt
done

