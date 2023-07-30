#modificar nombre de usuario para crear en el cluster
user=roberto
csrExpire=864000 #damos una validez de 10 días en segundos
cluster="minikube"
namespace="dev" 
embed=false

#creamos un directorio para el usuario
mkdir "${user}"

#entramos en el
cd "${user}"

#creamos una key privada para ese usuario
openssl genrsa -out "${user}".key 2048
#cat "${user}".key


#creamos la peticion de firma del certificado csr
openssl req -new -key "${user}".key --subj="/CN=${user}" -out "${user}".csr

#guardamos dentro de una variable el valor del csr en base64
csrB64Encoded=$(cat "${user}".csr | base64 | tr -d "\n")

echo ${csrB64Encoded} | base64 -d
#exit 0


#creamos el recurso de kubernetes CertificateSigninRequest
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: "${user}"
spec:
  request: "${csrB64Encoded}"
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: ${csrExpire}  # one day
  usages:
  - client auth
EOF

#listamos los csr para ver que se ha creado con exito
kubectl get csr

#aprobamos el csr generado en el cluster
kubectl certificate approve "${user}"

#listamos los csr para ver que se aprobó
kubectl get csr

#generamos el .crt del usuario
kubectl get csr "${user}" -o jsonpath='{.status.certificate}'| base64 -d > "${user}".crt

#añadimos el usuario y su contexto al cluster
kubectl config set-credentials ${user} --client-key="${user}".key --client-certificate="${user}".crt --embed-certs="${embed}"

#listamos los usuarios
kubectl config get-users

#creamos el contexto a partir de este usuario
kubectl config set-context "${user}"-context --cluster="${cluster}" --namespace="${namespace}" --user="${user}"

#mostramos contextos
kubectl config get-contexts

#switch al nuevo contexto
kubectl config set-context "${user}"-context

# testeamos el nuevo contexto Forbidden = todo ha salido bien , connection refuse tenemos algún paso mal
kubectl get pod