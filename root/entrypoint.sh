#!/bin/sh

if [ "$1" = "wallabag" ];then
    ansible-playbook -i /etc/ansible/hosts /etc/ansible/entrypoint.yml -c local
    exec s6-svscan /etc/s6/
fi
if [ "$1" = "import:pocket" ];then
    ansible-playbook -i /etc/ansible/hosts /etc/ansible/entrypoint.yml -c local --skip-tags=firstrun
    su -c "bin/console wallabag:import:redis-worker -e=prod pocket -vv" -s /bin/sh nobody
fi

exec "$@"
