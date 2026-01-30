#!/usr/bin/env python3

import sys
import yaml
import configparser
import os

INPUT_FILE = "/tmp/config/mopidy-input.yaml"
OUTPUT_FILE = "/etc/mopidy/mopidy.conf"

def convert():
    if not os.path.exists(INPUT_FILE):
        print(f"Error: {INPUT_FILE} does not exist")
        sys.exit(1)

    try:
        with open(INPUT_FILE, 'r') as f:
            data = yaml.safe_load(f)

        if data is None:
            data = {}

        config = configparser.ConfigParser()
        config.optionxform = str

        for section, settings in data.items():
            if not isinstance(settings, dict):
                continue

            config.add_section(section)

            for key, value in settings.items():
                if isinstance(value, bool):
                    val_str = str(value).lower()
                elif value is None:
                    val_str = ""
                else:
                    val_str = str(value)

                config.set(section, key, val_str)

        os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
        with open(OUTPUT_FILE, 'w') as f:
            config.write(f)

        print(f"Success: Configuration converted to {OUTPUT_FILE} (INI format)")

    except Exception as e:
        print(f"Error during conversion: {e}")
        sys.exit(1)

if __name__ == "__main__":
    convert()
