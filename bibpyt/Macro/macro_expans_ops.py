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

def macro_expans_ops(self,
                     MODELE_CALCUL,
                     MODELE_MESURE,
                     NUME_DDL,
                     RESU_NX=None,
                     RESU_EX=None,
                     RESU_ET=None,
                     RESU_RD=None,
                     MODES_NUM=None,
                     MODES_EXP=None,
                     RESOLUTION=None,
                     **args
                     ):
    """!macro MACRO_EXPANS """
    from code_aster.Cata.Syntax import _F
    from Utilitai.Utmess import UTMESS
    import aster
    EXTR_MODE = self.get_cmd('EXTR_MODE')
    PROJ_MESU_MODAL = self.get_cmd('PROJ_MESU_MODAL')
    REST_GENE_PHYS = self.get_cmd('REST_GENE_PHYS')
    PROJ_CHAMP = self.get_cmd('PROJ_CHAMP')

    RESU_NUM = MODELE_CALCUL['BASE']
    RESU_EXP = MODELE_MESURE['MESURE']
    MOD_CALCUL = MODELE_CALCUL['MODELE']
    MOD_MESURE = MODELE_MESURE['MODELE']
    NOM_CHAM = MODELE_MESURE['NOM_CHAM']

    is_nume_num = is_nume_exp = 0
    if MODELE_CALCUL['NUME_MODE'][0] or MODELE_CALCUL['NUME_ORDRE'][0]:
        # on cree un resultat RESU_NX par extraction de NUME_ORDREs
        is_nume_num = 1
    else:
        if RESU_NX:
            UTMESS('A', 'CALCESSAI0_6', valk=['MODELE_MESURE', 'RESU_EX'])

    if MODELE_MESURE['NUME_MODE'][0] or MODELE_MESURE['NUME_ORDRE'][0]:
        # On cree un RESU_EX par extraction de NUME_ORDREs
        is_nume_exp = 1
        if RESU_NUM.getType() == "DYNA_HARMO":
            # on ne peut pas faire de EXTR_MODE  sur un DYNA_HARMO
            is_nume_exp = 0
            UTMESS('A', 'CALCESSAI0_13')
    else:
        if RESU_EX:
            UTMESS('A', 'CALCESSAI0_6', valk=['MODELE_CALCUL', 'RESU_NX'])

    # Extraction des modes numériques
    # -------------------------------
    if not is_nume_num:
        __resunx = RESU_NUM
    else:
        mfact = {'MODE': RESU_NUM}
        if MODELE_CALCUL['NUME_MODE'][0]:
            mfact.update({'NUME_MODE': MODELE_CALCUL['NUME_MODE']})
        elif MODELE_CALCUL['NUME_ORDRE'][0]:
            mfact.update({'NUME_ORDRE': MODELE_CALCUL['NUME_ORDRE']})

        __resunx = EXTR_MODE(FILTRE_MODE=mfact)
        if RESU_NX:
            self.register_result(__resunx, RESU_NX)

    # Extraction des modes expérimentaux
    # ----------------------------------
    if not is_nume_exp:
        __resuex = RESU_EXP
    else:
        mfact = {'MODE': RESU_EXP}
        if MODELE_MESURE['NUME_MODE'][0]:
            mfact.update({'NUME_MODE': MODELE_MESURE['NUME_MODE']})
        elif MODELE_MESURE['NUME_ORDRE'][0]:
            mfact.update({'NUME_ORDRE': MODELE_MESURE['NUME_ORDRE']})

        __resuex = EXTR_MODE(FILTRE_MODE=mfact)
        if RESU_EX:
            self.register_result(__resuex, RESU_EX)

    # Projection des modes experimentaux - on passe le mot-cle
    # RESOLUTION directement à PROJ_MESU_MODAL
    # --------------------------------------------------------
    # Mot-clé facteur de résolution
    if RESOLUTION:
        if RESOLUTION['METHODE'] == 'SVD':
            mfact = {'METHODE': 'SVD', 'EPS': RESOLUTION['EPS']}
            if RESOLUTION['REGUL'] != 'NON':
                mfact.update({'REGUL': RESOLUTION['REGUL']})
                if RESOLUTION['COEF_PONDER']:
                    mfact.update({'COEF_PONDER': RESOLUTION['COEF_PONDER']})
                if RESOLUTION['COEF_PONDER_F']:
                    mfact.update({'COEF_PONDER_F': RESOLUTION['COEF_PONDER_F']})
        elif RESOLUTION['METHODE'] == 'LU':
            mfact = {'METHODE': 'LU'}

    # Paramètres à garder : si on étend des mode_meca, on conserve les
    # freq propres, amortissements réduits, et masses généralisées. Pour
    # les dyna_harmo, on conserve les fréquences uniquement
    if RESU_EXP.getType() == "MODE_MECA":
        paras = ('FREQ', 'AMOR_REDUIT', 'MASS_GENE',)
    elif RESU_EXP.getType() == "DYNA_HARMO":
        paras = ('FREQ')
    else:
        paras = None
        #"LE MODELE MEDURE DOIT ETRE UN CONCEPT DE TYPE DYNA_HARMO OU MODE_MECA")
        UTMESS('A', 'CALCESSAI0_1')
    try:
        __PROJ = PROJ_MESU_MODAL(MODELE_CALCUL=_F(BASE=__resunx,
                                                  MODELE=MOD_CALCUL,
                                                  ),
                                 MODELE_MESURE=_F(MESURE=__resuex,
                                                  MODELE=MOD_MESURE,
                                                  NOM_CHAM=NOM_CHAM,
                                                  ),
                                 RESOLUTION=mfact,
                                 NOM_PARA=paras,
                                 )
    except Exception as err:
        raise Exception(err)

    # Phase de reconstruction des donnees mesurees sur le maillage
    # numerique
    # ------------------------------------------------------------
    __resuet = REST_GENE_PHYS(RESU_GENE=__PROJ,
                              TOUT_ORDRE='OUI',
                              NOM_CHAM=NOM_CHAM)
    if RESU_ET:
        self.register_result(__resuet, RESU_ET)
    # Restriction des modes mesures etendus sur le maillage capteur
    # -------------------------------------------------------------

    nume = None
    if NUME_DDL:
        nume = NUME_DDL
    if not nume:
        iret, ibid, tmp = aster.dismoi('NUME_DDL', self.nom, 'RESU_DYNA', 'C')
        if iret == 0:
            tmp = tmp.strip()
            if tmp:
                nume = self.get_concept(tmp)
        else:
            UTMESS('A', 'CALCESSAI0_5')
    __resurd = PROJ_CHAMP(METHODE='COLLOCATION',
                          RESULTAT=__resuet,
                          MODELE_1=MOD_CALCUL,
                          MODELE_2=MOD_MESURE,
                          NOM_CHAM=NOM_CHAM,
                          TOUT_ORDRE='OUI',
                          NUME_DDL=nume,
                          VIS_A_VIS=_F(TOUT_1='OUI',
                                       TOUT_2='OUI',),
                          NOM_PARA=paras,
                          )
    if RESU_RD:
        self.register_result(__resurd, RESU_RD)

    return
