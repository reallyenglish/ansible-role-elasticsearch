# ansible-role-elasticsearch

Install and configure elasticsearch.

# Requirements

- ansible-role-redhat-repo (for CentOS only)
- ansible-role-java

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `elasticsearch_user` | user name of `elasticsearch` | `{{ __elasticsearch_user }}` |
| `elasticsearch_group` | group name of `elasticsearch` | `{{ __elasticsearch_group }}` |
| `elasticsearch_package` | package name of `elasticsearch` | `{{ __elasticsearch_package }}` |
| `elasticsearch_path_conf` | path to `elasticsearch.yml` | `{{ __elasticsearch_path_conf }}` |
| `elasticsearch_plugin_command` | path to `plugin` command | `{{ __elasticsearch_plugin_command }}` |
| `elasticsearch_plugins_dir` | path to `plugin` directory | `{{ __elasticsearch_plugins_dir }}` |
| `elasticsearch_plugins_to_add` | dict of plugins to install (see below) | `{}` |
| `elasticsearch_plugin_timeout` | value for `--timeout` when installing plugins | `30m` |
| `elasticsearch_config_default` | dict of default settings | (see below)
| `elasticsearch_config` | dict of `elasticsearch.yml` that overrides `elasticsearch_config_default` | `{}` |
| `elasticsearch_jvm_options` | options to pass `java` | `[]` |
| `elasticsearch_jvm_options_openbsd` | in OpenBSD, `elasticsearch_jvm_options` cannot set some options. see below | `{}` |


## `elasticsearch_config_default`

```yaml
elasticsearch_config_default:
  path.data: "{{ __elasticsearch_path_data }}"
  path.logs: "{{ __elasticsearch_path_logs }}"
  node.master: "true"
  node.data: "true"
  http.port: 9200
  http.compression: "true"
  network.host:
    - _local_
    - _site_
```

## `elasticsearch_plugins_to_add`

| Key | Value |
|-----|-------|
| URL of the plugin file (e.g. `royrusso/elasticsearch-HQ`) | Name of plugin (e.g. `hq`) |

## `elasticsearch_jvm_options_openbsd` (OpenBSD only)

The following Java options cannot be set by using `elasticsearch_jvm_options`. Use
`elasticsearch_jvm_options_openbsd` instead.

| Option | Key in `elasticsearch_jvm_options_openbsd` |
|--------|--------------------------------------------|
| -Xms | `ES_MIN_MEM` |
| -Xmx | `ES_MAX_MEM` |
| -Xmn | `ES_HEAP_NEWSIZE` |
| -XX:MaxDirectMemorySize | `ES_DIRECT_SIZE` |
| -Djava.net.preferIPv4Stack | `ES_USE_IPV4` |
| -Xloggc | `ES_GC_LOG_FILE` |

```yaml
elasticsearch_jvm_options_openbsd:
  ES_MIN_MEM: 512m
  ES_MAX_MEM: 2g
```

See `/etc/elasticsearch/elasticsearch.in.sh` for details.

## Debian

