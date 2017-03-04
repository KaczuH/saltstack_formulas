{% from 'celery/map.jinja' import celery with context %}

celery_config_directory:
  file.directory:
    - name: /etc/celery/conf.d
    - user: root
    - group: root
    - makedirs: True

celery_log_directory:
  file.directory:
    - name: /var/log/celery
    - user: celery
    - group: celery


{% for worker_name, config in celery.workers.items() %}

{{ worker_name }}_log_file:
  file.managed:
    - name: /var/log/celery/{{ worker_name }}.log
    - user: celery
    - group: celery
    - require:
        - user: users_celery_user
        - file: celery_log_directory

{{ worker_name }}_celery_worker:
  file.managed:
    - name: /etc/celery/conf.d/{{ worker_name }}_celery
    - source: salt://celery/templates/celery.jinja
    - context:
        settings: {{ config['settings'] }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: celery_config_directory

{{ worker_name }}_systemd_unit_file:
  file.managed:
    - name: /etc/systemd/system/{{ worker_name }}_celery.service
    - source: salt://celery/templates/celery.service.jinja
    - context:
        working_directory: {{ config['working_directory'] }}
        worker_name: {{ worker_name }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: celery_config_directory
      - file: {{ worker_name }}_celery_worker

{{ worker_name }}_celery:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: {{ worker_name }}_systemd_unit_file

{% endfor %}