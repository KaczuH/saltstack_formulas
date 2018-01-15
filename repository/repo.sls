{% for repo_url, config in salt['pillar.get']('repository:repositories').items() %}
{{ repo_url }}:
  git.latest:
    - rev: {{ config.rev }}
    - target: {{ config.target }}
    - force_checkout: True
    - force_reset: True
    - identity: /root/.ssh/id_rsa
    - require:
      - ssh_known_hosts: bitbucket.com
#      - file: deployment_private_key
#      - file: deployment_public_key

{{ config.uwsgi_ini }}:
  file.touch:
    - onchanges:
      - git: {{ repo_url }}
{% endfor %}
