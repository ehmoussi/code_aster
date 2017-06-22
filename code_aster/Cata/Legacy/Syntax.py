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

import os
import os.path as osp

import Accas
from Accas import *
from Accas import _F
from . import ops


JdC = JDC_CATA(code='ASTER',
               execmodul=None,
               regles=(UN_PARMI('DEBUT', 'POURSUITE'),
                       AU_MOINS_UN('FIN'),
                       A_CLASSER(('DEBUT', 'POURSUITE'), 'FIN')))


class FIN_ETAPE(PROC_ETAPE):
    """Particularisation pour FIN"""
    def Build_sd(self):
        """Fonction Build_sd pour FIN"""
        PROC_ETAPE.Build_sd(self)
        if self.nom == 'FIN':
            try:
                from Noyau.N_Exception import InterruptParsingError
                raise InterruptParsingError
            except ImportError:
                # eficas does not known this exception
                pass
        return None


class FIN_PROC(PROC):
    """Procédure FIN"""
    class_instance = FIN_ETAPE
