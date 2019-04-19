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

def macro_matr_ajou_ops(
    self, MAILLAGE, GROUP_MA_FLUIDE, GROUP_MA_INTERF, MODELISATION, FLUIDE, DDL_IMPO, 
    MODE_MECA=None, DEPL_IMPO=None, NUME_DDL_GENE=None, MODELE_GENE=None, MATR_MASS_AJOU=None,
    MATR_AMOR_AJOU=None, MATR_RIGI_AJOU=None, NOEUD_DOUBLE=None, DIST_REFE=None, SOLVEUR=None,
    INFO=None, AVEC_MODE_STAT=None, MODE_STAT=None, MONO_APPUI=None,
    FORC_AJOU=None, ECOULEMENT=None, **args):
    """
       Ecriture de la macro MACRO_MATR_AJOU
    """
    from code_aster.Cata.Syntax import _F
    import aster
    from Utilitai.Utmess import UTMESS
    from Utilitai.Utmess import MasquerAlarme, RetablirAlarme
    ier = 0

    # On importe les definitions des commandes a utiliser dans la macro
    DEFI_MATERIAU = self.get_cmd('DEFI_MATERIAU')
    AFFE_MATERIAU = self.get_cmd('AFFE_MATERIAU')
    AFFE_MODELE = self.get_cmd('AFFE_MODELE')
    AFFE_CHAR_THER = self.get_cmd('AFFE_CHAR_THER')
    CALC_MATR_AJOU = self.get_cmd('CALC_MATR_AJOU')
    THER_LINEAIRE = self.get_cmd('THER_LINEAIRE')
    from code_aster.Commands import CALC_FORC_AJOU
    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    if len(FLUIDE) == 1:
        message = '<I> <MACRO_MATR_AJOU> tout le domaine fluide specifie dans GROUP_MA_INTERF et GROUP_MA_FLUIDE \n'
        message = message + '                      sera affecte par la masse volumique RHO = ' + \
            str(FLUIDE[0]['RHO']) + ' \n'
        aster.affiche('MESSAGE', message)
        if FLUIDE[0]['GROUP_MA'] is not None:
            message = '<I> <MACRO_MATR_AJOU> cas fluide simple : le group_ma dans lequel vous affectez la masse \n'
            message = message + \
                'volumique RHO doit etre la reunion de GROUP_MA_INTERF et GROUP_MA_FLUIDE. \n'
            aster.affiche('MESSAGE', message)
    else:
        for flu in FLUIDE:
            if flu['GROUP_MA'] is None:
                UTMESS('F', 'MATRICE0_1')

    IOCFLU = len(FLUIDE)

#  ---------------------------------------------------------------
#  definition du materiau fluide par caracteristique
#  thermique equivalente

# CAS FLUIDE SIMPLE
    if IOCFLU == 1:
        __NOMMAT = DEFI_MATERIAU(THER=_F(LAMBDA=1.0,
                                         RHO_CP=FLUIDE[0]['RHO']))
        __NOMCMA = AFFE_MATERIAU(MAILLAGE=MAILLAGE,
                                 AFFE=_F(
                                 GROUP_MA=(
                                 GROUP_MA_FLUIDE, GROUP_MA_INTERF),
                                 MATER=__NOMMAT),)

#  ---------------------------------------------------------------
#  cas fluides multiples
    else:
        affmat = []
        for flu in FLUIDE:
            __NOMMAT = DEFI_MATERIAU(THER=_F(LAMBDA=1.0,
                                             RHO_CP=flu['RHO']))
            mfact = _F(GROUP_MA=flu['GROUP_MA'], MATER=__NOMMAT)
            affmat.append(mfact)

        __NOMCMA = AFFE_MATERIAU(MAILLAGE=MAILLAGE,
                                 AFFE=affmat)

#  ---------------------------------------------------------------
#  commande AFFE_MODELE modele fluide
    __NOMFLU = AFFE_MODELE(MAILLAGE=MAILLAGE,
                           AFFE=_F(
                           GROUP_MA=(
                           GROUP_MA_FLUIDE, GROUP_MA_INTERF),
                           MODELISATION=MODELISATION,
                           PHENOMENE='THERMIQUE'), )

#  ---------------------------------------------------------------
#  commande AFFE_MODELE modele interface
    # Pour masquer certaines alarmes
    # <MODELE1_63> : DANS UN MODELE, IL EXISTE DES ELEMENTS DE TYPE "BORD" QUI N'ONT PAS DE VOISIN AVEC RIGIDITE
    # <MODELE1_64> : DANS UN MODELE, IL N'Y A AUCUN ELEMENT AVEC RIGIDITE
    MasquerAlarme('MODELE1_63')
    MasquerAlarme('MODELE1_64')

    __NOMINT = AFFE_MODELE(MAILLAGE=MAILLAGE,
                           AFFE=_F(GROUP_MA=GROUP_MA_INTERF,
                                   MODELISATION=MODELISATION,
                                   PHENOMENE='THERMIQUE'), )
    RetablirAlarme('MODELE1_63')
    RetablirAlarme('MODELE1_64')

