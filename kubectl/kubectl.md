Para obtener varios recursos en un mismo comando de kubectl 

$ kubectl get pod/<nombre_pod> svc/<nombre_sevicio>

también podemos listar todos los servicios y pods por ejemplo de un ns determinado

$ kubectl get svc,pod -n default

o de todos los ns

$ kubectl get svc,pod -A
