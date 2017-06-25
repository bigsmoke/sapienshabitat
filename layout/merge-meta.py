#!/usr/bin/env python3

import argparse
import json
import sys


json.loads(sys.stdin)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Enrich JSON meta-data with JSON taxonomy data.')
    parser.add_argument('taxonomy_file')
