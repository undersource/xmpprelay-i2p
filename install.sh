#!/bin/bash
go get
go build .
cp xmpprelay /usr/bin/xmpprelay
if [[ `stat /proc/1/exe | grep "/sbin/init"` != "" ]]; then
	INIT="openrc"
elif [[ `stat /proc/1/exe | grep "/lib/systemd/systemd"` != "" ]]; then
	INIT="systemd"
elif [[ `stat /proc/1/exe | grep "/usr/bin/runit"` != "" ]]; then
  INIT="runit"
fi
getent passwd xmpprelay &> /dev/null

if [ $? -eq 2 ]; then
    useradd -Mrs /sbin/nologin xmpprelay &> /dev/null
fi

if [ $INIT = "openrc" ]; then
	cp services/openrc/xmpprelay /etc/init.d/xmpprelay
elif [ $INIT = "systemd" ]; then
	cp services/systemd/xmpprelay.service /etc/systemd/system/xmpprelay.service
elif [ $INIT = "runit" ]; then
  cp -r services/runit/xmpprelay /etc/runit/sv/xmpprelay
else
	echo "Unknown init system"
fi