#  ---------------------------------------------------------------
#  commande AFFE_CHAR_THER condition de pression imposee
#  en un point ou un groupe du fluide
    affimp = []
    nflui = 0
    for DDL in DDL_IMPO:
        if DDL['PRES_FLUIDE'] is not None:
            nflui = nflui + 1
            if DDL['NOEUD'] is not None:
                mfact = _F(NOEUD=DDL['NOEUD'],   TEMP=DDL['PRES_FLUIDE'])
            if DDL['GROUP_NO'] is not None:
                mfact = _F(GROUP_NO=DDL['GROUP_NO'], TEMP=DDL['PRES_FLUIDE'])
            affimp.append(mfact)
    if nflui == 0:
        UTMESS('F', 'MATRICE0_2')

    __CHARGE = AFFE_CHAR_THER(MODELE=__NOMFLU,
                              TEMP_IMPO=affimp)

#  ---------------------------------------------------------------
#  calcul des masses, rigidites et amortissements ajoutes en theorie
#  potentielle
#  commande CALC_MATR_AJOU, calcul de la masse ajoutee

    if MATR_MASS_AJOU is not None:
        solveur = SOLVEUR[0].cree_dict_valeurs(SOLVEUR[0].mc_liste)
        mostcles = {}
        if NUME_DDL_GENE is not None:
            mostcles['NUME_DDL_GENE'] = NUME_DDL_GENE
        if INFO is not None:
            mostcles['INFO'] = INFO
        if MODE_MECA is not None:
            mostcles['MODE_MECA'] = MODE_MECA
        elif DEPL_IMPO is not None:
            mostcles['CHAM_NO'] = DEPL_IMPO
        elif MODELE_GENE is not None:
            mostcles['MODELE_GENE'] = MODELE_GENE
            mostcles['AVEC_MODE_STAT'] = AVEC_MODE_STAT
            mostcles['DIST_REFE'] = DIST_REFE
        if NOEUD_DOUBLE is not None:
            mostcles['NOEUD_DOUBLE'] = NOEUD_DOUBLE

        MASSAJ = CALC_MATR_AJOU(MODELE_FLUIDE=__NOMFLU,
                                MODELE_INTERFACE=__NOMINT,
                                CHARGE=__CHARGE,
                                CHAM_MATER=__NOMCMA,
                                OPTION='MASS_AJOU',
                                SOLVEUR=solveur,
                                **mostcles)
        self.register_result(MASSAJ, MATR_MASS_AJOU)
        

#  ---------------------------------------------------------------
#  calcul de l amortissement ajoute
    if (MATR_AMOR_AJOU is not None) or (MATR_RIGI_AJOU is not None):

#  ---------------------------------------------------------------
#  on definit un nouveau modele fluide pour calculer
#  le potentiel stationnaire - AFFE_MODELE
        grma = [GROUP_MA_FLUIDE, ]
        if ECOULEMENT is not None:
            grma.append(ECOULEMENT['GROUP_MA_1'])
            grma.append(ECOULEMENT['GROUP_MA_2'])
            if type(ECOULEMENT) not in (list, tuple):
                ECOULEMENT = (ECOULEMENT,)
        __NOFLUI = AFFE_MODELE(MAILLAGE=MAILLAGE,
                               AFFE=_F(GROUP_MA=grma,
                                       MODELISATION=MODELISATION,
                                       PHENOMENE='THERMIQUE'), )
        affimp = []
        for DDL in DDL_IMPO:
            if DDL['PRES_SORTIE'] is not None:
                if DDL['NOEUD'] is not None:
                    mfact = _F(
                        NOEUD=DDL['NOEUD'],   TEMP=DDL['PRES_SORTIE'])
                if DDL['GROUP_NO'] is not None:
                    mfact = _F(
                        GROUP_NO=DDL['GROUP_NO'], TEMP=DDL['PRES_SORTIE'])
                affimp.append(mfact)

        affecl = []
        for ECL in ECOULEMENT:
            mfact = _F(GROUP_MA=ECL['GROUP_MA_1'], FLUN=ECL['VNOR_1'])
            affecl.append(mfact)
            mfact = _F(GROUP_MA=ECL['GROUP_MA_2'], FLUN=ECL['VNOR_2'])
            affecl.append(mfact)
        __CHARG2 = AFFE_CHAR_THER(MODELE=__NOFLUI,
                                  TEMP_IMPO=affimp,
                                  FLUX_REP=affecl)

        __POTEN = THER_LINEAIRE(MODELE=__NOFLUI,
                                CHAM_MATER=__NOMCMA,
                                EXCIT=_F(CHARGE=__CHARG2))

