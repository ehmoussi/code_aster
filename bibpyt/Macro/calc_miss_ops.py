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

import sys
import os
import traceback


def calc_miss_ops(self, **kwargs):
    """Macro CALC_MISS :
    Préparation des données et exécution d'un calcul MISS3D
    """
    import aster
    from Utilitai.Utmess import UTMESS
    from Miss.miss_utils import MISS_PARAMETER
    from Miss.miss_calcul import CalculMiss

    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    # conteneur des paramètres du calcul
    param = MISS_PARAMETER(initial_dir=os.getcwd(), **kwargs)

    # création de l'objet CalculMiss_xxx
    calcul = CalculMiss.factory(self, param)

    try:
        calcul.run()
    except aster.error, err:
        UTMESS('F', err.id_message, valk=err.valk,
               vali=err.vali, valr=err.valr)
    except Exception, err:
        trace = ''.join(traceback.format_tb(sys.exc_traceback))
        UTMESS('F', 'SUPERVIS2_5', valk=('CALC_MISS', trace, str(err)))
