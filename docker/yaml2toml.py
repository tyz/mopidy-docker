#!/usr/bin/env python3
import sys
import yaml
import toml
import os

INPUT_FILE = "/tmp/config/mopidy-input.yaml"
OUTPUT_FILE = "/etc/mopidy/mopidy.conf"

def convert():
    if not os.path.exists(INPUT_FILE):
        print(f"ERROR: {INPUT_FILE} does not exist")
        sys.exit(1)

    try:
        with open(INPUT_FILE, 'r') as f:
            data = yaml.safe_load(f)

        if data is None:
            print("WARNING: Empty YAML file")
            data = {}

        os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)

        with open(OUTPUT_FILE, 'w') as f:
            toml.dump(data, f)

        print(f"Success: file saved as {OUTPUT_FILE}")

    except Exception as e:
        print(f"Error during conversion:: {e}")
        sys.exit(1)

if __name__ == "__main__":
    convert()
