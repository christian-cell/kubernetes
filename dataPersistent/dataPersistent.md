Para hacer que la data de la base de datos persista cuando un pod muere tenemos 3 diferentes recursos en kubernetes
PersistentVolume : pv
PersistentVolumeClaim: pvc
StorageClass : sc

cualquiera de estos han de ser accesibles desde cualquier nodo del cluster porque cuando un pod muere el siguiente pod
si no especificamos el nodeSelector puede ser programado en cualquier otro nodo y este nuevo pod debe tener acceso
a esta data , estos recursos también deben ser persistentes incluso si el cluster crashea .

El storage es externo al cluster , como un disco local o un servidor nfs o cualquier espacio provisto por el proveedor de cloud, pero dentro del cluster se encuentran estos 3 recursos como una interfaz para poder
acceder a esos storages

con NFS al dentro del spec de un persistentVolume podemos definir el path del nfs

nfs:
  path: /dir/path/on/nfs/server
  server: nfs-server-ip-address

google cloud storate

gcPersistentDisk:
  pdName: my-data-disk
  fsType: ext4

local-storage

storageClassName: local-storage
local:
  path: /mnt/disks/ssdl
nodeAffinity:
  required:
    nodeSelectorTerms:
    - matchExpressions:
      - key: kubernetes.io/hostname
        operator: In
        values:
        - example-node

en cambio un pvc debe ser montado en el pod para este poder tener acceso a esa data

los claim deben ser creados en el mismo namespace que los pods que accedan a el , de esta manera evitamos que otras aplicaciones puedan acceder a el

esto no quita para que otro namespace tenga un pv o un pvc que pueda acceder también a ese storage pero con su propio pv o pvc
