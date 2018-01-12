set_java_home_user:
  file.managed:
    - name: /etc/profile.d/java.sh
    - mode: 755
    - contents: |
        export JAVA_HOME={{ pillar['JAVA_HOME'] }}

{% if grains['init'] == 'systemd' -%}
set_java_home_systemd:
  file.replace:
    - name: /etc/systemd/system.conf
    - pattern: \#+DefaultEnvironment=.*
    - repl: DefaultEnvironment=JAVA_HOME={{ pillar['JAVA_HOME'] }}
{% endif %}

{% if grains['os'] == 'RedHat' and grains['osmajorrelease'] | int == 7 %}
enable_redhat_rhui_repos:
  file.replace:
    - name: /etc/yum.repos.d/redhat-rhui.repo
    - pattern: '^enabled=[0,1]'
    - repl: 'enabled=1'
{% endif %}

install_openjdk:
  pkg.installed:
    - pkgs: {{ pillar['openjdk_packages'] }}

{% if grains['os_family'] == 'Debian' %}
create_jvm_symlink:
  file.symlink:
    - name: /usr/lib/jvm/java
    - target: /usr/lib/jvm/java-{{ pillar['openjdk_version'] }}-openjdk-amd64
{% endif %}

add_openjdk_gplv2:
  file.managed:
    - name: /usr/lib/jvm/OpenJDK_GPLv2_and_Classpath_Exception.pdf
    - source: salt://java/usr/lib/jvm/OpenJDK_GPLv2_and_Classpath_Exception.pdf

run_java_sh:
  cmd.run:
    - name: source /etc/profile.d/java.sh
