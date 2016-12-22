# import from the latest ansible tree

from ansible import errors
from ansible.parsing.yaml.dumper import AnsibleDumper
import yaml

def to_nice_yaml(a, indent=4, *args, **kw):
    '''Make verbose, human readable yaml'''
    transformed = yaml.dump(a, Dumper=AnsibleDumper, indent=indent, allow_unicode=True, default_flow_style=False, **kw)
    return transformed
class FilterModule(object):
    def filters(self):
        return {
                'to_nice_yaml' : to_nice_yaml,
                }
