# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

# person_in_charge: mathieu.courtois at edf.fr

# discourage import *
__all__ = []

# import libaster to call initAsterModules
import libaster

# import datastructures enriched by pure python extensions
from .Objects import *

from .Commands.debut import init

# # install i18n function as soon as possible
# from .Utilities import localization
# localization.install()
#
# # import general purpose functions
# from .RunManager.saving import saveObjects
from .Utilities import TestCase
#
# # each package is responsible to export only the relevant objects
# from .LinearAlgebra import *