#  ---------------------------------------------------------------
#  calcul amortissement proprement dit
    if MATR_AMOR_AJOU is not None:
        solveur = SOLVEUR[0].cree_dict_valeurs(SOLVEUR[0].mc_liste)
        mostcles = {}
        if NUME_DDL_GENE is not None:
            mostcles['NUME_DDL_GENE'] = NUME_DDL_GENE
        if INFO is not None:
            mostcles['INFO'] = INFO
        if MODE_MECA is not None:
            mostcles['MODE_MECA'] = MODE_MECA
        elif DEPL_IMPO is not None:
            mostcles['CHAM_NO'] = DEPL_IMPO
        else:
            UTMESS('F', 'MATRICE0_3')

        AMORAJ = CALC_MATR_AJOU(MODELE_FLUIDE=__NOMFLU,
                                MODELE_INTERFACE=__NOMINT,
                                CHARGE=__CHARGE,
                                CHAM_MATER=__NOMCMA,
                                OPTION='AMOR_AJOU',
                                SOLVEUR=solveur,
                                POTENTIEL=__POTEN,
                                **mostcles)
        self.register_result(AMORAJ, MATR_AMOR_AJOU)

#  ---------------------------------------------------------------
#  calcul de la rigidite ajoutee
    if MATR_RIGI_AJOU is not None:
        solveur = SOLVEUR[0].cree_dict_valeurs(SOLVEUR[0].mc_liste)
        mostcles = {}
        if NUME_DDL_GENE is not None:
            mostcles['NUME_DDL_GENE'] = NUME_DDL_GENE
        if INFO is not None:
            mostcles['INFO'] = INFO
        if MODE_MECA is not None:
            mostcles['MODE_MECA'] = MODE_MECA
        elif DEPL_IMPO is not None:
            mostcles['CHAM_NO'] = DEPL_IMPO
        else:
            UTMESS('F', 'MATRICE0_4')

        RIGIAJ = CALC_MATR_AJOU(MODELE_FLUIDE=__NOMFLU,
                                MODELE_INTERFACE=__NOMINT,
                                CHARGE=__CHARGE,
                                CHAM_MATER=__NOMCMA,
                                OPTION='RIGI_AJOU',
                                SOLVEUR=solveur,
                                POTENTIEL=__POTEN,
                                **mostcles)
        self.register_result(RIGIAJ, MATR_RIGI_AJOU)

#  ---------------------------------------------------------------
#  boucle sur le nombre de vecteurs a projeter, commande CALC_FORC_AJOU
    if FORC_AJOU is not None:
        for FORCAJ in FORC_AJOU:
            solveur = SOLVEUR[0].cree_dict_valeurs(SOLVEUR[0].mc_liste)
            mostcles = {}
            if NUME_DDL_GENE is not None:
                mostcles['NUME_DDL_GENE'] = NUME_DDL_GENE
            if MODE_MECA is not None:
                mostcles['MODE_MECA'] = MODE_MECA
            elif MODELE_GENE is not None:
                mostcles['MODELE_GENE'] = MODELE_GENE
                mostcles['AVEC_MODE_STAT'] = AVEC_MODE_STAT
                mostcles['DIST_REFE'] = DIST_REFE
            if NOEUD_DOUBLE is not None:
                mostcles['NOEUD_DOUBLE'] = NOEUD_DOUBLE
            if MODE_STAT is not None:
                mostcles[
                    'MODE_STAT'] = MODE_STAT
                if FORCAJ['NOEUD'] is not None:
                    mostcles['NOEUD'] = FORCAJ['NOEUD']
                if FORCAJ['GROUP_NO'] is not None:
                    mostcles['GROUP_NO'] = FORCAJ['GROUP_NO']
            else:
                mostcles['MONO_APPUI'] = MONO_APPUI

            VECTAJ = CALC_FORC_AJOU(DIRECTION=FORCAJ['DIRECTION'],
                                    MODELE_FLUIDE=__NOMFLU,
                                    MODELE_INTERFACE=__NOMINT,
                                    CHARGE=__CHARGE,
                                    CHAM_MATER=__NOMCMA,
                                    SOLVEUR=solveur,
                                    **mostcles)
            self.register_result(VECTAJ, FORCAJ['VECTEUR'])

    return
