{% from 'celery/map.jinja' import celery with context %}

celery_config_directory:
  file.directory:
    - name: /etc/celery/conf.d
    - user: root
    - group: root
    - makedirs: True

{% for worker_name, config in celery.workers.items() %}

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
        settings: {{ config['working_directory'] }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: celery_config_directory
      - file: {{ worker_name }}_celery_worker

{% endfor %}