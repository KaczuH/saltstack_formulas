globally_needed_pkgs:
  pkg.installed:
    - pkgs:
      - tesseract-ocr
      - xvfb

# Should not be necessary since using pyvirtualdisplay
#xvfb_service_file:
#  file.managed:
#    - name: /etc/systemd/system/xvfb.service
#    - source: salt://common/templates/xvfb.service.jinja
#    - template: jinja
#    - user: root
#    - group: root
#    - mode: 644
#    - require:
#      - pkg: globally_needed_pkgs
#
#
#xvfb:
#  service.running:
#    - enable: True
#    - reload: True
#    - require:
#      - file: xvfb_service_file
#    - watch:
#      - file: xvfb_service_file


/opt/applications/lead_bot/lead_bot/geckodriver.log:
  file.managed:
    - mode: 664
    - require:
      - file: repo_chown

firefox_ppa:
  pkgrepo.managed:
    - humanname: Firefox PPA
    - ppa: jonathonf/firefox-esr
#    - name: deb http://security.debian.org/ stretch/updates main
#    - file: /etc/apt/sources.list.d/debian-mozilla.list
#    - key_url: https://mozilla.debian.net/archive.asc

firefox_esr:
  pkg.installed:
    - pkgs:
#      - libgtk-3-0
#      - libhunspell-1.4-0
#      - libjsoncpp1
#      - libvpx4
      - firefox-esr

geckodriver_file:
  archive.extracted:
    - source: https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-linux64.tar.gz
    - name: /usr/bin
    - skip_verify: True
    - enforce_toplevel: False
