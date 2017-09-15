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

# person_in_charge: mathieu.courtois@edf.fr

# discourage import *
__all__ = []

# install i18n function as soon as possible
from .Utilities.i18n import localization
localization.install()

from .Supervis import executionParameter
from .RunManager import Initializer

# commands must be registered by libCommandSyntax before calling DEBUT.
from .Cata import Commands
from .Supervis import libCommandSyntax
libCommandSyntax.commandsRegister(Commands.commandStore)

executionParameter.parse_args()

from .Supervis import libFile

# automatic startup
if executionParameter.get_option('autostart'):
    Initializer.init( executionParameter.get_option('buildelem'))

# import datastructures enriched by pure python extensions
from .Extensions import *

# import general purpose functions
from .RunManager.saving import saveObjects
from .Utilities import TestCase

# each package is responsible to export only the relevant objects
from .LinearAlgebra import *
