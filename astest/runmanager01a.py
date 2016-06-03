#!/usr/bin/python

import platform
import code_aster

from code_aster.Supervis import executionParameter as EP
from code_aster.RunManager.Initializer import finalize

test = code_aster.TestCase()

test.assertEqual( EP.get('hostname'), platform.node())
test.assertEqual( EP.get('tpmax'), 86400)

EP.set('tpmax', 60.)
test.assertEqual( EP.get('tpmax'), 60)


finalize()

# a second call (or the call atexit) must not fail
finalize()

test.printSummary()
