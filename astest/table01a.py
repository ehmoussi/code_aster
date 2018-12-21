#!/usr/bin/python

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

tab = CREA_TABLE(LISTE=_F(PARA='X', LISTE_I=(1, 2, 3)),
                 TITRE='test title')

test.assertEqual(tab['X', 2], 2)

with test.assertRaises(RuntimeError):
    tab[8]

with test.assertRaises(KeyError):
    tab['U', 55]

test.assertEqual(tab.get_nom_para(), ['X'])

title = tab.TITRE()
test.assertEqual(tab.TITRE().strip(), 'test title')

pytab = tab.EXTR_TABLE()
test.assertEqual(len(pytab), 3)

test.printSummary()

FIN()
