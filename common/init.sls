globally_needed_pkgs:
  pkg.installed:
    - pkgs:
      - tesseract-ocr
      - xvfb


xvfb_service_file:
  file.managed:
    - name: /etc/systemd/system/xvfb.service
    - source: salt://common/templates/xvfb.service.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: globally_needed_pkgs


xvfb:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: xvfb_service_file
    - watch:
      - file: xvfb_service_file


/opt/applications/lead_bot/lead_bot/geckodriver.log:
  file.managed:
    - mode: 646
    - require:
      - file: repo_chown