#!/usr/bin/env python
# coding: utf-8

"""
Generate automodule blocks.
"""

EPILOG = """
EXAMPLES:
    Generate a file like ``supervis.rst``::

        python generate_rst.py code_aster/__init__.py code_aster/Supervis/*.py

    Generate files for *DataStructure* and derivated subclasses::

        python generate_rst.py --objects
"""

import argparse
from collections import OrderedDict
from glob import glob
import os
import os.path as osp


automodule_block = \
""".. automodule:: {0}
   :show-inheritance:
   :members:
   :special-members: __init__
""".format

autoclass_block = \
""".. autoclass:: code_aster.Objects.{0}
   :show-inheritance:
   :members:
""".format

auto_documentation = \
""".. AUTOMATICALLY CREATED BY generate_rst.py - DO NOT EDIT MANUALLY!

.. _devguide-{link}:

{intro}

{content}
""".format

title_ds = \
"""
********************************************************************************
:py:class:`~code_aster.Objects.{0}` subclasses
********************************************************************************
""".format

title_ds_alone = \
"""
********************************************************************************
:py:class:`~code_aster.Objects.{0}` object
********************************************************************************
""".format

subtitle = \
"""
================================================================================
:py:class:`~code_aster.Objects.{0}` object
================================================================================
""".format


def automodule(filename):
    """Return a block to document a module."""
    name = osp.splitext(filename)[0].replace('/', '.')
    return automodule_block(name)

def all_objects(destdir):
    """Generate sphinx blocks for all libaster objects."""
    import code_aster.Objects as OBJ

    boost_instance = OBJ.DataStructure.mro()[1]
    boost_enum = OBJ.Physics.mro()[1]

    # sections: directly derivated from Boost.Python.instance
    sections = [OBJ.DataStructure, OBJ.GeneralMaterialBehaviour]
    addsect = []
    for name, obj in list(OBJ.__dict__.items()):
        if not isinstance(obj, type):
            continue
        if obj.mro()[1] is boost_instance:
            addsect.append((name, obj))
    for _, obj in sorted(addsect):
        sections.append(obj)
    sections.append(boost_enum)
    sections.append(Exception)
    # print(len(sections), "sections")

    # dict of subclasses
    dictobj = OrderedDict([(i, []) for i in sections])
    for name, obj in list(OBJ.__dict__.items()):
        # if obj is not OBJ.Material:
        #     continue
        if not isinstance(obj, type) or issubclass(obj, OBJ.OnlyParallelObject):
            continue
        found = False
        for subtyp in sections:
            if issubclass(obj, subtyp) or obj is subtyp:
                dictobj[subtyp].append(name)
                found = True
                # print("Found:", name ,">>>", subtyp)
                break
        if not found:
            raise KeyError("Boost class not found: {0}".format(obj.mro()))

    dicttext = OrderedDict()
    for subtyp, objs in list(dictobj.items()):
        typename = subtyp.__name__
        lines = []
        # put subclass first
        try:
            objs.remove(typename)
        except ValueError:
            if subtyp not in (boost_enum, Exception):
                print(subtyp)
                raise
        objs.sort()
        if subtyp not in (boost_enum, Exception):
            objs.insert(0, typename)

        if len(objs) > 1:
            lines.append(title_ds(typename))
        else:
            lines.append(title_ds_alone(typename))
        for name in objs:
            if typename in ('DataStructure', 'GeneralMaterialBehaviour'):
                lines.append(subtitle(name))
            lines.append(autoclass_block(name))

        dicttext[typename] = os.linesep.join(lines)

    # generate a page for each of the first two classes
    with open(osp.join(destdir, "objects_datastructure.rst"), "w") as fobj:
        params = dict(link="objects_datastructure",
                      content=dicttext["DataStructure"],
                      intro="")
        fobj.write(auto_documentation(**params))

    with open(osp.join(destdir, "objects_materialbehaviour.rst"), "w") as fobj:
        params = dict(link="objects_materialbehaviour",
                      content=dicttext["GeneralMaterialBehaviour"],
                      intro="")
        fobj.write(auto_documentation(**params))

    # generate a page for all other classes
    with open(osp.join(destdir, "objects_others.rst"), "w") as fobj:
        params = dict(link="objects_others",
                      content=os.linesep.join(list(dicttext.values())[2:]),
                      intro=\
"""
####################################
Index of all other available objects
####################################

Documentation of all other types.
""")
        fobj.write(auto_documentation(**params))


def main():
    default_dest = osp.join(osp.dirname(__file__), "devguide")
    parser = argparse.ArgumentParser(
        description=__doc__,
        epilog = EPILOG,
        formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('--objects', action='store_true',
                        help='for C++ only objects (needs to import libaster)')
    parser.add_argument('-d', '--destdir', action='store', metavar='DIR',
                        default=default_dest,
                        help='directory where `rst` files will be written')
    parser.add_argument('file', metavar='FILE', nargs='*',
                        help='file to analyse')
    args = parser.parse_args()

    if args.objects:
        all_objects(args.destdir)
    else:
        for name in args.file:
            print(automodule(name))


if __name__ == '__main__':
    main()
