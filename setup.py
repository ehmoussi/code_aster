# coding: utf-8

import os
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext


def scandir(dir, files=[]):
    """Scan the 'code_aster' directory for extension files, converting
    them to extension names in dotted notation"""
    for file in os.listdir(dir):
        path = os.path.join(dir, file)
        if os.path.isfile(path) and path.endswith(".pyx"):
            files.append(path.replace(os.path.sep, ".")[:-4])
        elif os.path.isdir(path):
            scandir(path, files)
    return files


def makeExtension(extName):
    """Generate an Extension object from its dotted name"""
    extPath = extName.replace(".", os.path.sep) + ".pyx"
    return Extension(
        extName,
        [extPath],
        language="c++",
        include_dirs=["."],   # adding the '.' to include_dirs is CRUCIAL!!
        # extra_compile_args = ["-g", "-Wall"],
        # extra_link_args = ['-g'],
        libraries=["aster", ],
    )

# get the list of extensions
extNames = scandir("code_aster_cython")

# and build up the set of Extension objects
extensions = [makeExtension(name) for name in extNames]

# finally, we can pass all this to distutils
setup(
    name="Code_Aster with Cython",
    ext_modules=extensions,
    cmdclass={'build_ext': build_ext},
    script_args=['build_ext'],
    options={'build_ext': {'inplace': True, }}
)
