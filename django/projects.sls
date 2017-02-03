{% from 'django/map.jinja' import django with context %}

{% for project_name, config in django.projects.items() %}
{{ project_name }}_settings_file:
  file.managed:
    - name: {{ config['project_root'] }}/{{ project_name }}/{{ config['settings_filename'] }}
    - source: salt://django/templates/settings.jinja
    - context:
        settings: {{ config['settings'] }}
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 644

{{ project_name }}_static_root_directory:
  file.directory:
    - name: {{ config['static_root'] }}
    - user: www-data
    - group: www-data

{{ project_name }}_media_root_directory:
  file.directory:
    - name: {{ config['media_root'] }}
    - user: www-data
    - group: www-data

{{ project_name }}_django_manage_collectstatic:
  module.run:
    - name: django.collectstatic
    - bin_env: {{ config.virtualenv_path }}
    - settings_module: {{ config.settings_module }}
    - pythonpath: {{ config.project_root }}
    - noinput: True
    - require:
      - file: {{ project_name }}_static_root_directory

{{ project_name }}_django_migrate_db:
  module.run:
    - name: django.command
    - command: migrate
    - bin_env: {{ config.virtualenv_path }}
    - settings_module: {{ config.settings_module }}
    - pythonpath: {{ config.project_root }}

{% endfor %}
