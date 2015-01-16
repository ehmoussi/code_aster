from distutils.core import setup
from Cython.Build import cythonize


setup(
    name = "Code_Aster cython",
    ext_modules = cythonize('code_aster_cython/*.pyx'),
    options={'build_ext': {'inplace': True, }}
)
