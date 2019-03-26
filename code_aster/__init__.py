# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

"""
Main entry point for the users.

The :py:func:`~code_aster.Commands.debut.init` function initializes the
memory manager. It must be called before any :py:mod:`code_aster.Objects`
creation. It can be simply called from this toplevel module with:

.. code-block:: python

    import code_aster
    code_aster.init()

The same job is done by :py:class:`~code_aster.Commands.debut.DEBUT`.

For convenience the objects are direcly available here:

.. code-block:: python

    import code_aster
    mymesh = code_aster.Mesh()

"""

# discourage import *
__all__ = []

# import libaster to call initAsterModules
import aster
import aster_core
import aster_fonctions
import med_aster
import libaster

# import datastructures enriched by pure python extensions
from .Objects import *

# import general purpose functions
from .Supervis import (AsterError, ContactError, ConvergenceError,
                       IntegrationError, SolverError, TimeLimitError)
from .RunManager import saveObjects
from .Utilities import TestCase

from .Algorithms import (ConstitutiveLaw, IntegrationAlgorithm, StrainType,
                         TangentMatrixType)

# # install i18n function as soon as possible
# from .Utilities import localization
# localization.install()

from .Commands.debut import init
from .Commands.fin import FIN as close
