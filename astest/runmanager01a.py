#!/usr/bin/python

import platform
import code_aster

from code_aster.Supervis import executionParameter
from code_aster.RunManager.Initializer import finalize

test = code_aster.TestCase()

test.assertEqual( executionParameter.get_option('hostname'), platform.node())
test.assertEqual( executionParameter.get_option('tpmax'), 86400)

executionParameter.set_option('tpmax', 60.)
test.assertEqual( executionParameter.get_option('tpmax'), 60)


finalize()

# a second call (or the call atexit) must not fail
finalize()

test.printSummary()
