#!/bin/bash
file="./private_db_address5345535.txt"
db_ip=$(cat "$file")
echo "define( 'DB_HOST', '$db_ip' );" >> foo.php