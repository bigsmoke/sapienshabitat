#!/usr/bin/env python3

# Python
import sys
import json

# 3rd-party
import yaml

struct = yaml.load(sys.stdin)
print(json.dumps(struct, indent=4))
