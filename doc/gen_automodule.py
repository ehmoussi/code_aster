#!/usr/bin/env python
# coding: utf-8

"""%prog [options]

Generate automodule blocks.


gen_automodule.py code_aster/__init__.py code_aster/{Objects,Supervis,RunManager,Utilities}/*.py
"""

import os.path as osp
import argparse
from glob import glob


def automodule(filename):
    name = osp.splitext(filename)[0].replace('/', '.')
    fmt = \
""".. automodule:: {0}
   :show-inheritance:
   :members:
   :special-members: __init__
"""
    return fmt.format(name)

def main():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-g', '--debug', action='store_true',
                        help='print debug informations')
    parser.add_argument('file', metavar='FILE', nargs='+',
                        help='file to analyse')
    args = parser.parse_args()

    for name in args.file:
        print automodule(name)


if __name__ == '__main__':
    main()
