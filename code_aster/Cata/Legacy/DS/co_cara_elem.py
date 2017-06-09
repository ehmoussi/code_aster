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


import aster
from code_aster.Cata.Syntax import ASSD


class cara_elem(ASSD):
    cata_sdj = "SD.sd_cara_elem.sd_cara_elem"

    def toEPX(self):

        # Raideurs
        ressorts = {}

        try:
           EPXnoeud = self.sdj.CARRIGXN.get()
           EPXval   = self.sdj.CARRIGXV.get()
           lenEPXval   = len(EPXval)
           lenEPXnoeud = len(EPXnoeud)*6
        except:
           # s'il y a un problème sur la structure de données ==> <F>
           from Utilitai.Utmess import UTMESS
           UTMESS('F','MODELISA9_98')
        # Vérification de la déclaration qui est faite dans 'acearp'
        if ( lenEPXval != lenEPXnoeud ):
           from Utilitai.Utmess import UTMESS
           UTMESS('F','MODELISA9_97')
        # Tout est OK
        i=0
        for no in EPXnoeud :
           ressorts[no] = EPXval[i:i+6]
           i+=6

        # Amortissements
        amorts = {}
        try:
           EPXnoeud = self.sdj.CARAMOXN.get()
           EPXval   = self.sdj.CARAMOXV.get()
           lenEPXval   = len(EPXval)
           lenEPXnoeud = len(EPXnoeud)*6
        except:
           # s'il y a un problème sur la structure de données ==> <F>
           from Utilitai.Utmess import UTMESS
           UTMESS('F','MODELISA9_98')
        # Vérification de la déclaration qui est faite dans 'acearp'
        if ( lenEPXval != lenEPXnoeud ):
           from Utilitai.Utmess import UTMESS
           UTMESS('F','MODELISA9_97')
        # Tout est OK
        i=0
        for no in EPXnoeud :
           amorts[no] = EPXval[i:i+6]
           i+=6

        return ressorts, amorts
