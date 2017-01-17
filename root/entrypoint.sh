#!/bin/sh

if [ "$1" = "init" ];then
    ansible-playbook -i /etc/ansible/hosts /etc/ansible/entrypoint.yml -c local
fi
if [ "$1" = "wallabag" ];then
    ansible-playbook -i /etc/ansible/hosts /etc/ansible/entrypoint.yml -c local --skip-tags=firstrun
    unset POSTGRES_PASSWORD
    unset MYSQL_ROOT_PASSWORD
    exec s6-svscan /etc/s6/
fi
if [ "$1" = "import" ];then
    ansible-playbook -i /etc/ansible/hosts /etc/ansible/entrypoint.yml -c local --skip-tags=firstrun
    cd /var/www/wallabag/
    exec su -c "bin/console wallabag:import:redis-worker -e=prod $2 -vv" -s /bin/sh nobody
fi

exec "$@"
