# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

import sys
import os
import os.path as osp
from functools import partial
from subprocess import Popen, PIPE
from distutils.version import LooseVersion

from waflib import Options, Configure, Errors, Utils

def options(self):
    self.load('python')    # --nopyc/--nopyo are enabled below

def configure(self):
    self.check_python()
    self.check_numpy()
    self.check_asrun()

###############################################################################
@Configure.conf
def check_python(self):
    self.load('python')
    self.check_python_version((3, 5, 0))
    self.check_python_headers()
    if 'icc' in self.env.CC_NAME.lower():
        pyflags=['-Wno-unused-result', '-Wsign-compare', '-march', '-mtune', '-ftree-vectorize',
                 '-fstack-protector-strong', '-fno-plt', '-ffunction-sections', '-pipe', '-fuse-linker-plugin',
                 '-ffat-lto-objects', '-flto-partition', '-flto', '-fdebug-prefix-map', '-fPIC', '-O']
        self.env['LIB_PYEXT'] = list(set(self.env['LIB_PYEXT']))
        for lang in ('CFLAGS', 'CXXFLAGS'):
            self.remove_flags(lang + '_PYEXT', pyflags)

@Configure.conf
def check_numpy(self):
    self.check_numpy_module()
    self.check_numpy_version((1, 4, 0))
    self.check_numpy_headers()

@Configure.conf
def check_numpy_module(self):
    if not self.env['PYTHON']:
        self.fatal('load python tool first')
    # getting python module
    self.start_msg('Checking for numpy')
    self.check_python_module('numpy')
    import numpy
    self.end_msg(numpy.__file__)

@Configure.conf
def check_numpy_headers(self):
    if not self.env['PYTHON']:
        self.fatal('load python tool first')
    self.start_msg('Checking for numpy include')
    # retrieve includes dir from numpy module
    numpy_includes = self.get_python_variables(
        ['"\\n".join(misc_util.get_numpy_include_dirs())'],
        ['from numpy.distutils import misc_util'])
    # check the given includes dirs
    self.check(
                     feature = 'c',
                 header_name = 'Python.h numpy/arrayobject.h',
                    includes = numpy_includes,
                     defines = 'NPY_NO_PREFIX',
                         use = ['PYEXT'],
                uselib_store = 'NUMPY',
        errmsg='Could not find the numpy development headers'
    )
    self.end_msg(numpy_includes)

@Configure.conf
def check_numpy_version(self, minver=None):
    """Check if the numpy module is found matching a given minimum version.
    minver should be a tuple, eg. to check for numpy >= 1.4 pass (1,4,0) as minver.
    """
    if not self.env['PYTHON']:
        self.fatal('load python tool first')
    assert isinstance(minver, tuple)
    cmd = self.env['PYTHON'] + ['-c', 'import numpy; print(numpy.__version__)']
    res = self.cmd_and_log(cmd)
    npyver = res.strip()
    if minver is None:
        self.msg('Checking for numpy version', npyver)
        return
    minver_str = '.'.join(map(str, minver))
    result = LooseVersion(npyver) >= LooseVersion(minver_str)
    self.msg('Checking for numpy version', npyver, ">= %s" % (minver_str,) and 'GREEN' or 'YELLOW')

    if not result:
        self.fatal('The NumPy version is too old, expecting %r' % (minver,))

@Configure.conf
def check_asrun(self):
    if not self.env['PYTHON']:
        self.fatal('load python tool first')
    # getting python module
    self.start_msg('Checking for asrun')
    try:
        self.check_python_module('asrun')
        import asrun
        self.end_msg(asrun.__file__)
    except Errors.WafError:
        self.end_msg("no", "YELLOW")

@Configure.conf
def check_optimization_python(self):
    self.setenv('debug')
    self.env['PYC'] = self.env['PYO'] = 0
    self.setenv('release')
    self.env['PYC'] = self.env['PYO'] = 0

def _get_default_pythonpath(python):
    """Default sys.path should be added into PYTHONPATH"""
    env = os.environ.copy()
    env['PYTHONPATH'] = ''
    proc = Popen([python, '-c', 'import sys; print(sys.path)'],
                 stdout=PIPE, env=env)
    system_path = eval(proc.communicate()[0])
    return system_path
