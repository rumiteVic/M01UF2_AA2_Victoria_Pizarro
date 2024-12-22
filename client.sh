#!/bin/bash
PORT="2022"

echo "Probando tab	a"

echo "Cliente de casa"

echo "1. ENVIO DE CABECERA"

echo "DMAM" | nc localhost $PORT

DATA=`nc -l $PORT`

if [ "$DATA" != "OK_HEADER" ]
then
	echo "ERROR 1: el header se envio incorrectamente"
	exit 1
fi

echo "3 y 4. Enviando el FILE_NAME y md5sum"
MD5SUM=`echo -n dragon.txt | md5sum`


echo -n "FILE_NAME dragon.txt $MD5SUM" | nc localhost $PORT

echo "8. RECIBIENDO OK_FILE_NAME"
DATA=`nc -l $PORT`

if [ "$DATA" != "OK_FILE_NAME" ]
then
	echo "ERROR 4: el md5sum se envio incorrectamente"
	exit 4
fi

echo "9.ENVIANDO UN ARCHIVO"
DRAGON=`cat dragon.txt`
MD5SUM=`echo -n "$DRAGON" | md5sum`

cat dragon.txt | nc localhost $PORT

echo "12. RECIBIENDO OK_DATA"
DATA=`nc -l $PORT`
if [ "$DATA" != "OK_DATA" ]
then
	echo "ERROR 6: el dragon es incorrecto"
	exit 6
fi

echo "13. ENVIANDO FILE_NAME_MD5"
echo -n "FILE_MD5 $MD5SUM" | nc localhost $PORT


echo "17. RECIBIENDO OK_DRAGON"
DATA=`nc -l $PORT`
if [ "$DATA" != "OK_FILE_MD5" ]
then
	echo "ERROR 8: No md5"
	exit 8
fi

