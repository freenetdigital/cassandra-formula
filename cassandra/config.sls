{% from "cassandra/map.jinja" import cassandra with context %}

include:
  - cassandra

cassandra_config_yaml:
  file.managed:
    - name: /etc/cassandra/cassandra.yaml
    - source: salt://cassandra/files/cassandra_{{ cassandra.series }}.yaml
    - template: jinja
    - require:
      - pkg: cassandra
    - watch_in:
      - service: cassandra

cassandra_config_rackdc:
  file.managed:
    - name: /etc/cassandra/cassandra-rackdc.properties
    - source: salt://cassandra/files/cassandra-rackdc.properties
    - template: jinja
    - require:
      - pkg: cassandra
    - watch_in:
      - service: cassandra

disable_swap:
  cmd.run:
    - name: swapoff -a && sed -i '/lv_swap/d' /etc/fstab
    - onlyif: grep lv_swap /etc/fstab

cassandra_service:
  service.dead:
    - name: cassandra
      enable: False

cassandra_systemd_service:
  file.managed:
    - name: /etc/systemd/system/cassandra-systemd.service
    - source: salt://cassandra/files/cassandra-systemd.service
    - mode: 644
    - user: root
    - group: root
    - makedirs: True
  service.runnning:
    - name: cassandra-systemd
      enable: True

cassandra_disable_transparent_huge_pages:
  cmd.run:
    - name: echo "never" > /sys/kernel/mm/transparent_hugepage/defrag
    - unless: ls /etc/systemd/system/disable-transparent-hugepage.conf
  file.managed:
    - name: /etc/systemd/system/disable-transparent-hugepage.conf
    - source: salt://cassandra/files/disable-transparent-hugepage.conf
    - mode: 644
    - user: root
    - group: root
    - makedirs: True

