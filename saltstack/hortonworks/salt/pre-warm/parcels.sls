install_parcels:
  cmd.script:
    - name: salt://pre-warm/tmp/pre_warm_parcels
    - template: jinja
    - env:
      - OS: {{ pillar['OS'] }}
      - PRE_WARM_PARCELS: '{{ pillar['PRE_WARM_PARCELS'] }}'
      - PARCELS_ROOT: {{ pillar['PARCELS_ROOT'] }}
    - output_loglevel: DEBUG
    - timeout: 9000
    - failhard: True
