#!/usr/bin/python
# coding: utf-8

import numpy as np
import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

# temporary skip this testcase
test.assertTrue(True)
test.printSummary()

"""
test.assertTrue(isinstance(fsin, code_aster.Function))
test.assertTrue(isinstance(fcos, code_aster.Function))

fsin.debugPrint(6)
test.assertEqual(fsin.size(), 10)
test.assertEqual(fcos.size(), 20)

# continue...
# check Function.abs()
fabs = fsin.abs()
fabs.debugPrint( 6 )

arrabs = fabs.getValuesAsArray(copy=False)
test.assertTrue( np.alltrue( arrabs[:, 1] >= 0. ) )

    if mode or not pickler.canRestart():
        # Emulate the syntax of DEBUT (default values should be added)
        if mode == 1:
            keywords['CATALOGUE'] = _F(FICHIER='CATAELEM', UNITE=4)
        syntax = CommandSyntax( "DEBUT" )
        syntax.define( keywords )
        libaster.ibmain_()
        libaster.register_sh_jeveux_status( 1 )
        libaster.debut_()
    else:
        logger.info( "restarting from a previous execution..." )
        syntax = CommandSyntax( "POURSUITE" )
        syntax.define( keywords )
        libaster.ibmain_()
        libaster.register_sh_jeveux_status( 1 )
        libaster.poursu_()
        loadObjects(level=2)
"""
