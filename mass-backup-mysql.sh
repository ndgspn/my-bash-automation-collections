#!/bin/bash
#Nandang Sopyan
#http://nandang.id

DATE=$(date +%d-%m-%Y)
BACKUP_DIR="/home/syspc/Downloads/pahami"
MYSQL_USER="nandang"
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump

make_dir() {
    mkdir -p $BACKUP_DIR/$DATE
}

insert_mysql_password() {
    echo -n "Mysql password: "
    read MYSQL_PASSWORD
}

show_databases() {
    databases=`$MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema)"`
}

dump_each_database() {
    for db in $databases; do
        echo $db
        $MYSQLDUMP --force --opt -u$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | zip > "$BACKUP_DIR/$DATE/$db.zip"
    done
}

main() {
    make_dir
    insert_mysql_password
    show_databases
    dump_each_database
}
main
