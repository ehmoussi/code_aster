# coding: utf-8

import platform
import code_aster
from code_aster.Commands import *

code_aster.init(debug=True)

test = code_aster.TestCase()

# calling DEBUT/init another time must not fail
DEBUT()

from code_aster.Utilities.ExecutionParameter import ExecutionParameter
params = ExecutionParameter()

test.assertEqual( params.get_option('hostname'), platform.node())
# GreaterEqual because of multiplicative factor running testcases
# timelimit = 123. - 10% (default time saved)
test.assertGreaterEqual( params.get_option('tpmax'), 123 * 0.9)

params.set_option('tpmax', 60.)
test.assertEqual( params.get_option('tpmax'), 60)

# FIN does nothing: done when libaster is lost
FIN()

test.printSummary()
