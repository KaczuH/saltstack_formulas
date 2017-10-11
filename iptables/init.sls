fw_pkgs:
  pkg.installed:
    - pkgs:
      - conntrack
      - iptables-persistent

default_to_accept:
  iptables.set_policy:
    - chain: INPUT
    - policy: ACCEPT

Already_existing:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: conntrack
    - ctstate: ESTABLISHED,RELATED
    - save: True

Accept_ssh:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - dport: 22
    - proto: tcp
    - save: True

Accept_http:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - dport: 80
    - proto: tcp
    - save: True

Accept_https:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - dport: 443
    - proto: tcp
    - save: True


accept_loopback:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - i: lo
    - save: True

drop_remaining_traffic:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - save: True
