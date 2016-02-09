#!/usr/bin/python2

import yaml
import os
import argparse

def assert_file_exists_and_write_yaml(filename, yamldata):
    if not os.path.exists(os.path.dirname(filename)):
        try:
            os.makedirs(os.path.dirname(filename))
        except OSError as exc: # Guard against race condition
            if exc.errno != errno.EEXIST:
                raise

    with open(filename, "w") as f:
        f.write(yaml.dump(yamldata, default_flow_style=False))

def get_config_yaml_data():
    data_path = os.environ.get('SNAP_APP_DATA_PATH')
    app_path = os.environ.get('SNAP_APP_PATH')

    if not data_path or not app_path:
        print('$SNAP_APP_DATA_PATH or $SNAP_APP_PATH is not defined')
        sys.exit(1)

    config_path = os.path.join(data_path, 'config', 'config.yaml')
    data = None
    if os.path.isfile(config_path):
        with open(config_path, 'r') as f:
            data = yaml.load(f)
    else:
        # no config written yet. Take default and write it in data path
        with open(os.path.join(app_path, 'config', 'default_config.yaml'), 'r') as f:
            data = yaml.load(f)
        assert_file_exists_and_write_yaml(config_path, data)
    return data

def print_current_config():
    data = get_config_yaml_data()
    print(data)


def set_new_config(newfile):
    config_path = os.path.join(data_path, 'config', 'config.yaml')
    data = None
    with open(newfile, 'r') as f:
        data = yaml.load(f)
    # no checks for now, simply write the new config
    assert_file_exists_and_write_yaml(config_path, data)

def retrieve_config_val(key):
    data = get_config_yaml_data()

    try:
        val = data['config']['ethereum'][key]
    except:
        print("Could not find key {} in the configuration file".format(key))
        sys.exit(1)

    print(val)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Configure script for ethereum framework.')
    parser.add_argument(
        'new_config',
        type=file,
        nargs='?',
        help='The new config yaml file to load'
    )
    parser.add_argument(
        '--extra-geth-args',
        action='store_true',
        help='Retrieve any extra arguments to send to geth from the configuration'
    )
    args = parser.parse_args()


    if args.new_config:
        set_new_config()
    elif args.extra_geth_args:
        retrieve_config_val('extra_geth_args')
    else:
        print_current_config()
