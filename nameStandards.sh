#!/bin/sh

###############################################################
#	RVNameStandards.sh
#
#	Written February 22, 2023
#	by Hunter Gardner
#
#	Red Ventures - CorpTech - I.E. - Configuration Management
#
###############################################################


#Define functions
getNetBIOSName () {
	defaults read /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName
}

getComputerName () {
	scutil --get ComputerName
}

getLocalHostName () {
	scutil --get LocalHostName
}

getHostName () {
	scutil --get HostName
}

setComputerName () {
	echo "Setting computername..."
	scutil --set ComputerName "$computername_upper"
	sleep 2
}

setLocalHostName () {
	echo "Setting localhostname..."
	scutil --set LocalHostName "$computername_upper"
	sleep 2
}

setHostName () {
	echo "Setting hostname..."
	scutil --set HostName "$computername_upper"
	sleep 2
}

displayNames () {
	echo "NetBIOS Name: $current_netbios"
	echo "Computer Name: $current_computername"
	echo "Local Hostname: $current_localhostname"
	echo "Hostname: $current_hostname"
}

#Get Serial number of machine and format.
computername="$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')"
computername_upper="$(echo $computername | tr '[:lower:]' '[:upper:]')"
echo "SN: $computername_upper"

#Get current NetBIOSName, Computer Name, Local Hostname and Hostname.
current_netbios=$(getNetBIOSName)
current_computername=$(getComputerName)
current_localhostname=$(getLocalHostName)
current_hostname=$(getHostName)
displayNames 


if [[ ($computername_upper == $current_netbios) && ($current_netbios == $current_computername) && ($current_computername == $current_localhostname) && ($current_localhostname == $current_hostname) ]]; then
	echo "Naming standards are met. Exiting..."
	exit 0
else
	echo "Naming standards are not met. Setting new names..."
	setComputerName 
	setLocalHostName 
	setHostName 
	sleep 5
	#Get new NetBIOSName, Computer Name, Local Hostname and Hostname.
	current_netbios=$(getNetBIOSName)
	current_computername=$(getComputerName)
	current_localhostname=$(getLocalHostName)
	current_hostname=$(getHostName)
	displayNames
	if [[ ($computername_upper == $current_netbios) && ($current_netbios == $current_computername) && ($current_computername == $current_localhostname) && ($current_localhostname == $current_hostname) ]]; then
		echo "Naming standards are now met. Exiting..."
		exit 0
	else
		echo "Failed to set new names to naming standard. Exiting with error..."
		exit 1
	fi
fi


