#!/bin/bash

# Exit on any error
set -e

# Create the user "sergy" with password "VirusBlokAda"
useradd -m sergy
echo "sergy:VirusBlokAda" | chpasswd

# Create the flag
echo "NCD6{STUXN3T_C3NTR1FUG3_S4B0T4G3_2010}" > /root/flag.txt
chmod 600 /root/flag.txt

# Install vsftpd, Apache, SSH server, and GCC if not installed
apt update
apt install -y vsftpd apache2 gcc openssh-server

# Set up FTP
mkdir -p /home/ftpfiles
cp ../ftp/server_logs.txt /home/ftpfiles/
chmod -R 755 /home/ftpfiles
echo -e "local_enable=YES\nwrite_enable=NO\nanon_root=/home/ftpfiles\nanonymous_enable=YES\nlisten=YES\nlisten_ipv6=NO\npasv_enable=YES\npasv_min_port=40000\npasv_max_port=40010\n" > /etc/vsftpd.conf
systemctl restart vsftpd

# Set up web
rm -rf /var/www/html/*
cp ../http/index.html /var/www/html/
cp ../http/booom.jpeg /var/www/html/
systemctl restart apache2

# Set up SSH for the 'sergy' user
mkdir -p /home/sergy/.ssh
chmod 700 /home/sergy/.ssh
touch /home/sergy/.ssh/authorized_keys
chmod 600 /home/sergy/.ssh/authorized_keys
chown -R sergy:sergy /home/sergy/.ssh


# Compile and hide privilege escalation binary
mkdir -p /opt/.hiddenbin
cp ../setup/vuln.c /opt/.hiddenbin/vuln.c
gcc /opt/.hiddenbin/vuln.c -o /opt/.hiddenbin/vuln
chown root:root /opt/.hiddenbin/vuln
chmod 4511 /opt/.hiddenbin/vuln   # SUID root, not readable

# Prevent users from listing the directory
chmod 111 /opt/.hiddenbin

# Optionally clean up source code
rm /opt/.hiddenbin/vuln.c

# Restart SSH service
systemctl restart ssh


echo "[+] Setup completed."

