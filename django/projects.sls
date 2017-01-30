{% from 'django/map.jinja' import django with context %}

{% for project_name, config in django.projects.items() %}
{{ project_name }}_settings_file:
  file.managed:
    - name: {{ salt['pillar.get']('django:project_root') }}/credits/{{ salt['pillar.get']('django:settings_filename') }}
    - source: salt://django/templates/settings.jinja
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 644

{{ project_name }}_static_root_directory:
  file.directory:
    - name: {{ config['root_dir'] }}/static
    - user: www-data
    - group: www-data

django_manage_collectstatic:
  module.run:
    - name: django.collectstatic
    - bin_env: {{ salt['pillar.get']('virtualenv:path') }}
    - settings_module: {{ salt['pillar.get']('django:settings_module') }}
    - pythonpath: {{ salt['pillar.get']('django:project_root') }}
    - noinput: True
    - require:
      - virtualenv: {{ salt['pillar.get']('virtualenv:path') }}
      - file: static_root_directory
      - cmd: webpack_compile_statics

django_migrate_db:
  module.run:
    - name: django.command
    - command: migrate
    - bin_env: {{ salt['pillar.get']('virtualenv:path') }}
    - settings_module: {{ salt['pillar.get']('django:settings_module') }}
    - pythonpath: {{ salt['pillar.get']('django:project_root') }}

{% endfor %}
