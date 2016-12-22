# Change log

## Release 2.0.0

This release has backward-incompatible changes.

* Support Ubuntu, CentOS, and OpenBSD
* Add an integration test
* Rework on `elasticsearch.yml`

### Introducing `elasticsearch_config` and `elasticsearch_config_default`

New variable, `elasticsearch_config`, is a dict of `elasticsearch.yml`.
`elasticsearch_config_default` has default keys and values.
`elasticsearch_config` can override `elasticsearch_config_default`. At least,
you should define the following keys and values to run `elasticsearch`.

| Key            | Value                  |
|----------------|------------------------|
| `node.name`    | `hostname` of the node |
| `cluster.name` | name of the cluster    |

Note that, when overriding `network.host`, you should include `_local_` as the
role relies on the assumption that the service is listening on 127.0.0.1.

## Release 1.0.1

* bugfix: variable cannot be used in include

## Release 1.0.0

* Initail release
