{% from 'django/map.jinja' import django with context %}

node_env_prod:
  environ.setenv:
    - name: NODE_ENV
    - value: production

{% for project_name, config in django.projects.items() %}
{{ project_name }}_install_package_json:
  module.run:
    - name: npm.install
    - dir: {{ config['root_dir'] }}
    - require:
      - pkg: node_install


{{ project_name }}_webpack_compile_statics:
  cmd.run:
    - name: webpack --optimize-minify --optimize-dedupe --bail
    - cwd: {{ config['root_dir'] }}
    - require:
      - module: install_webpack
      - environ: node_env_prod
{% endfor %}
