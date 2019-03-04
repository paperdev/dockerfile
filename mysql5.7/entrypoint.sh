#!/bin/bash

set -e

COMMAND_MYSQLD=mysqld
COMMAND_MYSQLD_SAFE=mysqld_safe
COMMAND_MYSQLADMIN=mysqladmin

DATADIR="/var/lib/mysql"

if [ -n "$MYSQL_LOG_CONSOLE" ] || [ -n "" ]; then
	# Don't touch bind-mounted config files
	if ! cat /proc/1/mounts | grep "etc/my.cnf"; then
		sed -i 's/^log-error=/#&/' /etc/my.cnf
	fi
fi


if [ ! -d "${DATADIR}/mysql" ]; then
	if [ -z "${MYSQL_ROOT_PASSWORD}" ]; then
		echo >&2 '[Entrypoint] No password option specified for new database.'
		echo >&2 '[Entrypoint] A random password will be generated.'
		MYSQL_ROOT_PASSWORD="$(pwmake 128)"
		echo "[Entrypoint] GENERATED ROOT PASSWORD: ${MYSQL_ROOT_PASSWORD}"
	fi

	mkdir -p ${DATADIR}
	chown -R ${MYSQL_USER}:${MYSQL_USER} ${DATADIR}

	echo '[Entrypoint] Initializing database...'
	$COMMAND_MYSQLD --initialize-insecure --user=${MYSQL_USER} --datadir=${DATADIR}

	echo '[Entrypoint] Generate temporary password file'
	# To avoid using password on commandline, put it in a temporary file.
	# The file is only populated when and if the root password is set.
	PASSFILE=$(mktemp -u /var/lib/mysql-files/XXXXXXXXXX)
	install /dev/null -m0600 -o${MYSQL_USER} -g${MYSQL_USER} ${PASSFILE}
	# Put the password into the temporary file
	cat >${PASSFILE} <<-EOF
		[client]
		password="${MYSQL_ROOT_PASSWORD}"
	EOF

	echo '[Entrypoint] Configurate root user'
	if [ -z "${MYSQL_ROOT_HOST}" ]; then
		ROOTCREATE="ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
	else
		echo '[Entrypoint] CoConfigurate to allow root remote access'
		ROOTCREATE="ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		CREATE USER 'root'@'${MYSQL_ROOT_HOST}' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		GRANT ALL ON *.* TO 'root'@'${MYSQL_ROOT_HOST}' WITH GRANT OPTION ;
		GRANT PROXY ON ''@'' TO 'root'@'${MYSQL_ROOT_HOST}' WITH GRANT OPTION ;"
	fi
		
	echo '[Entrypoint] Generate /tmp/mysql-first-time.sql'
	cat > /tmp/mysql-first-time.sql <<-EOSQL	
		DELETE FROM mysql.user WHERE user NOT IN ('mysql.infoschema', 'mysql.session', 'mysql.sys', 'root') OR host NOT IN ('localhost');
		${ROOTCREATE}
		FLUSH PRIVILEGES ;
	EOSQL
	
	echo '[Entrypoint] Run /tmp/mysql-first-time.sql'
	${COMMAND_MYSQLD} --defaults-extra-file=${PASSFILE} -uroot --init-file=/tmp/mysql-first-time.sql &
	sleep 5
	$COMMAND_MYSQLADMIN --defaults-extra-file=${PASSFILE} -uroot shutdown
	
	# Delete the temporary password file
	rm -f ${PASSFILE}
	unset PASSFILE
	echo '[Entrypoint] Database initialized.'

fi

echo "[Entrypoint] Starting MySQL..."
${COMMAND_MYSQLD_SAFE} --user=${MYSQL_USER}