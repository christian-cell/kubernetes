Generamos una clave privada para un user
$ openssl genrsa -out roberto.key

Generamos certificate signing request a partir de esta clave privada
$ openssl req -new -key roberto.key -out roberto.csr

para generarlo sin preguntas
$ openssl req -new -key roberto.key --subj="/CN=roberto" -out roberto.csr

obtenemos el contenido del csr en base64
$ cat roberto.csr | base64 | tr -d "\n"
y lo ponemos en la propiedad requests en el archivo certificate-signing-requests.yml

aplicamos el csr dentro del cluster
$ kubectl apply -f certificate-signing-request.yml

lo listamos
$ kubectl get csr
si todo fue bien ,veremos que esta en estado pending

lo aprobamos dentro del cluster , "kubectl certificate approve <nombre_del_csr>"
$ kubectl certificate approve roberto

guardamos el csr creado en el cluster en un manifiesto  llamado roberto-csr-created.yml
$ kubectl get csr/roberto -o yaml > roberto-csr-created.yml

obtenemos el .crt del csr que recien hemos tirado en el cluster
$ kubectl get csr roberto -o jsonpath='{.status.certificate}'| base64 -d > roberto.crt

anadimos el usuario al contexto del cluster
$ kubectl config set-credentials roberto --client-key=roberto.key --client-certificate=roberto.crt --embed-certs=false

creamos un contexto para el usuario recien creado
$ kubectl config set-context roberto-context --cluster=minikube --namespace=dev --user=roberto



