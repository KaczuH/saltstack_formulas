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


{% for pyenv_version, virtualenvs in salt['pillar.get']('virtualenv:pyenvs', []) %}
python-{{ pyenv_version }}:
  pyenv.installed:
    - require:
      - pkg: pyenv-deps

{% for virtualenv_name in virtualenvs %}
/var/www/.virtualenvs/{{ virtualenv_name }}:
  virtualenv.managed:
    - python: /usr/local/pyenv/versions/{{ pyenv_version }}/bin/python
    - system_site_packages: False
    - require:
      - pyenv: python-{{ pyenv_version }}
{% endfor %}
{% endfor %}
