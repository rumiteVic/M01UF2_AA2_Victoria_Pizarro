#!/bin/bash
PORT="2022"

echo "Servidor casa"

echo "0. escuchamos"
DATA=`nc -l $PORT`

echo "2. COMPROBANDO CABECERA"
if [ "$DATA" != "DMAM" ]
then
	echo "ERROR 1: Cabecera incorrecta"
	echo "KO_HEADER" | nc localhost $PORT
	exit 1
fi

echo "3. CHECK OK - Enviando OK_HEADER"
echo "OK_HEADER" | nc localhost $PORT

echo "7.COMPROBANDO PREFIJO"
DATA=`nc -l $PORT`

PREFIX=`echo "$DATA" | cut -d ' ' -f1`
NAME_FILE=`echo "$DATA" | cut -d ' ' -f3`
MD5SUM1=`echo -n dragon.txt | md5sum`
MD5SUM=`echo "$MD5SUM1" | cut -d ' ' -f1`

if [ "$PREFIX" != "FILE_NAME" ]
then
	echo "ERROR 2: Prefijo incorrecto"
	echo "KO_FILE_NAME" | nc localhost $PORT
	exit 2
fi

echo "8. COMPROBANDO MD5SUM"

if [ "$MD5SUM" != "$NAME_FILE" ]
then
	echo "ERROR 3: md5sum incorrecto"
	echo "KO_FILE_NAME_MD5" | nc localhost $PORT
	exit 2
fi

echo "9. ENVIANDO OK_FILE_NAME"
echo "OK_FILE_NAME" | nc localhost $PORT


echo "12. RECIBIENDO UN ARCHIVO"
DATA=`nc -l $PORT > recibiendodragon.txt`

RECIBIDO=`cat recibiendodragon.txt`
COMPROBACION=`cat dragon.txt`

echo "13. COMPROBANDO ARCHIVO"
if [ "$RECIBIDO" != "$COMPROBACION" ]
then
	echo "ERROR 5: Dragon incoreccto"
	echo "KO_DATA" | nc localhost $PORT
	exit 3
fi

echo "14. ENVIADO OK_DATA"
echo "OK_DATA" | nc localhost $PORT

echo "17. RECIBIENDO FILE_MD5"
DATA=`nc -l $PORT`
PREFIJO=`echo "$DATA" | cut -d ' ' -f1`
MD5SUM=`echo "$DATA" | cut -d ' ' -f2`
COMPROBACION1=`echo - "$MD5SUM" | cut -d ' ' -f2`

echo "18. COMRPOBANDO PREFIJO"
if [ "$PREFIJO" != "FILE_MD5" ]
then
	echo "ERROR 7: PREFIJO INCORRECTO"
	echo "KO_FILE_MD5"
	exit 4
fi

echo "19. COMPROBANDO MD5SUM"
if [ "$MD5SUM" != "$COMPROBACION1" ]
then
	echo "ERROR 7: MD5SUM erroneo"
	echo "KO_FILE_MD5" | nc localhost $PORT
	exit 4
fi

echo "20. ENVIANDO OK_FILE_MD5"
echo "OK_FILE_MD5" | nc localhost $PORT



