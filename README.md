# ansible-role-elasticsearch

Install and configure elasticsearch.

# Requirements

None

# Role Variables

| variable | description | default |
|----------|-------------|---------|
| elasticsearch\_cluster\_name | cluster.name, required | "" |
| elasticsearch\_node\_name | node.name, required | "" |
| elasticsearch\_path\_data | path.data | "/var/db/elasticsearch" |
| elasticsearch\_path\_log | path.log | "/var/log/elasticsearch" |
| elasticsearch\_network\_host | network.host | "\_\_site\_\_" |
| elasticsearch\_http\_port | http.port | 9200 |
| elasticsearch\_http\_compression | http.compression | "true" |
| elasticsearch\_node\_master | node.master | "true" |
| elasticsearch\_node\_data | node.data | "true" |
| elasticsearch\_discovery\_zen\_ping\_multicast\_enabled | discovery.zen.ping.multicast.enabled | "false" |
| elasticsearch_network_publish_host| discovery.zen.ping.multicast.enabled | [] |
| elasticsearch_network_publish_host | network.publish_host | [] |

| elasticsearch\_plugin\_command | path to plugin command |  "{{ \_\_elasticsearch\_plugin\_command }}" |
| elasticsearch\_plugins\_dir | path to plugin directory | "{{ \_\_elasticsearch\_plugins\_dir }}" |
| elasticsearch\_plugins\_to\_add | a hash of plugins to install | {} |
| elasticsearch\_plugin\_timeout | timeout value for `plugin`. note that `plugin install` fails when downloading the file, not connecting to remote, exceeds the value | 30m |

| elasticsearch\_http\_cors\_enabled | http.cors.enabled | "false" |
| elasticsearch\_http\_cors\_allow\_origin | http.cors.allow-origin | "" |
| elasticsearch\_http\_cors\_max\_age | http.cors.max-age | 1728000 |
| elasticsearch\_http\_cors\_allow\_methods | http.cors.allow-methods | "" |
| elasticsearch\_http\_cors\_allow\_headers | http.cors.allow-headers | "" |
| elasticsearch\_http\_cors\_allow\_credentials | http.cors.allow-credentials | "false" |

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
