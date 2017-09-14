#!/usr/bin/python

import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

tab = CREA_TABLE(LISTE=_F(PARA='X', LISTE_I=(1, 2, 3)),
                 TITRE='test title')

test.assertEqual(tab['X', 2], 2)

title = tab.TITRE()
print "DEBUG:", repr(title)
test.assertEqual(tab.TITRE().strip(), 'test title')

test.printSummary()
