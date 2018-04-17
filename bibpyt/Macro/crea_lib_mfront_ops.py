# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# person_in_charge: nicolas.sellenet at edf.fr

def crea_lib_mfront_ops(self, UNITE_MFRONT, UNITE_LIBRAIRIE, **args):
    """Compiler une loi de comportement MFront"""

    ier = 0
    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    import os
    import aster_core
    from Utilitai.UniteAster import UniteAster
    from Utilitai.Utmess import UTMESS

    UL = UniteAster()
    fichierMFront = UL.Nom(UNITE_MFRONT)
    mfront = aster_core.get_option('prog:mfront')
    os.system(mfront + " --obuild " + fichierMFront + " --interface=aster")
    if not os.path.exists("src/libAsterBehaviour.so"):
        fileName = ("libAsterBehaviour.so")
        UTMESS('F', 'MFRONT_4', valk=fileName)

    fichierLib = 'fort.%s' % UNITE_LIBRAIRIE
    fichierLib = UL.Nom(UNITE_LIBRAIRIE)
    os.system("cp src/libAsterBehaviour.so ./"+fichierLib)
    os.system("ls -ltr")
    os.system("rm -fr src include")
    UL.EtatInit()

    return ier