| Variable | Default |
|----------|---------|
| `__elasticsearch_user` | `elasticsearch` |
| `__elasticsearch_group` | `elasticsearch` |
| `__elasticsearch_package` | `elasticsearch` |
| `__elasticsearch_path_conf` | `/etc/elasticsearch` |
| `__elasticsearch_path_data` | `/var/lib/elasticsearch` |
| `__elasticsearch_path_logs` | `/var/log/elasticsearch` |
| `__elasticsearch_plugin_command` | `/usr/share/elasticsearch/bin/plugin` |
| `__elasticsearch_plugins_dir` | `/usr/share/elasticsearch/plugins` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__elasticsearch_user` | `elasticsearch` |
| `__elasticsearch_group` | `elasticsearch` |
| `__elasticsearch_package` | `elasticsearch2` |
| `__elasticsearch_path_conf` | `/usr/local/etc/elasticsearch` |
| `__elasticsearch_path_data` | `/var/db/elasticsearch` |
| `__elasticsearch_path_logs` | `/var/log/elasticsearch` |
| `__elasticsearch_plugin_command` | `/usr/local/bin/elasticsearch-plugin` |
| `__elasticsearch_plugins_dir` | `/usr/local/lib/elasticsearch/plugins` |

## OpenBSD

| Variable | Default |
|----------|---------|
| `__elasticsearch_user` | `_elasticsearch` |
| `__elasticsearch_group` | `_elasticsearch` |
| `__elasticsearch_package` | `elasticsearch` |
| `__elasticsearch_path_conf` | `/etc/elasticsearch` |
| `__elasticsearch_path_data` | `/var/elasticsearch` |
| `__elasticsearch_path_logs` | `/var/log/elasticsearch` |
| `__elasticsearch_plugin_command` | `/usr/local/elasticsearch/bin/plugin` |
| `__elasticsearch_plugins_dir` | `/usr/local/elasticsearch/plugins` |

## RedHat

| Variable | Default |
|----------|---------|
| `__elasticsearch_user` | `elasticsearch` |
| `__elasticsearch_group` | `elasticsearch` |
| `__elasticsearch_package` | `elasticsearch` |
| `__elasticsearch_path_conf` | `/etc/elasticsearch` |
| `__elasticsearch_path_data` | `/var/lib/elasticsearch` |
| `__elasticsearch_path_logs` | `/var/log/elasticsearch` |
| `__elasticsearch_plugin_command` | `/usr/share/elasticsearch/bin/plugin` |
| `__elasticsearch_plugins_dir` | `/usr/share/elasticsearch/plugins` |



# elasticsearch\_plugins\_to\_add

    elasticsearch_plugins_to_add:
      $argument_for_plugin_command:
        name: $the_plugin_name

$argument\_for\_plugin\_command can be:

* royrusso/elasticsearch-HQ (github)
* royrusso/elasticsearch-HQ/v1.0.0 (with version)
* file:///path/to/plugin.zip (local file)
* org.elasticsearch.plugin/mapper-attachments/3.0.0 (Maven)

see https://www.elastic.co/guide/en/elasticsearch/plugins/2.3/installation.html

$the\_plugin\_name can be found by `plugin list` after `plugin install`.

# Dependencies

* reallyenglish.redhat-repo
* reallyenglish.java

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - role: reallyenglish.redhat-repo
      when: ansible_os_family == "RedHat"
    - role: reallyenglish.apt-repo
      when: ansible_os_family == "Debian"
    - ansible-role-elasticsearch
  vars:
    elasticsearch_config:
      cluster.name: testcluster
      node.name: testnode
      discovery.zen.ping.multicast.enabled: "false"
      discovery.zen.ping.unicast.hosts:
        - 10.0.2.15
      network.publish_host:
        - 10.0.2.15
      http.cors.enabled: "true"
      http.cors.allow-origin: "*"
      http.cors.max-age: 86400
      http.cors.allow-methods: "OPTIONS, HEAD, GET, POST, PUT, DELETE"
      http.cors.allow-headers: "X-Requested-With, Content-Type, Content-Length"
      http.cors.allow-credentials: "true"
    elasticsearch_plugins_to_add:
      royrusso/elasticsearch-HQ/v2.0.3:
        name: hq
    elasticsearch_jvm_options:
      - -XX:+UseCompressedOops
    elasticsearch_jvm_options_openbsd:
      ES_MIN_MEM: 257m
      ES_MAX_MEM: 1024m

    redhat_repo:
      elastic_co:
        description: Elasticsearch repository for 2.x packages
        baseurl: https://packages.elastic.co/elasticsearch/2.x/centos
        gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch
        gpgcheck: yes
        enabled: yes
    apt_repo_to_add: "{% if ansible_distribution == 'Ubuntu' and ansible_distribution_version | version_compare('16.04', '<') %}ppa:webupd8team/java{% endif %}"
```

# License

```
Copyright (c) 2016 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
