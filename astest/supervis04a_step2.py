#!/usr/bin/python
# coding: utf-8

import code_aster

code_aster.init("--continue")

test = code_aster.TestCase()

# 'CHMAT' has been deleted: not yet supported
with test.assertRaises(NameError):
    CHMAT

# 'BLOCAGE' has been deleted: not yet supported
with test.assertRaises(NameError):
    BLOCAGE

test.assertTrue(MAIL.hasGroupOfElements("BLOK"))
test.assertTrue(MAIL.hasGroupOfElements("VOL"))

support = MODELE.getSupportMesh()
test.assertTrue(support.hasGroupOfElements("VOL"))
del support

test.printSummary()
