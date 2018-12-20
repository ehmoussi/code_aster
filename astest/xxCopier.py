import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("ssnv185u.mmed")

MA2= COPIER(CONCEPT= MA)

test.assertTrue( True )

FIN()
