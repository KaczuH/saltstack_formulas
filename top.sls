base:
  '*':
    - users
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
    - nginx.ng
    - postgres
    - virtualenv
    - repository
    - uwsgi
    - django
