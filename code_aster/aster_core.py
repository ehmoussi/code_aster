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

'''
This module manages core settings of aster.
'''

# .. note:: Some of these functions are binded into C through
#   ``_aster_core`` (see ``bibc/aster_core_module.c``). They have been
#   written in python for convenience.

# .. note:: the _aster_core module contains globals that is set for a
#   particular computation. The actual implementation does not allow
#   to manage more than one computation.

import sys

import _aster_core
# methods and attributes of C implementation of the module
from _aster_core import (_NO_EXPIR, _POSIX, _USE_64_BITS, _USE_MPI,
                         _USE_OPENMP, ASTER_INT_SIZE, MPI_Barrier, MPI_Bcast,
                         MPI_CommRankSize, MPI_GatherStr, MPI_Warn,
                         get_mem_stat, matfpe, set_mem_stat)
from code_aster.Utilities import ExecutionParameter


def get_option(option):
    '''return the setting parameter value.

    :option: a string containing the option name
    '''
    return ExecutionParameter().get_option(option)


def get_version():
    '''Return the version number as string'''
    return "__version__"


def set_option(option, value):
    '''modify a setting parameter value.

    :option: a string containing the option name
    :value: the value to be affected
    '''
    ExecutionParameter().set_option(option, value)


def register(settings, logger):
    """Register the settings in order to share them with
    every aster component.

    This function must be called in order to initialize aster.

    :settings: aster settings object (as given by ExecutionParameter)
    :logger: the message logger
    """
    _aster_core.register(settings, logger)
