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

{% for pyenv_version in pillar.get('virtualenv:pyenvs') %}
python-{{ pyenv_version }}:
  pyenv.installed:
    - require:
      - pkg: pyenv-deps
{% endfor %}
