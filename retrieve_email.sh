#!/bin/bash
#

#Recupera mensajes de una cuenta usando POP3


#Verificamos parametros
#1 Email
#2 Pwd
#3 Servidor
#4 Directorio Destino


#Control Numero parametros
if test $# -ne  3
then
        echo "ERROR FALTAN PARAMETROS"
        echo "$0 EMAIL PASSWORD SERVER [DESTINO]"
        exit    
fi


EMAIL="$1"
PWD="$2"
SERVER="$3"
DESTINO="$4"

#Si no hay destino, creamos directorio con el EMAIL
if test ${#4} -eq 0
then
  DESTINO="$1"
fi

if ! test -d "${DESTINO}"
then
  echo "Creando directorio ${DESTINO}"
  mkdir "${DESTINO}"
fi


#Listamos mensajes
LISTAMSG=$(curl -s -u "${EMAIL}:${PWD}"  pop3://${SERVER} --request list)

#Total ha recuiperar
TOTALMSG=$(echo "${LISTAMSG}" | wc -l)

echo "Recuperando ${TOTALMSG}"
#Podemos tambien indicar el total de bytes...

#Recuperamos mensajes
while read  LINEA
do
echo "${LINEA}"
  NMSG=$(echo "${LINEA}" | awk '{print $1}')
  SIZE=$(echo "${LINEA}" | awk '{print $2}')
  
  echo "Recupera ${NMSG}  Bytes ${SIZE}"
  curl -s -u "${EMAIL}:${PWD}"  pop3://${SERVER} --request "retr ${NMSG}" > ${DESTINO}/${NMSG}
  
  
done <<< "${LISTAMSG}"


