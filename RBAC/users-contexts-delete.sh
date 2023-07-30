#modificar nombre de usuario para crear en el cluster
user=roberto
csrExpire=864000 #damos una validez de 10 días en segundos
cluster="minikube"
namespace="dev" 
embed=false

#borramos usuario
kubectl config delete-user ${user}

#borramos contexto
kubectl config delete-context ${user}-context

#borramos a mano el directorio de usuario
#sudo rm -rf ./user-name