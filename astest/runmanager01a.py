#!/usr/bin/python
# coding: utf-8

import platform
import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

# calling DEBUT/init another time must not fail
DEBUT()

from code_aster.Supervis.ExecutionParameter import ExecutionParameter
params = ExecutionParameter()

test.assertEqual( params.get_option('hostname'), platform.node())
# because of multiplicative factor running testcases
test.assertGreaterEqual( params.get_option('tpmax'), 123)

params.set_option('tpmax', 60.)
test.assertEqual( params.get_option('tpmax'), 60)

# FIN does nothing: done when libaster is lost
FIN()

test.printSummary()
