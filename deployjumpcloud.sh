#!/bin/bash
############
# v1.0
#
# Runs Agent installer and renames user account to match JumpCloud naming scheme
#
# Run command as follows:
# deployjumpcloud.sh <oldUserName> <newUserName> <connectKey>
# 
############

# check for root
if [[ $UID != 0 ]]; then
	echo Please run this script with sudo. Thanks!
	echo “sudo $0 $*”
	exit 1
fi

# pull down generic scripts from JumpCloud GitHub repository
curl -o /tmp/rename.sh https://raw.githubusercontent.com/TheJumpCloud/support/master/scripts/macos/RenameMacUserNameAndHomeDirectory.sh
curl -o /tmp/agent.sh https://raw.githubusercontent.com/TheJumpCloud/support/master/scripts/macos/install_agent_and_serviceaccount.sh

# check connect key length and run agent installer with connect key
connectKey=$3
if [ ${#connectKey} != 40 ]; then
	echo Your Connect Key is not the right length. Try again!
	exit 1
fi
echo Installing JumpCloud Agent
sh /tmp/agent.sh -k $connectKey
sleep 60
echo JumpCloud Agent installed!

# Run User Rename Script
echo Renaming User Account and Restarting
oldUserName=$1
newUserName=$2
source /tmp/rename.sh $oldUserName $newUserName
echo Restarting…

exit 0