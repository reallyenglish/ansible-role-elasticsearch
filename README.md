ansible-role-elasticsearch
=============

Install and configure elasticsearch.

Requirements
------------

None

Role Variables
--------------

| variable | description | default |
| elasticsearch\_cluster\_name | cluster.name, required | "" |
| elasticsearch\_node\_name | node.name, required | "" |
| elasticsearch\_path\_data | path.data | "/var/db/elasticsearch" |
| elasticsearch\_path\_log | path.log | "/var/log/elasticsearch" |
| elasticsearch\_network\_host | network.host | "\_\_site\_\_" |
| elasticsearch\_http\_port | http.port | 9200 |
| elasticsearch\_http\_compression | http.compression | "true" |
| elasticsearch\_node\_master | node.master | "true" |
| elasticsearch\_node\_data | node.data | "true" |

Dependencies
------------

None

Example Playbook
----------------

    - hosts: all
      roles:
        - ansible-role-elasticsearch
      vars:
        elasticsearch_cluster_name: testcluster
        elasticsearch_node_name: testnode

License
-------

BSD

Author Information
------------------

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
