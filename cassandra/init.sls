{% from "cassandra/map.jinja" import cassandra with context %}

cassandra:
  pkg.installed:
    - name: {{ cassandra.pkg }}

  service.running:
    - name: cassandra
    - enable: True
    - require:
      - pkg: cassandra

  pkgrepo.managed:
    - humanname: Cassandra
    - name: deb https://downloads.apache.org/cassandra/debian {{ cassandra.series }} main
    - file: /etc/apt/sources.list.d/cassandra.list
    - keyid: {{ cassandra.keyid }}
    - keyserver: {{ cassandra.keyserver }}
    - require_in:
      - pkg: cassandra

  cassandra_disable_transparent_huge_pages:
    cmd.run:
      - name: echo "never" > /sys/kernel/mm/transparent_hugepage/defrag

