# ansible-role-elasticsearch

Install and configure elasticsearch.

# Requirements

- ansible-role-redhat-repo (for CentOS only)

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

## `elasticsearch_config_default`

```yaml
elasticsearch_config_default:
  path.data: "{{ __elasticsearch_path_data }}"
  path.logs: "{{ __elasticsearch_path_logs }}"
  node.master: "true"
  mode.data: "true"
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

None

# Example Playbook

```yaml
- hosts: all
  roles:
    - ansible-role-elasticsearch
  vars:
    elasticsearch_cluster_name: testcluster
    elasticsearch_node_name: testnode
    elasticsearch_plugins_to_add:
      royrusso/elasticsearch-HQ:
        name: hq
    elasticsearch_http_cors_enabled: "true"
    elasticsearch_http_cors_allow_origin: '"*"'
    elasticsearch_http_cors_max_age: 86400
    elasticsearch_http_cors_allow_methods: "OPTIONS, HEAD, GET, POST, PUT, DELETE"
    elasticsearch_http_cors_allow_headers: "X-Requested-With, Content-Type, Content-Length"
    elasticsearch_http_cors_allow_credentials: "true"
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
