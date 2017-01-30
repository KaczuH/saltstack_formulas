pyenv-deps:
  pkg.installed:
    - pkgs:
      - make
      - build-essential
      - libssl-dev
      - zlib1g-dev
      - libbz2-dev
      - libreadline-dev
      - libsqlite3-dev
      - wget
      - curl
      - llvm
      - python-virtualenv
      - git


{% for pyenv_version, virtualenvs in salt['pillar.get']('virtualenv:pyenvs', []).items() %}
python-{{ pyenv_version }}:
  pyenv.installed:
    - require:
      - pkg: pyenv-deps

{% for virtualenv_name, conf in virtualenvs.items() %}
/var/www/.virtualenvs/{{ virtualenv_name }}:
  virtualenv.managed:
    - python: /usr/local/pyenv/versions/{{ pyenv_version }}/bin/python
    - system_site_packages: False
{% if conf and conf['requirements'] %}
    - requirements: {{ conf['requirements'] }}
{% endif %}
    - require:
      - pyenv: python-{{ pyenv_version }}


pip_{{ virtualenv_name }}:
  pip.installed:
    bin_env: /var/www/.virtualenvs/{{ virtualenv_name }}
{% if conf and conf['requirements'] %}
    - requirements: {{ conf['requirements'] }}
{% endif %}
{% endfor %}
{% endfor %}
