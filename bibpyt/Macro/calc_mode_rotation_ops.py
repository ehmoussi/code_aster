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

#

from code_aster.Cata.Syntax import _F
from types import ListType, TupleType


def calc_mode_rotation_ops(self, MATR_RIGI, MATR_MASS, MATR_AMOR, MATR_GYRO,
                           VITE_ROTA, METHODE, CALC_FREQ, VERI_MODE, **args):
# Macro pour calculer les frequences et modes en fonction des vitesses de rotation
# MATR_RIGI, matrice de raideur
# MATR_MASS, matrice de masse
# MATR_AMOR, matrice d'amortissement
# MATR_GYRO, matrice de gyroscopie
# VITE_ROTA, liste de vitesses de rotation
# METHODE, methode de calcul, QZ par defaut ou SORENSEN
# CALC_FREQ
# VERI_MODE
    from Utilitai.Table import Table
    ier = 0

    # On importe les definitions des commandes a utiliser dans la macro
    CALC_MODES = self.get_cmd('CALC_MODES')
    COMB_MATR_ASSE = self.get_cmd('COMB_MATR_ASSE')
    CREA_TABLE = self.get_cmd('CREA_TABLE')

    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    motscit = {}
    
    if  CALC_FREQ['OPTION']== 'PLUS_PETITE':
        motscit['CALC_FREQ'] = _F(SEUIL_FREQ=CALC_FREQ['SEUIL_FREQ'],
                                  NMAX_FREQ=CALC_FREQ['NMAX_FREQ'])

    else:
        motscit['CALC_FREQ'] = _F(SEUIL_FREQ=CALC_FREQ['SEUIL_FREQ'],
                                  NMAX_FREQ=CALC_FREQ['NMAX_FREQ'],
                                  FREQ=CALC_FREQ['FREQ'])

    motscit['VERI_MODE'] = _F(STOP_ERREUR=VERI_MODE['STOP_ERREUR'],
                              SEUIL=VERI_MODE['SEUIL'],
                              STURM=VERI_MODE['STURM'],
                              PREC_SHIFT=VERI_MODE['PREC_SHIFT'])

    self.DeclareOut('tab_out', self.sd)

    NBV = len(VITE_ROTA)

    _mod = [None] * NBV

    tab = Table()
    for ii in range(0, NBV):
        OM = VITE_ROTA[ii]

        # ----------------------------------
        # Ajout des effets gyroscopiques w*G
        # dans la matrice d amortissement C
        # ----------------------------------

        __gyom = COMB_MATR_ASSE(COMB_R=(_F(MATR_ASSE=MATR_GYRO, COEF_R=OM,),
                                        _F(MATR_ASSE=MATR_AMOR, COEF_R=1.,),))

        _mod[ii] = CALC_MODES(MATR_RIGI=MATR_RIGI,
                              MATR_MASS=MATR_MASS,
                              MATR_AMOR=__gyom,
                              OPTION=CALC_FREQ['OPTION'],
                              SOLVEUR_MODAL=_F(METHODE=METHODE),
                              **motscit)

        tab.append({'NUME_VITE': ii, 'VITE_ROTA': OM, 'NOM_OBJET':
                   'MODE_MECA', 'TYPE_OBJET': 'MODE_MECA', 'NOM_SD': _mod[ii].nom})

    motcles = tab.dict_CREA_TABLE()
    tab_out = CREA_TABLE(TYPE_TABLE='TABLE_CONTENEUR', **motcles)
    return ier
