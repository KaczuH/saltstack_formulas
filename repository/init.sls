bitbucket.com:
  ssh_known_hosts:
    - present
    - user: root
    - enc: rsa
    - fingerprint: 97:8c:1b:f2:6f:14:6b:5c:3b:ec:aa:46:46:74:7c:40
    - fingerprint_hash_type: md5


repo_chown:
  file.directory:
    - name: /opt/applications
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode

deployment_private_key:
  file.managed:
    - name: /root/.ssh/id_rsa
    - contents_pillar: repository:deployment_keys:private_key
    - user: root
    - group: root
    - mode: 600

deployment_public_key:
  file.managed:
    - name: /root/.ssh/id_rsa.pub
    - contents_pillar: repository:deployment_keys:public_key
    - user: root
    - group: root
    - mode: 644

#deployment_add_identity:
#  cmd.run:
#    - name: ssh-add /root/.ssh/id_rsa
#    - require:
#      - file: deployment_private_key

