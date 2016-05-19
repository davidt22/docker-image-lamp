#!/bin/bash

now="$(date +'%d-%m-%Y')"

mysql -uadmin -padmin vagante_local_1_6 < /var/www/bd_backups/last_backup.sql
