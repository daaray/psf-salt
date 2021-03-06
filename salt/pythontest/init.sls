include:
  - nginx

mercurial:
  pkg.installed

/srv/:
  file.directory:
    - user: www-data
    - group: www-data

testdata-repo:
  hg.latest:
    - name: https://hg.python.org/pythontestdotnet
    - target: /srv/python-testdata/
    - user: www-data
    - watch_in:
      - service: nginx
  require:
    - pkg: mercurial
    - file: /srv/

chmod-testdata:
  cmd.run:
    - name: chmod -R o+r /srv/python-testdata/
    - onchanges:
      - hg: testdata-repo

/etc/nginx/sites.d/pythontest.conf:
  file.managed:
    - source: salt://pythontest/config/nginx.pythontest.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
  require:
    - file: /etc/nginx/sites.d/
    - hg: testdata-repo
