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

"""
Build script for code_aster


Note:
- All defines conditionning the compilation must be set using `conf.define()`.
  They will be exported into `asterc_config.h`/`asterf_config.h`.

- If some of them are also required during the build step, another variable
  must be passed using `env` (ex. BUILD_MED)
"""

top = '.'
out = 'build'

import os
import os.path as osp
import sys
from functools import partial
from itertools import chain

from waflib import Build, Configure, Logs, Utils
from waflib.Tools.c_config import DEFKEYS

if sys.version_info.major < 3:
    Logs.error("Python 2 is not supported anymore. "
               "Please upgrade to Python 3.5 or newer")
    sys.exit(1)


def options(self):
    orig_get_usage = self.parser.get_usage
    def _usage():
        return orig_get_usage() + os.linesep.join((
        '',
        'Environment variables:',
        '  CC             : C compiler',
        '  FC             : Fortran compiler',
        '  CXX            : C++ compiler',
        '  DEFINES        : extra preprocessor defines',
        '  LINKFLAGS      : extra linker options',
        '  CFLAGS         : extra C compilation options',
        '  FCFLAGS        : extra Fortran compilation options',
        '  LIBPATH_x, INCLUDES_x, PYPATH_x : paths for component "x" for libs, '
        'incudes, python modules',
        '  CONFIG_PARAMETERS_name=value: extra configuration parameters '
        '(for config.js)',
        '  WAFBUILD_ENV   : environment file to be included in runtime '
        'environment file',
        '  PREFIX         : default installation prefix to be used, '
        'if no --prefix option is given.',
        '  BLAS_INT_SIZE  : kind of integers to use in the fortran blas/lapack '
        'calls (4 or 8, default is 4)',
        '  MUMPS_INT_SIZE : kind of integers to use in the fortran mumps calls '
        ' (4 or 8, default is 4)',
        '  CATALO_CMD     : command line used to build the elements catalog. '
        'It is just inserted before the executable '
        '(may define additional environment variables or a wrapper that takes '
        'all arguments, see catalo/wscript)',
        '',))
    self.parser.get_usage = _usage

    self.load('use_config')
    self.load('gnu_dirs')

    # change default value for '--prefix'
    default_prefix = '../install/std'
    # see waflib/Tools/gnu_dirs.py for the group name
    group = self.get_option_group('Installation prefix')
    descr = group.get_description() or ""
    # replace path in description
    new_descr = descr.replace('/usr/local', default_prefix)
    new_descr += ". Using 'waf_variant', 'std' will be automatically replaced "\
                 "by 'variant'."
    group.set_description(new_descr)
    # reset --prefix option
    option = group.get_option('--prefix')
    if option:
        group.remove_option('--prefix')
    group.add_option('--prefix', dest='prefix', default=None,
                     help='installation prefix [default: %r]' % default_prefix)

    group = self.add_option_group('code_aster options')

    self.load('parallel', tooldir='waftools')
    self.load('python_cfg', tooldir='waftools')
    self.load('mathematics', tooldir='waftools')
    self.load('med', tooldir='waftools')
    self.load('metis', tooldir='waftools')
    self.load('parmetis', tooldir='waftools')
    self.load('mumps', tooldir='waftools')
    self.load('scotch', tooldir='waftools')
    self.load('petsc', tooldir='waftools')
    self.load('runtest', tooldir='waftools')
    self.recurse('bibfor')
    self.recurse('code_aster')
    self.recurse('run_aster')
    self.recurse('bibcxx')
    self.recurse('bibc')
    self.recurse('mfront')
    self.recurse('i18n')
    self.recurse('data')
    self.recurse('doc')
    self.recurse('astest')

    group.add_option('-E', '--embed-all', dest='embed_all',
                    action='store_true', default=False,
                    help='activate all embed-* options (except embed-python)')
    group.add_option('--enable-all', dest='enable_all',
                    action='store_true', default=os.environ.get('ENABLE_ALL'),
                    help="activate all 'enable-*' options (same as "
                         "ENABLE_ALL environment variable)")

