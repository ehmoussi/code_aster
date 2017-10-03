#!/usr/bin/python
# coding: utf-8

"""
Unittest for CommandSyntax.
"""

import platform
import code_aster
from code_aster.Cata.Commands.debut import DEBUT as cata
from code_aster.Supervis import CommandSyntax

code_aster.init(debug=True)

test = code_aster.TestCase()

syntax = CommandSyntax("DEBUT", cata)
test.assertEqual(syntax.getName(), "DEBUT")

catadef = cata.definition
test.assertIn('INFO', catadef.simple_keywords)
test.assertNotIn('INFO', catadef.factor_keywords)
test.assertIn('CODE', catadef.factor_keywords)
test.assertNotIn('CODE', catadef.simple_keywords)

userkw = _F(IMPR_MACRO='OUI',
            ERREUR=_F(ERREUR_F='EXCEPTION'),
            RESERVE_CPU=_F(POURCENTAGE=0.20),
            IGNORE_ALARM=("alarm1", "alarm22", "alarm333", "alarm4444"),
            INFO=2)

syntax.setResult("result", "type")
test.assertEqual(syntax.getResultName(), "result")
test.assertEqual(syntax.getResultType(), "type")
test.assertSequenceEqual(syntax.getres(), ("result", "type", "DEBUT"))


syntax.define(userkw)
test.assertEqual(syntax.getFactorKeywordNbOcc("ERREUR"), 1)

test.assertTrue(syntax.getexm("CODE", "NIV_PUB_WEB"))
test.assertTrue(syntax.getexm("", "IMPR_MACRO"))
test.assertFalse(syntax.getexm(" ", "CODE"))
test.assertFalse(syntax.getexm("ERREUR", "ALARM"))

size, length = syntax.getltx("", "IGNORE_ALARM", 0, 3, 7)
test.assertEqual(size, -4)
test.assertSequenceEqual(length, [6, 7, 7])

size, length = syntax.getltx("", "LANG", 0, 3, 7)
test.assertEqual(size, 0)
test.assertSequenceEqual(length, [])

# fake test of getvid with strings
size, value, isdef = syntax.getvid("", "IGNORE_ALARM", 0, 3)
test.assertEqual(size, -4)
test.assertSequenceEqual(value, ["alarm1", "alarm22", "alarm333"])
test.assertEqual(isdef, 0)

size, value, isdef = syntax.getvtx("", "IGNORE_ALARM", 999, 6)
test.assertEqual(size, 4)
test.assertSequenceEqual(value, ["alarm1", "alarm22", "alarm333", "alarm4444"])
test.assertEqual(isdef, 0)

size, value, isdef = syntax.getvis("", "INFO", 999, 1)
test.assertEqual(size, 1)
test.assertSequenceEqual(value, [2])
test.assertEqual(isdef, 0)

size, value, isdef = syntax.getvr8("RESERVE_CPU", "POURCENTAGE", 0, 1)
test.assertEqual(size, 1)
test.assertSequenceEqual(value, [0.2])
test.assertEqual(isdef, 0)

kws, types = syntax.getmjm("RESERVE_CPU", 0, 99)
test.assertEqual(len(kws), len(types))
test.assertEqual(len(kws), 2)
test.assertSequenceEqual(kws, ["POURCENTAGE", "BORNE"])
test.assertSequenceEqual(types, ["R8", "IS"])

test.printSummary()
