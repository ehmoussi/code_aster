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

#
#
# FORMULE 2D PERMETTANT LA DEFINITION ET LE CALCUL DES COPEAUX DANS LE CAS SS_COPEAU
#           (Pour plus de renseignement, voir CR-AMA-12-272)
#


def SEUIL(X, Y, X0, Y0, R, lc, Nume_cop, ccos, ssin):
    f1 = 0
    f2 = 0
    f3 = 0
    # DY1,DY2,DX3,DX2
    if (-(X - X0) * ccos <= (Y - Y0) * ssin)\
        and((X - X0 - Nume_cop * lc * ccos) * ccos
            <= -ssin * (Y - Y0 - Nume_cop * lc * ssin))\
        and((Y - Y0 + R * ccos) * ccos >= (X - X0 - R * ssin) * ssin)\
            and((Y - Y0 - R * ccos) * ccos <= (X - X0 + R * ssin) * ssin):
        f1 = 1
    # C2,DY2
    if ((X - X0 - Nume_cop * lc * ccos) ** 2 + (Y - Y0 - Nume_cop * lc * ssin) ** 2
       <= R ** 2)\
       and ((X - X0 - Nume_cop * lc * ccos) * ccos
            >= -ssin * (Y - Y0 - Nume_cop * lc * ssin)):
        f2 = 1
    # C1,DY1
    if ((X - X0) ** 2 + (Y - Y0) ** 2 <= R ** 2) and (-(X - X0) * ccos <= (Y - Y0) * ssin):
        f3 = 1
    f = f1 + f2 - f3
    return f

#--


#
# DEBUT DE LA MACRO PROPREMENT DITE
#
def raff_gp_ops(self, **args):
    """Corps de RAFF_GP"""
    from numpy import *
    import aster
    from code_aster.Cata.Syntax import _F
    from Utilitai.Utmess import UTMESS, MasquerAlarme, RetablirAlarme
    MasquerAlarme('CALCCHAMP_1')
#    MasquerAlarme('HOMARD0_9')
#
# PREPARATION DES SORTIES
#
    self.DeclareOut('MAOUT', self.sd)

    ier = 0
    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)
#
# IMPORTATION DES COMMANDES ET MACRO UTILISEES
#
    CO = self.get_cmd('CO')
    CREA_CHAMP = self.get_cmd('CREA_CHAMP')
    FORMULE = self.get_cmd('FORMULE')
    CALC_CHAMP = self.get_cmd('CALC_CHAMP')
    MACR_ADAP_MAIL = self.get_cmd('MACR_ADAP_MAIL')
    AFFE_MODELE = self.get_cmd('AFFE_MODELE')
    DETRUIRE = self.get_cmd('DETRUIRE')
    COPIER = self .get_cmd('COPIER')
#

#
# RECUPERATION DU MAILLAGE ET DES DONNEES UTILISATEUR
#

    __MA0 = self['MAILLAGE_N']

    nb_calc = self['NB_RAFF']
# Manipulation obligatoire pour pouvoir se servir des grandeurs dans les
# formules
    TRANCHE_2D = self['TRANCHE_2D']
    nbcop = TRANCHE_2D['NB_ZONE']
    theta = TRANCHE_2D['ANGLE']
    taille = TRANCHE_2D['TAILLE']

#
# INITIALISATIONS
#
    __MA = [None] * (nb_calc + 1)
    __MA[0] = __MA0
    const_context = {
        'origine': TRANCHE_2D['CENTRE'],
        'rayon': TRANCHE_2D['RAYON'],
        'taille': TRANCHE_2D['TAILLE'],
        'theta': TRANCHE_2D['ANGLE'],
        'nbcop': TRANCHE_2D['NB_ZONE'],
        'SEUIL': SEUIL,
        'ccos': cos(theta * pi / 180.),
        'ssin': sin(theta * pi / 180.)
    }

#
# C EST PARTI
#
    for num_calc in range(0, nb_calc):
        if num_calc % 3 == 0:
            __seuil = FORMULE(
                VALE='''SEUIL(X,Y,origine[0]-3.*rayon*ccos,origine[1]-3*rayon*ssin,3*rayon,taille,nbcop+4,ccos,ssin)''',
                NOM_PARA=('X', 'Y'),
                **const_context)
        elif num_calc % 3 == 1:
            __seuil = FORMULE(
                VALE='''SEUIL(X,Y,origine[0]-2.*rayon*ccos,origine[1]-2.*rayon*ssin,2.*rayon,taille,nbcop+2,ccos,ssin)''',
                NOM_PARA=('X', 'Y'),
                **const_context)
        elif num_calc % 3 == 2:
            __seuil = FORMULE(
                VALE='''SEUIL(X,Y,origine[0]-1.2*rayon*ccos,origine[1]-1.2*rayon*ssin,1.2*rayon,taille,nbcop,ccos,ssin)''',
                NOM_PARA=('X', 'Y'),
                **const_context)
        __MO = AFFE_MODELE(MAILLAGE=__MA[num_calc],
                           AFFE=_F(TOUT='OUI',
                                   PHENOMENE='MECANIQUE',
                                   MODELISATION='D_PLAN'),
                           )
# champ de geometrie et de points de gauss (coordonnees des points de gauss)
        __CHXN = CREA_CHAMP(OPERATION='EXTR',
                            TYPE_CHAM='NOEU_GEOM_R',
                            NOM_CHAM='GEOMETRIE',
                            MAILLAGE=__MA[num_calc])
        __CHXG = CREA_CHAMP(OPERATION='DISC',
                            TYPE_CHAM='ELGA_GEOM_R',
                            MODELE=__MO,
                            CHAM_GD=__CHXN)
        __f_seuil = CREA_CHAMP(TYPE_CHAM='ELGA_NEUT_F',
                               MODELE=__MO,
                               OPERATION='AFFE',
                               PROL_ZERO='OUI',
                               AFFE=_F(TOUT='OUI',
                                       NOM_CMP='X1',
                                       VALE_F=__seuil,),)
        __COPEAUX = CREA_CHAMP(TYPE_CHAM='ELGA_NEUT_R',
                               OPERATION='EVAL',
                               CHAM_F=__f_seuil,
                               CHAM_PARA=(__CHXG),)
        __MA[num_calc + 1] = CO('__MA_%d' % (num_calc + 1))
        MACR_ADAP_MAIL(ADAPTATION='RAFFINEMENT',
                       CHAM_GD=__COPEAUX,
                       CRIT_RAFF_ABS=0.01,
                       MAILLAGE_N=__MA[num_calc],
                       MAILLAGE_NP1=__MA[num_calc + 1])
        DETRUIRE(CONCEPT=(_F(NOM=__COPEAUX,),
                          _F(NOM=__MO,),
                 _F(NOM=__CHXN),
            _F(NOM=__CHXG),
            _F(NOM=__f_seuil),
            _F(NOM=__seuil),
        ),
        )

    MAOUT = COPIER(CONCEPT=__MA[nb_calc])
    RetablirAlarme('CALCCHAMP_1')

    return ier
