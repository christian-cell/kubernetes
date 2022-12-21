Sidecar container es un contenedor auxiliar que vive dentro del mismo pod que el contenedor de la aplicación , pueden comunicarse entre ellos dentro del mismo localhost , mientras que el initcontainer es un contenedor dentro del mismo pod del contenedor principal que iniciará antes que el contenedor de la aplicación , otra diferencia es que el sidecar container va a correr siempre que el contenedor principal del pod esté corriendo mientras que el init container tan solo correrá una vez , hará su trabajo y saldrá del mismo "exit" , el sidecar container comienza al mismo tiempo que el maincontainer , mientras que el initcontainer lo hace antes , y con el initContainer el contenedor principal del pod no puede iniciar hasta que el initContainer no haya terminado su labor

ejemplo de sidecarContainer

containers:
- name: log-sidecar
  image: busybox:1.28
  command: ["sh","-c" ,"while true; do echo sync app logs ; sleep 20; done"]

un sidecar container que lo único que haga es recolectar logs

ejemplo de initContainer

la etiqueta de initContainers tiene que ir al mismo nivel que la de containers

initContainers:
- name: mydb-available
  image: busybox
  command: ['sh','-c','until nslookup mydb-service ; do echo waiting for database; sleep 4;done']

Ahora para acceder a un container que está dentro del mismo pod podemos hacer lo siguiente
podemos crear una variable de entorno en el sideCarcontainer que haga referencia el nombre del pod con fieldRef o referencia de campo
en el mismo nivel que command

env:
- name: POD_NAME
    valueFrom:
      fieldRef: # en una variable de entorno podemos guardar el valor de cualquier campo de este pod con fieldRef 
        fieldPath: metadata.name # en este caso el nombre del pod con fieldPath

o por el nombre del serviceAccount si corremos

$ kubectl get pod -o yaml

vamos a encontrar la etiqueta spec.serviceAccountName , podemos usarla para especificar de donde viene el valor de la variabla

- name: POD_SERVICE_ACCOUNT
    valueFrom:
      fieldRef:
        fieldPath: spec.serviceAccountName

o incluso por el podIp

- name: POD_IP
    valueFrom:
      fieldRef:
        fieldPath: status.podIP

vemos que aunque la sección pod se crea después de crear el pod en el cluster , es capaz de leer este campo y tomar su valor como variable de entorno

y modificamos el command del sidecar

command: ["sh","-c" ,"while true; do echo sync app logs; printenv POD_NAME POD_SERVICE_ACCOUNT POD_IP ; sleep 20; done"]

para imprimir estas variables de entorno

o podemos pasar este comando como argumentos

quedando así

command: ["sh","-c"]
args:
- while true ; do
    echo sync app logs; 
    printenv POD_NAME POD_SERVICE_ACCOUNT POD_IP ;
    sleep 20;
  done


$ kubectl logs nginx-bf8c66d45-bcgnp -c log-sidecar

se repetirá este output cada 20 segundos

sync app logs
nginx-bf8c66d45-bcgnp
default
10.244.2.72

el echo , nombre del pod , nombre del serviceaccount y la ip del pod


