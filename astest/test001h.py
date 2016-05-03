#!/usr/bin/python
# coding: utf-8

# check the manual start using the '--no-start' option

import code_aster
test = code_aster.TestCase()

from code_aster import executionParameter
# default value (hard value in libExecutionParameter)
test.assertEqual( executionParameter.get('memory'), 1000. )

print ">>> code_aster imported but not started, change a parameter"
executionParameter.set('memory', 2000.)

print ">>> manual start"
from code_aster.RunManager import Initializer

# this will fail if the execution did not start with '--no-start' option
Initializer.init(0)

from code_aster import executionParameter
test.assertEqual( executionParameter.get('memory'), 2000. )

test.printSummary()