@Configure.conf
def all_components(self):
    components = ['HDF5', 'MED', 'MFRONT', 'METIS', 'PARMETIS', 'SCOTCH',
                  'MUMPS', 'PETSC', 'PETSC4PY',
                  'MATH', 'NUMPY', 'BOOST', 'OPENMP', 'MPI', 'Z', 'CXX',
                  'ASRUN', 'PYTHON']
    return components

def configure(self):
    opts = self.options
    self.setenv('default')
    self.load('official_platforms', tooldir='waftools')

    # add environment variables into `self.env`
    self.add_os_flags('FC')
    self.add_os_flags('CC')
    self.add_os_flags('CXX')
    self.add_os_flags('CFLAGS')
    self.add_os_flags('CXXFLAGS')
    self.add_os_flags('FCFLAGS')
    self.add_os_flags('LINKFLAGS')
    self.add_os_flags('DEFINES')
    self.add_os_flags('WAFBUILD_ENV')

    for comp in self.all_components():
        self.add_os_flags('LIBPATH_' + comp)
        self.add_os_flags('INCLUDES_' + comp)
        self.add_os_flags('PYPATH_' + comp)
        if not opts.enable_all:
            continue
        if not opts.parallel and comp in ['PARMETIS', 'PETSC', 'MPI']:
            continue
        opt = "enable_" + comp.lower()
        if hasattr(opts, opt):
            setattr(opts, opt, True)

    self.env["CONFIG_PARAMETERS"] = {}
    for key in os.environ.keys():
        if not key.startswith("CONFIG_PARAMETERS_"):
            continue
        name = key.split("CONFIG_PARAMETERS_")[1]
        self.env["CONFIG_PARAMETERS"][name] = os.environ[key]

    # compute default prefix
    if self.env.PREFIX in ('', '/'):
        suffix = os.environ.get('WAF_SUFFIX', 'std')
        default_prefix = '../install/%s' % suffix
        self.env.PREFIX = osp.abspath(default_prefix)
    self.msg('Setting prefix to', self.env.PREFIX)

    self.load('ext_aster', tooldir='waftools')
    self.load('use_config')
    self.load('gnu_dirs')
    self.env['CODEASTERPATH'] = self.path.find_dir('code_aster').abspath()
    self.env['CATALOPATH'] = self.path.find_dir('catalo').abspath()

    self.set_installdirs()
    self.load('parallel', tooldir='waftools')
    self.load('python_cfg', tooldir='waftools')
    self.check_platform()

    self.load('mathematics', tooldir='waftools')

    self.env.append_value('FCFLAGS', '-fPIC')
    self.env.append_value('CFLAGS', '-fPIC')
    self.env.append_value('CXXFLAGS', '-fPIC')

    self.load('med', tooldir='waftools')
    self.load('metis', tooldir='waftools')
    self.load('parmetis', tooldir='waftools')
    self.load('mumps', tooldir='waftools')
    self.load('scotch', tooldir='waftools')
    self.load('petsc', tooldir='waftools')
    self.load('runtest', tooldir='waftools')

    self.recurse('bibfor')
    self.recurse('code_aster')
    self.recurse('run_aster')
    self.recurse('bibcxx')
    self.recurse('bibc')
    self.recurse('mfront')
    self.recurse('i18n')
    self.recurse('data')
    self.recurse('doc')
    self.recurse('astest')

    # keep compatibility for as_run
    if self.get_define('HAVE_MPI'):
        self.env.ASRUN_MPI_VERSION = 1
    # variants
    self.check_optimization_options()
    self.write_config_headers()

def build(self):
    # shared the list of dependencies between bibc/bibfor
    # the order may be important
    if not self.variant:
        self.fatal('Call "waf build_debug" or "waf build_release", and read ' \
                   'the comments in the wscript file!')
    if self.cmd.startswith('install'):
        # because we can't know which files are obsolete `rm *.py{,c,o}`
        _remove_previous(self.root.find_node(self.env.ASTERLIBDIR),
                         ['**/*.py', '**/*.pyc', '**/*.pyo'])
        _remove_previous(self.root.find_node(self.env.ASTERDATADIR),
                         ['datg/**/*', 'materiau/**/*', 'tests_data/**/*'])

    self.load('ext_aster', tooldir='waftools')
    self.recurse('bibfor')
    self.recurse('code_aster')
    self.recurse('run_aster')
    self.recurse('bibcxx')
    self.recurse('bibc')
    self.recurse('mfront')
    self.recurse('i18n')
    self.recurse('catalo')
    self.recurse('data')
    self.recurse('astest')

