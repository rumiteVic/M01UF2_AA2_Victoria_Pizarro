#!/bin/bash

PORT="2022"

echo "Cliente de casa"

echo "1. ENVIO DE CABECERA"

echo "DMAM" | nc localhost $PORT

echo "4. RECIBIENDO OK_HEADER"
DATA=`nc -l $PORT`
if [ "$DATA" != "OK_HEADER" ]
then
	echo "ERROR 1: el header se envio incorrectamente"
	exit 1
fi

echo "5 y 6. Enviando el FILE_NAME y md5sum"
MD5SUM=`echo -n dragon.txt | md5sum`


echo -n "FILE_NAME dragon.txt $MD5SUM" | nc localhost $PORT

echo "10. RECIBIENDO OK_FILE_NAME"
DATA=`nc -l $PORT`

if [ "$DATA" != "OK_FILE_NAME" ]
then
	echo "ERROR 4: el md5sum se envio incorrectamente"
	exit 2
fi

echo "11.ENVIANDO UN ARCHIVO"
DRAGON=`cat dragon.txt`
MD5SUM=`echo -n "$DRAGON" | md5sum`

cat dragon.txt | nc localhost $PORT

echo "15. RECIBIENDO OK_DATA"
DATA=`nc -l $PORT`
if [ "$DATA" != "OK_DATA" ]
then
	echo "ERROR 6: el dragon es incorrecto"
	exit 3
fi

echo "16. ENVIANDO FILE_NAME_MD5"
echo -n "FILE_MD5 $MD5SUM" | nc localhost $PORT


echo "21. RECIBIENDO OK_FILE_MD5"
DATA=`nc -l $PORT`
if [ "$DATA" != "OK_FILE_MD5" ]
then
	echo "ERROR 8: No md5"
	exit 4
fi

