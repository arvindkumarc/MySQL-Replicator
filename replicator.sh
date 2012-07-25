#!/bin/sh

. ./replication.properties

#echo "master-username = $musername"
#echo "master-password = $mpassword"
#echo "master-host = $mhost"

#echo "slave-username = $susername"
#echo "slave-password = $spassword"
#echo "slave-host = $shost" 

if [ `whoami` != 'root' ]; then
	echo "Can be exeucted only with root privileges"
	exit 1;
fi

stopMySQL() {
    echo -e "\n Stopping MySQL instance"
    sleep 2
    mysqladmin -uroot -p$spassword shutdown 2> /dev/null
}

stopMySQLNoPassword() {
    echo -e "\n Stopping MySQL instance"
    sleep 2
    mysqladmin -uroot shutdown 2> /dev/null
}

findAndReplace () {
found=""
if [ "`grep "$1" /etc/my.cnf`" == "" ]; then found="true"; fi

	if [ -z "$found" ]; then
		sed "s/"$1".*=.*/"$1=$2"/g" /tmp/my.cnf > /tmp/my.cnf.bak
	else
		sed '/\[mysqld\]/a\
'$1=$2'
		' /tmp/my.cnf > /tmp/my.cnf.bak
	fi
	mv /tmp/my.cnf.bak /tmp/my.cnf

}

findAndDisable () {
found=""
if [ "`grep "$1" /etc/my.cnf`" == "" ]; then found="true"; fi

        if [ -z "$found" ]; then
                sed "s/"$1".*=.*/#"$1"/g" /tmp/my.cnf > /tmp/my.cnf.bak
        else
                sed '/\[mysqld\]/a\
#'$1'
                ' /tmp/my.cnf > /tmp/my.cnf.bak
        fi
        mv /tmp/my.cnf.bak /tmp/my.cnf

}
