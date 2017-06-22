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

"""
   Ce package contient les classes qui seront effectivement utilisees dans les applications.
   C'est dans ce package que sont realisees les combinaisons de classes de base
   avec les classes MIXIN qui implementent les fonctionnalites qui ont ete separees
   du noyau pour des raisons de modularite afin de faciliter la maintenance et
   l'extensibilite.

   De plus toutes les classes utilisables par les applications sont remontees au
   niveau du package afin de rendre le plus independant possible l'utilisation des
   classes et leur implementation.
"""

# permet de se proteger de l'oubli de carte coding
# ce warning deviendra fatal en python 2.4
import warnings
warnings.filterwarnings(
    'error', 'Non-ASCII character.*pep-0263', DeprecationWarning)

from A_JDC_CATA import JDC_CATA
from A_OPER import OPER
from A_PROC import PROC
from A_MACRO import MACRO
from A_FORM import FORM
from A_BLOC import BLOC
from A_FACT import FACT
from A_SIMP import SIMP

from A_JDC import JDC
from A_ETAPE import ETAPE
from A_PROC_ETAPE import PROC_ETAPE
from A_MACRO_ETAPE import MACRO_ETAPE
from A_FORM_ETAPE import FORM_ETAPE
from A_MCFACT import MCFACT
from A_MCLIST import MCList
from A_MCBLOC import MCBLOC
from A_MCSIMP import MCSIMP

# Les règles
from A_AU_MOINS_UN import AU_MOINS_UN
from A_UN_PARMI import UN_PARMI
from A_PRESENT_PRESENT import PRESENT_PRESENT
from A_PRESENT_ABSENT import PRESENT_ABSENT
from A_EXCLUS import EXCLUS
from A_ENSEMBLE import ENSEMBLE
from A_A_CLASSER import A_CLASSER

from Noyau.N_ASSD import ASSD, assd, not_checked
from Noyau.asojb import AsBase
from Noyau.N_GEOM import GEOM, geom
from Noyau.N_FONCTION import FONCTION, formule, formule_c
from Noyau.N_CO import CO
from Noyau.N__F import _F
from Noyau.N_OPS import OPS, EMPTY_OPS

from Noyau.N_Exception import AsException
from Noyau.N_utils import AsType

from Noyau.N_VALIDATOR import (Valid, RangeVal, OrdList, NoRepeat, LongStr,
                               EnumVal, CardVal, TypeVal, InstanceVal, OrVal,
                               AndVal, PairVal, Compulsory, Together, Absent,
                               NotEqualTo)
