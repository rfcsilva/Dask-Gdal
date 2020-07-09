#!/bin/bash

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
	# generate fresh rsa key
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
	# generate fresh dsa key
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi

if [ ! -f "/root/.ssh/id_rsa" ]; then
	# generate fresh dsa key
	ssh-keygen -f /root/.ssh/id_rsa -N '' -t rsa
fi

#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi

/usr/sbin/sshd

# Run extra commands
exec "$@"