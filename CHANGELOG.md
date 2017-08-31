# Change log

## Release 2.0.5

* f8249f8 [bugfix] ignore dead Java process in status check (#32)

## Release 2.0.4

* f219a56 [bugfix] use new format (#29)

## Release 2.0.3

* 6731b93 [bugfix] make role soft-depend on reallyenglish.redhat-repo and reallyenglish.apt-repo (#27)
* b8f09e4 [bugfix] remove to_nice_yaml (#26)

## Release 2.0.2

* 73cf6a7 [bugfix] fix hq version (#24)

## Release 2.0.1

* [bug fix] fix wrong permissions on files (#21)

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

### new dependency

The role depends on `reallyenglish.java` on all platforms and
`reallyenglish.redhat-repo` on RedHat.

## Release 1.0.1

* bugfix: variable cannot be used in include

## Release 1.0.0

* Initail release
