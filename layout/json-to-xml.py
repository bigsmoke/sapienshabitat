#!/usr/bin/env python3

# Python
import sys
import json
from xml.dom.minidom import parseString

# 3rd-party
from dicttoxml import dicttoxml


d = json.loads(sys.stdin.read())
xml = dicttoxml(d)
dom = parseString(xml)
print(dom.toprettyxml())
