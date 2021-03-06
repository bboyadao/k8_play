```
helm install nfs nfs-ganesha-server-and-external-provisioner/nfs-server-provisioner \
  --values ./storage/nfs_provi/values.yaml \
  --v=9

helm install ingress ingress-nginx/ingress-nginx \
  --version 4.0.16 \
  --values ingress/values.yaml \
  --v=9

kaf ingress/controller.yaml

kaf app/k8s

cd metallb
helm install metallb metallb/metallb -f values.yaml

helm install postgresql bitnami/postgresql-ha\
        --version 8.5.3\
        --set postgresql.pgHbaTrustAll=true\
        --set volumePermissions.enabled=true\
        --set postgresqlImage.debug=true\
        --set postgresql.password=admin123\
        --set postgresql.repmgrPassword=admin123\
        --set postgresql.replicaCount=4\
        --set persistence.enabled=true\
        --set persistence.storageClass=standard\
        --set postgresqlImage.repository=bitnami/postgresql-repmgr\
        --set postgresqlImage.tag=12.5.0-debian-10-r18

/opt/bitnami/scripts/postgresql-repmgr/entrypoint.sh repmgr -f /opt/bitnami/repmgr/conf/repmgr.conf node check
/opt/bitnami/scripts/postgresql-repmgr/entrypoint.sh repmgr -f /opt/bitnami/repmgr/conf/repmgr.conf cluster show --compac
/opt/bitnami/scripts/postgresql-repmgr/entrypoint.sh repmgr -f /opt/bitnami/repmgr/conf/repmgr.conf standby promote

CREATE DATABASE django_test;
CREATE USER postgres WITH PASSWORD 'admin123';
ALTER ROLE postgres SET timezone TO 'UTC';
ALTER ROLE postgres SET default_transaction_isolation TO 'read committed';
ALTER ROLE postgres SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE django_test TO postgres;

export CHUTHE_ENV="LOCAL"

echo "URL : amqp://127.0.0.1:5672/"
    kubectl port-forward --namespace default svc/rabbitmq 5672:5672

echo "Username      : user"
    echo "Password      : $(kubectl get secret --namespace default rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 --decode -w 0)"
    echo "ErLang Cookie : $(kubectl get secret --namespace default rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 --decode -w 0)"

```