def build_elements(self):
    self.recurse('catalo')

def init(self):
    from waflib.Build import (BuildContext, CleanContext, InstallContext,
                              UninstallContext)
    _all = (BuildContext, CleanContext, InstallContext, UninstallContext,
            TestContext, I18NContext, DocContext)
    for x in ['debug', 'release']:
        for y in _all:
            name = y.__name__.replace('Context','').lower()
            class tmp(y):
                cmd = name + '_' + x
                variant = x
    # default to release
    for y in _all:
       class tmp(y):
           variant = 'release'

def all(self):
    from waflib import Options
    lst = ['install_release', 'install_debug']
    Options.commands = lst + Options.commands

class BuildElementContext(Build.BuildContext):
    """execute the build for elements catalog only using an installed Aster (also performed at install, for internal use only)"""
    cmd = '_buildelem'
    fun = 'build_elements'

def runtest(self):
    self.load('runtest', tooldir='waftools')

class TestContext(Build.BuildContext):
    """facility to execute a testcase"""
    cmd = 'test'
    fun = 'runtest'

def update_i18n(self):
    self.recurse('i18n')

class I18NContext(Build.BuildContext):
    """build the i18n files"""
    cmd = 'i18n'
    fun = 'update_i18n'

def build_doc(self):
    self.recurse('doc')

class DocContext(Build.BuildContext):
    """build the documentation files"""
    cmd = 'doc'
    fun = 'build_doc'

@Configure.conf
def set_installdirs(self):
    # set the installation subdirectories
    norm = lambda path : osp.normpath(osp.join(path, 'aster'))
    self.env['ASTERLIBDIR'] = norm(self.env.LIBDIR)
    self.env['ASTERINCLUDEDIR'] = norm(self.env.INCLUDEDIR)
    self.env['ASTERDATADIR'] = norm(self.env.DATADIR)
    if not self.env.LOCALEDIR:
        self.env.LOCALEDIR = osp.join(self.env.PREFIX, 'share', 'locale')
    self.env['ASTERLOCALEDIR'] = norm(self.env.LOCALEDIR)

@Configure.conf
def check_platform(self):
    self.start_msg('Getting platform')
    # convert to code_aster terminology
    os_name = self.env.DEST_OS
    if os_name == 'cygwin':
        os_name = 'linux'
    elif os_name == 'sunos':
        os_name = 'solaris'
    if self.env.DEST_CPU.endswith('64'):
        os_name += '64'
        self.define('_USE_64_BITS', 1)
    os_name = os_name.upper()
    if not os_name.startswith('win'):
        self.define('_POSIX', 1)
        self.undefine('_WINDOWS')
        self.define(os_name, 1)
    else:
        self.define('_WINDOWS', 1)
        self.undefine('_POSIX')
    self.end_msg(os_name)

@Configure.conf
def check_optimization_options(self):
    # adapt the environment of the build variants
    self.setenv('debug', env=self.all_envs['default'])
    self.setenv('release', env=self.all_envs['default'])
    # these functions must switch between each environment
    self.check_optimization_cflags()
    self.check_optimization_cxxflags()
    self.check_optimization_fcflags()
    self.check_optimization_python()
    if self.env.BUILD_CYTHON:
        self.check_optimization_cython()
    self.check_variant_vars()

@Configure.conf
def check_variant_vars(self):
    self.setenv('debug')
    self.env['_ASTERBEHAVIOUR'] = 'AsterMFrOfficialDebug'
    self.define('ASTERBEHAVIOUR', self.env['_ASTERBEHAVIOUR'])

    self.setenv('release')
    self.env['_ASTERBEHAVIOUR'] = 'AsterMFrOfficial'
    self.define('ASTERBEHAVIOUR', self.env['_ASTERBEHAVIOUR'])

