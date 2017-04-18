
from code_aster cimport libaster
from code_aster.libaster cimport INTEGER

def python_execop(pynumop):
    cdef INTEGER numOp = pynumop
    libaster.execop_(&numOp)
