import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

TCPU = INFO_EXEC_ASTER(LISTE_INFO='TEMPS_RESTANT')
remaining = TCPU['TEMPS_RESTANT', 1]
test.assertGreater(remaining, 30.)
test.assertLess(remaining, 9999.)

tab = INFO_EXEC_ASTER(LISTE_INFO='ETAT_UNITE', FICHIER='file1')
state = tab['ETAT_UNITE', 1].strip()
test.assertEqual(state, 'FERME')

unit = DEFI_FICHIER(ACTION='ASSOCIER', FICHIER='file1', ACCES='NEW')
test.assertEqual(unit, 99)

tab = INFO_EXEC_ASTER(LISTE_INFO='ETAT_UNITE', FICHIER='file1')
state = tab['ETAT_UNITE', 1].strip()
test.assertEqual(state, 'OUVERT')

DEFI_FICHIER(ACTION='LIBERER', UNITE=unit)

tab = INFO_EXEC_ASTER(LISTE_INFO='ETAT_UNITE', FICHIER='file1')
state = tab['ETAT_UNITE', 1].strip()
test.assertEqual(state, 'FERME')

test.printSummary()

FIN()
