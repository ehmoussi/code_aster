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

"""
    Ce package fournit les classes de base d'EFICAS.
    Ces classes permettent d'effectuer quelques opérations basiques :

      - la création

      - la vérification des définitions

      - la création d'objets de type OBJECT à partir d'une définition de type ENTITE
"""
# Avant toutes choses, on met le module context dans le global de l'interpreteur (__builtin__)
# sous le nom CONTEXT afin d'avoir accès aux fonctions
# get_current_step, set_current_step et unset_current_step de n'importe où
from . import context
import builtins
builtins.CONTEXT = context


def _(msg):
    """Differs translation."""
    # 'codex' should install its translation functions later
    return msg
builtins._ = _

# Classes de base
from .N_SIMP import SIMP
from .N_FACT import FACT

# structures de données
from . import asojb
from .asojb import AsBase
