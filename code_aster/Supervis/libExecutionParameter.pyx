# coding: utf-8

# Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

from libc.stdio cimport stdout, setvbuf, _IOLBF

import json
import os
import os.path as osp
import platform
import re
import sys

from Execution.strfunc import convert
import aster_pkginfo

from code_aster.Supervis.logger import logger, setlevel
from code_aster.Supervis.libBaseUtils import to_cstr
from code_aster.Supervis.libBaseUtils cimport copyToFStr


class ExecutionParameter:
    """This class stores and provides the execution parameters.

    The execution parameters are defined by reading the command line or using
    the method `set_option()`.
    """

    def __init__(self):
        """Initialization of attributes"""
        self._args = {}
        self._args['debug'] = 0
        self._args['dbgjeveux'] = 0

        self._args['memory'] = 0.
        self._args['maxbase'] = 0
        self._args['tpmax'] = 0.
        self._args['numthreads'] = 0

        self._args['repmat'] = '.'
        self._args['repdex'] = '.'
        self._computed()
        self._on_command_line()

    def _computed(self):
        """Fill some "computed" values"""
        # hostname
        self._args['hostname'] = platform.node()
        # ex. i686/x86_64
        self._args['processor'] = platform.machine()
        # ex. Linux
        self._args['system'] = platform.system()
        # ex. 32bit/64bit
        self._args['architecture'] = platform.architecture()[0]
        # ex. 2.6.32...
        self._args['osrelease'] = platform.release()
        self._args['osname'] = ' '.join(platform.linux_distribution())
        version = aster_pkginfo.version_info.version
        keys = ('parentid', 'branch', 'date',
                'from_branch', 'changes', 'uncommitted')
        self._args.update(zip(keys, aster_pkginfo.version_info[1:]))
        self._args['version'] = '.'.join(str(i) for i in version)
        self._args['versMAJ'] = version[0]
        self._args['versMIN'] = version[1]
        self._args['versSUB'] = version[2]
        self._args['exploit'] = aster_pkginfo.version_info.branch.startswith('v')
        self._args['versionD0'] = '%d.%02d.%02d' % version
        self._args['versLabel'] = aster_pkginfo.get_version_desc()

    def _on_command_line(self):
        """Initialize parameters that can be changed by the command line"""
        self._args['abort'] = 0
        self._args['buildelem'] = 0
        self._args['autostart'] = 1

    def set_option(self, option, value):
        """Set the value of an execution parameter"""
        # Options must at least declared by __init__
        assert option in self._args, "unknown option: {0}".format(option)
        self._args[option] = value

    def get_option(self, option, default=None):
        """Return the value of an execution parameter.
        @param option Name of the parameter
        @return value of the parameter
        """
        if option.startswith("prog:"):
            value = get_program_path(re.sub('^prog:', '', option))
        else:
            value = self._args.get(option, default)
        if type(value) in (str, unicode):
            value = convert(value)
        return value

    def parse_args(self, argv=None):
        """Parse the command line arguments to set the execution parameters"""
        from argparse import ArgumentParser
        # command arguments parser
        parser = ArgumentParser(description='execute a Code_Aster study',
                                prog="Code_Aster{called by Python}")
        parser.add_argument('-g', '--debug', action='store_true',
            help="add debug informations")

        parser.add_argument('--abort', action='store_true',
            help="abort execution in case of error (testcase mode, by default "
                 "raise an exception)")
        parser.add_argument('--build-elem', dest='buildelem', action='store_true',
            default=False,
            help="enable specific starting mode to build the elements database")
        parser.add_argument('--start', dest='autostart',
            action='store_true', default=True,
            help="automatically start the memory manager")
        parser.add_argument('--no-start', dest='autostart',
            action='store_false',
            help="turn off the automatic start of the memory manager")

        parser.add_argument('--memory', action='store', default=1000,
            help="memory limit in MB used for code_aster objects "
                 "(default: 1000 MB)")
        parser.add_argument('--tpmax', action='store', default=86400,
            help="time limit of the execution in seconds (default: 1 day)")
        parser.add_argument('--maxbase', action='store', default=48000,
            help="size limit in MB for code_aster out-of-core files (glob.*, "
              "default: 48 GB)")
        parser.add_argument('--numthreads', action='store', default=1,
            help="maximum number of threads")

        parser.add_argument('--dbgjeveux', action='store_true', default=False,
            help="turn on some additional checkings in the memory management")

        parser.add_argument('--rep_mat', dest='repmat', action='store',
            metavar='DIR', default='.',
            help="directory of materials properties")
        parser.add_argument('--rep_dex', dest='repdex', action='store',
            metavar='DIR', default='.',
            help="directory of external datas (geometrical datas or properties...)")

        args, ignored = parser.parse_known_args(argv or sys.argv)
        if args.debug:
            setlevel()
        logger.debug("Ignored arguments: %r", ignored)
        logger.debug("Read options: %r", vars(args))

        # assign parameter values
        for opt, value in vars(args).items():
            self.set_option(opt, value)

        # replace "suivi_batch" option that was always enabled
        unbuffered_stdout()


def unbuffered_stdout():
    """Force stdout to be line buffered."""
    setvbuf(stdout, NULL, _IOLBF, 0)


# extract from aster_settings (that can not be imported here because of
# imports of aster, aster_core...)
def get_program_path(program):
    """Return the path to *program* as stored by 'waf configure'.

    Returns:
        str: Path stored during configuration or *program* itself otherwise.
    """
    if getattr(get_program_path, "_cache", None) is None:
        prog_cfg = {}
        fname = osp.join(os.environ["ASTER_DATADIR"], "external_programs.js")
        if osp.isfile(fname):
            prog_cfg = json.load(open(fname, "rb"))
        get_program_path._cache = prog_cfg

    programs = get_program_path._cache
    return programs.get(program, program)


# global instance
executionParameter = ExecutionParameter()

def setExecutionParameter(option, value):
    """Static function to set parameters from the user command file"""
    global executionParameter
    executionParameter.set_option(option, value)

cdef public long getParameterLong(char* option):
    """Request the value of an execution parameter of type 'int'"""
    global executionParameter
    value = executionParameter.get_option(option) or 0
    logger.debug('gtopti(%r): %r', option, value)
    return value

cdef public double getParameterDouble(char* option):
    """Request the value of an execution parameter of type 'double'"""
    global executionParameter
    value = executionParameter.get_option(option) or 0.
    logger.debug('gtoptr(%r): %r', option, value)
    return value

cdef public void gtoptk_(char* option, char* valk, long* iret,
                          unsigned int larg, unsigned int lvalk):
    """Request the value of an execution parameter of type 'string'"""
    global executionParameter
    arg = to_cstr(option, larg)
    value = executionParameter.get_option(arg)
    if value is None:
        iret[0] = 4
    else:
        copyToFStr(valk, value, lvalk)
        iret[0] = 0
    logger.debug('gtoptk(%r): %r, iret %r', arg, value, iret[0])