# same idea than waflib.Tools.c_config.write_config_header
# but defines are not removed from `env`
# XXX see write_config_header(remove=True/False) + format Fortran ?
class ConfigHelper(object):

    def __init__(self, language):
        self._lang = language

    def cmt(self, text):
        return {
            'C': '/* {0} */',
            'Fortran': '! {0}',
            'Cython': '# {0}'
        }[self._lang].format(text)

    @property
    def filename(self):
        return {
            'C': 'asterc_config.h',
            'Fortran': 'asterf_config.h',
            'Cython': 'astercython_config.pxi'
        }[self._lang]

    @property
    def header(self):
        return [
            self.cmt("WARNING! Automatically generated by `waf configure`!")
        ]

    @property
    def guard_begin(self):
        if self._lang in ('C', 'Fortran'):
            guard = Utils.quote_define_name(self.filename)
            return ["#ifndef {0}".format(guard),
                    self.define(guard),
                    ""]
        return [""]

    @property
    def guard_end(self):
        if self._lang in ('C', 'Fortran'):
            return ["#endif", ""]
        return [""]

    def support(self, var):
        """Tell if the language supports the variable name."""
        if self._lang != 'C' and var.startswith('ASTERC'):
            return False
        if self._lang == 'Cython' and 'PETSC4PY' not in var:
            return False
        return True

    def define(self, var, value=""):
        if self._lang == 'Cython':
            fmt = 'DEF {0}' + '={1}' if value else ''
        else:
            fmt = '#define {0} {1}'
        return fmt.format(var, value)

    def undefine(self, var):
        fmt = self.cmt('#undef {0}')
        return fmt.format(var)


@Configure.conf
def write_config_headers(self):
    # Write both xxxx_config.h files for C and Fortran,
    # then remove entries from DEFINES
    for variant in ('debug', 'release'):
        self.setenv(variant)
        self.write_config_h('Fortran', variant)
        self.write_config_h('C', variant)
        if self.env.BUILD_CYTHON:
            self.write_config_h('Cython', variant)
        for key in self.env[DEFKEYS]:
            self.undefine(key)
        self.env[DEFKEYS] = []

@Configure.conf
def write_config_h(self, language, variant, configfile=None, env=None):
    # Write a configuration header containing defines
    # ASTERC defines will be used if language='C', not 'Fortran'.
    self.start_msg('Write config file')
    cfg = ConfigHelper(language)
    configfile = configfile or cfg.filename
    env = env or self.env
    lst = cfg.header
    lst.append("")
    lst.extend(cfg.guard_begin)
    lst.extend(self.get_config_h(cfg))
    lst.extend(cfg.guard_end)

    node = self.bldnode or self.path.get_bld()
    node = node.make_node(osp.join(variant, configfile))
    node.parent.mkdir()
    node.write('\n'.join(lst))
    incpath = node.parent.abspath()
    self.env.append_unique('INCLUDES', incpath)
    if language == 'Cython':
        self.env.append_unique('CYTHONFLAGS', ["-I{0}".format(incpath)])
    # config files are not removed on "waf clean"
    env.append_unique(Build.CFG_FILES, [node.abspath()])
    self.end_msg(node.bldpath())

@Configure.conf
def get_config_h(self, cfg):
    # Create the contents of a ``config.h`` file from the defines
    # set in conf.env.define_key / conf.env.include_key. No include guards are added.
    lst = []
    for x in self.env[DEFKEYS]:
        if not cfg.support(x):
            continue
        if self.is_defined(x):
            lst.append(cfg.define(x, self.get_define(x)))
        else:
            lst.append(cfg.undefine(x))
    lst.append("")
    return lst


def _remove_previous(install_node, patterns):
    # used to remove previously installed files (that are just copied to dest)
    if not install_node:
        return

    for pattern in patterns:
        for i in install_node.ant_glob(pattern):
            os.remove(i.abspath())
