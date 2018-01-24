
node_install:
  pkg.installed:
    - pkgs:
      - nodejs
      - nodejs-legacy
      - npm

install_webpack:
  module.run:
    - name: npm.install
    - pkg: webpack
    - require:
      - pkg: node_install
