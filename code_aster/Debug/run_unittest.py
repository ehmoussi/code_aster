# coding=utf-8

"""
Unittests of the code_aster package

..  code-block:: sh

    python code_aster/run_unittest.py
"""

import sys
import os
import os.path as osp
import unittest


def _build_suite():
    """Build the suite of testcases of the package"""
    suite = unittest.TestSuite()
    ldr = unittest.defaultTestLoader
    suite.addTests( ldr.discover( osp.dirname( osp.dirname( __file__ ) ),
                    pattern='_unittest.py' ) )
    return suite

def _main():
    """Run unittests"""
    verb = 1
    if '-v' in sys.argv:
        verb = 2

    initfile = 'aster_init_options.py'
    assert not osp.exists(initfile), \
        "Remove '{}' or run from another directory".format(initfile)
    open(initfile, 'wb').write("options = ['MANUAL', ]\n")

    unittest.TextTestRunner( verbosity=verb ).run( _build_suite() )
    os.remove(initfile)


if __name__ == '__main__':
    _main()
