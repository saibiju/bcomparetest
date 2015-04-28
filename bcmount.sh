#!/bin/bash
BCDIR="$(cd ${0%/*} && pwd -P)"
if [ `getconf LONG_BIT` -eq 32 ]
then
	$BCDIR/bcmount32 "$1"
else
	$BCDIR/bcmount64 "$1"
fi
# Check if the mount failed because the local mount point wasn't found
if [ $? -eq 2 ]
then
	# Check if the GVFS FUSE daemon is running
	ps -C gvfsd-fuse -C gvfs-fuse-daemon > /dev/null
	if [ $? -ne 0 ]
	then
		# Check if the FUSE group exists and whether the user is part of it
		grep ^fuse /etc/group && groups | grep \\bfuse\\ >> /dev/null
		if [ $? -ne 0 ]
		then
			echo "Not a member of the FUSE group"	
		else
			echo "gvfs-fuse-daemon is not running"
		fi
	# else daemon is running; unknown error
	else
		echo "unknown error"
	fi
fi