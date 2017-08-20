#!/usr/bin/env python3

import argparse
import json
import sys


def merge_meta(meta1, meta2):
    assert isinstance(meta1, dict)
    assert isinstance(meta2, dict)
    for meta2_field_name, meta2_field_value_or_values in meta2.items():
        if meta2_field_name in meta1:
            if isinstance(meta2_field_value_or_values, list):
                # This work both when the meta values in meta1 are or are not already lists
                meta1[meta2_field_name] = meta1[meta2_field_name] + meta2_field_value_or_values
            elif isinstance(meta1[meta2_field_name], list):
                assert not isinstance(meta2_field_value_or_values, list)
                meta1[meta2_field_name].append(meta2_field_value_or_values)
            else:
                assert not isinstance(meta2_field_value_or_values, list)
                assert not isinstance(meta1[meta2_field_name], list)
                meta1[meta2_field_name] = [meta1[meta2_field_name], meta2_field_value_or_values]
        else:
            meta1[meta2_field_name] = meta2_field_value_or_values
    return meta1


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Enrich JSON meta-data with JSON taxonomy data.')
    parser.add_argument('taxonomy_file')
    args = parser.parse_args()

    unmerged_meta = json.load(sys.stdin)
    merged_meta = unmerged_meta.copy()

    if 'published' in merged_meta and not 'date' in merged_meta:
        merged_meta['date'] = merged_meta['published']
    if not 'published' in merged_meta:
        merged_meta['draft'] = merged_meta.get('draft', True)

    unmerged_taxonomy = unmerged_meta['taxonomy']
    with open(args.taxonomy_file, 'r') as taxonomy_file:
        taxonomy_data = json.load(taxonomy_file)
    for taxonomy_key, term_key_or_keys in unmerged_taxonomy.items():
        term_keys = term_key_or_keys if isinstance(term_key_or_keys, list) else [term_key_or_keys]
        for term_key in term_keys:
            extra_meta_data_from_taxonomy = taxonomy_data[taxonomy_key][term_key]
            merge_meta(merged_meta, extra_meta_data_from_taxonomy)

    print(json.dumps(merged_meta, indent=4))
