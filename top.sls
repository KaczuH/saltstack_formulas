base:
  '*':
    - users.common
    - openssh
    - fail2ban
  'scw-632b42':
    - users.celery
    - nginx
    - postgres
    - virtualenv
    - repository
    - uwsgi
    - django
    - redis
    - celery
  'lead-base':
    - nginx
    - postgres
    - virtualenv
    - repository
    - uwsgi
    - django
