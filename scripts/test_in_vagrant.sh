#!/bin/bash 
# this script is used to simplify development process
# and also avoids to use test-kitchen

## config
# vm hostname used in vagrant
: ${VM_HOSTNAME:="u1804"}

# delete vm after build
 
: ${VM_TEARDOWN:="false"}


### end of config

vagrant validate || exit 1

# check if vagrant vm is up, grep for vm status, not comments
vm_running=$(vagrant status | grep -c 'running (')
set +e
if [ "$vm_running" -eq 1 ]; then
	vagrant rsync
	vagrant provision
	result=$?
else
	vagrant up
	result=$?
fi

# fetch back the results
vagrant ssh-config > .vagrant/ssh-config
sync
rsync -a --rsync-path="sudo rsync" -e "ssh -F .vagrant/ssh-config" vagrant@${VM_HOSTNAME}:/vagrant/reports/ ./reports/

if [ "$VM_TEARDOWN" == "true" ]; then
	vagrant destroy -f
fi

exit $result
