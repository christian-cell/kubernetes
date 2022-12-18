Buscamos en la propia línea de comandos por el nombre de un chart en concreto

por ejemplo wordpress

$ helml search hub wordpress

viendo todos los fabricantes que hacen helm como bitnami y las urls de cada una de las opciones
entramos en la url del que deseamos e instalamos ese

$ helm repo add <nombre_que_le_quieras_dar_al_repo> https://charts.bitnami.com/bitnami

ejemplo

$ helm repo add bitnami https://charts.bitnami.com/bitnami

para instalar wordpress de bitnami lo podemos hacer con usa serie de configuraciones que podemos  ver con el siguiente comando

$ helm show values <nombre_que_le_diste_a_este_repo>/wordpress

ejemplo

$ helm show values bitnami/wordpress

y guardarlas en un .txt por ejemplo

$ helm show values bitnami/wordpress > wordpressconfig.txt

podemos configurar estos valores desde la linea de comandos

$ helm install wordpress-dev bitnami/wordpress --wordpressUsername=admin --wordpressPassword="secret"

o desde un archivo de configuracion

como wordpress_specific_config.yaml

$ helm install wordpress-dev -f wordpress_specific_config.yaml bitnami/wordpress

vemos los servicios , pod y deployments que esto ha creado en el cluster

$ kubectl get pod -A

para ver todas los charts instalados 

$ helm list

para encontrar deploymets de helm pendientes en el cluster

$ helm list --pending -A

para borrar la instalación

$ helm delete <nombre_de_la_instalacion>

$ helm delete wordpress-dev

PARA CREAR UN CHART PROPIO

$ helm create miapp

esto crea una carpeta miapp y dentro de esta si hacemos ls -la vemos la estructura básica de un chart de helm

en el directorio "charts" se guardan otros charts de los que nuestro chart dependa , chart.yaml es la información
del nombre del chart , el nombre del autor etc ... , values.yaml todas las variables que el que instale nuestra app
pueda almacenar

modifico los valores de values.yaml

metemos en NOTES.txt toda la info que queramos que se muestre en la terminal cuando se instala el chart

