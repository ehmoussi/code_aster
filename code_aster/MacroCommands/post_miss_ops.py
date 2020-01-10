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

# person_in_charge: mathieu.courtois at edf.fr

import os
import sys
import traceback

import aster
from libaster import AsterError
from Utilitai.Utmess import UTMESS

from .Miss.miss_post import PostMissFactory


def post_miss_ops(self, **kwargs):
    """Macro POST_MISS :
    Post-traitement d'un calcul MISS3D
    """

    # création de l'objet POST_MISS_xxx
    post = PostMissFactory(kwargs['OPTION'], self, kwargs)

    try:
        post.argument()
        post.execute()
        post.sortie()
    except AsterError as err:
        UTMESS('F', err.id_message, valk=err.valk,
               vali=err.vali, valr=err.valr)
    except Exception as err:
        trace = ''.join(traceback.format_tb(sys.exc_info()[2]))
        UTMESS('F', 'SUPERVIS2_5', valk=('POST_MISS', trace, str(err)))
