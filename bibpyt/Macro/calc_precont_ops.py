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

# person_in_charge: sylvie.michel-ponnelle@edf.fr

#def calc_etape(nb_etapes, list_inst):
    #"""
        #Répartition des instants disponibles dans les différentes étapes
        #de calcul.
        #Renvoie les instants finaux des nb_etapes -1
    #"""
    
    #nb_inst_dispo = len(list_inst)-1
    #if nb_inst_dispo < nb_etapes : return None
    
    #inst_out = []
    #N = nb_inst_dispo
    #ind = 0
    #n_inst_etape = 0
    #for d in range(nb_etapes,1, -1):
        #a,b = divmod(N,d)
        #n_inst_etape += a
        #ind +=n_inst_etape
        #inst_out.append(list_inst[ind])
        #N = b

    #return inst_out



def calc_precont_ops(self, reuse, MODELE, CHAM_MATER, CARA_ELEM, EXCIT,
                     CABLE_BP, CABLE_BP_INACTIF,
                     COMPORTEMENT, ETAT_INIT, METHODE, ENERGIE,
                     RECH_LINEAIRE, CONVERGENCE, INCREMENT, SOLVEUR,
                     INFO, TITRE, **args):
    """
       Ecriture de la macro CALC_PRECONT
    """
    import copy
    import aster
    import string
    import types
    from code_aster.Cata.Syntax import _F
    from code_aster.Cata.DataStructure import listr8_sdaster, list_inst
    from Noyau.N_utils import AsType
    from Noyau.N_types import is_sequence
    from Utilitai.Utmess import UTMESS, MasquerAlarme, RetablirAlarme
    ier = 0

    # On importe les definitions des commandes a utiliser dans la macro
    AFFE_MODELE = self.get_cmd('AFFE_MODELE')
    CREA_CHAMP = self.get_cmd('CREA_CHAMP')
    AFFE_CHAR_MECA = self.get_cmd('AFFE_CHAR_MECA')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')
    DEFI_LIST_INST = self.get_cmd('DEFI_LIST_INST')
    STAT_NON_LINE = self.get_cmd('STAT_NON_LINE')
    CALC_CHAMP = self.get_cmd('CALC_CHAMP')
    DEFI_FONCTION = self.get_cmd('DEFI_FONCTION')
    RECU_TABLE = self.get_cmd('RECU_TABLE')
    DEFI_MATERIAU = self.get_cmd('DEFI_MATERIAU')
    AFFE_MATERIAU = self.get_cmd('AFFE_MATERIAU')
    IMPR_TABLE = self.get_cmd('IMPR_TABLE')
    DETRUIRE = self.get_cmd('DETRUIRE')
    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    # Le concept sortant (de type evol_noli) est nomme RES dans
    # le contexte de la macro

    self.DeclareOut('RES', self.sd)

    # alarme de STAT_NON_LINE si les mot-cles de COMPORTEMENT sont renseignes
    # a tort
    MasquerAlarme('COMPOR4_70')

    # -------------------------------------------------------------
    # 1. CREATION DES MOTS-CLES ET CONCEPTS POUR LES STAT_NON_LINE
    # ------------------------------------------------------------

    # 1.1 Recuperation de la liste d'instants, de l'instant initial et final
    #     Creation de la nouvelle liste d'instants
    # ----------------------------------------------------------
    dIncrement = INCREMENT[0].cree_dict_valeurs(INCREMENT[0].mc_liste)
    __prec = dIncrement['PRECISION']

    __L0 = dIncrement['LIST_INST']

    if type(__L0) == listr8_sdaster:
    # cas où liste definie par DEFI_LIST_REEL
        __L1 = __L0.Valeurs()
    elif type(__L0) == list_inst:
    # cas où liste definie par DEFI_LIST_INST
        tmp = __L0.get_name().ljust(8) + '.LIST.' + 'DITR'.ljust(18)
        __L1 = aster.getvectjev(tmp)

    # Traitement de l'etat initial
    if ETAT_INIT:
        dEtatInit = ETAT_INIT[0].cree_dict_valeurs(ETAT_INIT[0].mc_liste)
        for i in dEtatInit.keys():
            if dEtatInit[i] == None:
                del dEtatInit[i]
    else:
        dEtatInit = None

    # Teste si INST_INIT est donné ou bien recalcule __TMIN
    if dIncrement['INST_INIT'] == None:
        if self.reuse == None:
            __TMIN = __L1[0]
        else:
            __dico = self.reuse.LIST_VARI_ACCES()
            __TMIN = __dico['INST'][-1]
    else:
        __TMIN = dIncrement['INST_INIT']

    # Teste si INST_FIN est donné ou bien recalcule __TMAX
    if dIncrement['INST_FIN'] == None:
        __TMAX = __L1[-1]
    else:
        __TMAX = dIncrement['INST_FIN']

    # Teste si INST_INIT est bien plus petit que INST_FIN
    if __TMAX <= __TMIN:
        UTMESS('F', 'CABLE0_1')
        
    for i in dIncrement.keys():
            if dIncrement[i] == None:
                del dIncrement[i]

    # Preparation de  la liste d'instant __L2 allant de __TMIN a __TMAX
    # et preparation des instants supplementaire __TINT et __TINT2
    __L2 = []
    for m in __L1:
        if m >= __TMIN and m <= __TMAX:
            __L2.append(m)
    if len(__L2 ) < 2:
        UTMESS('F','CABLE0_4')

    __TINT = (9. * __L2[-1] + __L2[-2]) / 10.
    __TINT2 = (9.5 * __L2[-1] + .5 * __L2[-2]) / 10.

    # cas ADHERENT ou non
    ii = 0
    typ_ma = []
    for mcabl in CABLE_BP:
        __TCAB1 = RECU_TABLE(CO=mcabl, NOM_TABLE='CABLE_GL')
        table_cable = __TCAB1.EXTR_TABLE()
        __adher = table_cable.ADHERENT.values()[0]
        __typ_ma = table_cable.TYPE_MAILLE.values()[0]
        typ_ma.append(__typ_ma)
        if ii == 0:
            adher = __adher
        elif ii != 0 and __adher != adher:
            UTMESS('F', 'CABLE0_3')
        ii += 1

        # DETRUIRE(CONCEPT=_F(NOM=__TCAB1))

    adher = adher.strip()

    if (adher == 'OUI'):
        # finalisation liste instants
        __L2[-1:-1] = [__TINT]

        # __LST0 est la liste d'instants utilisée pour l'etape 1
        __LSTR0 = DEFI_LIST_REEL(DEBUT=__TMIN,
                                INTERVALLE=_F(JUSQU_A=__TMAX, NOMBRE=1),)
        __LST0 = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__LSTR0),)
        

        # __LST et __FCT sont utilisés pour les etapes 2 et 3
        __LSTR = DEFI_LIST_REEL(VALE=__L2,)
        __LST  = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__LSTR),)
        __FCT = DEFI_FONCTION(INTERPOL=('LIN', 'LIN'),
                              NOM_PARA='INST',
                              VALE=(__TMIN, 0.0, __TINT, 1.0, __TMAX, 1.0),)
        dIncrement['LIST_INST'] = __LST
        dIncrement['INST_FIN'] = __TINT

        # 1.2 Recuperation des parametres pour STAT_NON_LINE
        # -------------------------------------------------------
        motscle4 = {}
        motscle5 = {}

        if METHODE == 'NEWTON':
            motscle4['NEWTON'] = args['NEWTON'].List_F()
            motscle5['NEWTON'] = args['NEWTON'].List_F()
    #     for j in dNewton.keys():
    #       if dNewton[j]==None : del dNewton[j]

        dConvergence = CONVERGENCE[
            0].cree_dict_valeurs(CONVERGENCE[0].mc_liste)
        for i in dConvergence.keys():
            if dConvergence[i] == None:
                del dConvergence[i]

        dSolveur = SOLVEUR[0].cree_dict_valeurs(SOLVEUR[0].mc_liste)
        for i in dSolveur.keys():
            if dSolveur[i] == None:
                del dSolveur[i]

        if RECH_LINEAIRE:
            dRech_lin = RECH_LINEAIRE[0].cree_dict_valeurs(
                RECH_LINEAIRE[0].mc_liste)
            for i in dRech_lin.keys():
                if dRech_lin[i] == None:
                    del dRech_lin[i]
        else:
            dRech_lin = None

        if ENERGIE:
            dEnergie = ENERGIE[0].cree_dict_valeurs(ENERGIE[0].mc_liste)
            motscle4['ENERGIE'] = dEnergie
            motscle5['ENERGIE'] = dEnergie

        # 1.3 Creation des mots-cles pour les 3 AFFE_CHAR_MECA
        #     Recuperation des cables dans les concepts CABLE_BP
        #     et CABLE_BP_INACTIF
        # ------------------------------------------------------
        if type(CABLE_BP) is not types.NoneType:
            if not is_sequence(CABLE_BP):
                CABLE_BP0 = CABLE_BP
                CABLE_BP = []
                CABLE_BP.append(CABLE_BP0)

        if type(CABLE_BP_INACTIF) is not types.NoneType:
            if not is_sequence(CABLE_BP_INACTIF):
                CABLE_BP_INACTIF0 = CABLE_BP_INACTIF
                CABLE_BP_INACTIF = []
                CABLE_BP_INACTIF.append(CABLE_BP_INACTIF0)

        motscles = {}
        motscles['RELA_CINE_BP'] = []
        motscle2 = {}
        motscle2['RELA_CINE_BP'] = []
        motscle3 = {}
        motscle3['RELA_CINE_BP'] = []
        set_GROUP_MA_A_SEG2 = set()
        set_GROUP_MA_A_SEG3 = set()
        for ica, mcabl in enumerate(CABLE_BP):
            # Creation de mots-cles pour les AFFE_CHAR_MECA
            motscles['RELA_CINE_BP'].append(_F(CABLE_BP=mcabl,
                                               SIGM_BPEL='OUI',
                                               RELA_CINE='NON',))
            motscle2['RELA_CINE_BP'].append(_F(CABLE_BP=mcabl,
                                               SIGM_BPEL='NON',
                                               RELA_CINE='OUI',))
            motscle3['RELA_CINE_BP'].append(_F(CABLE_BP=mcabl,
                                               SIGM_BPEL='OUI',
                                               RELA_CINE='OUI',))
            # Creation de __GROUP_MA_A : liste des noms des cables contenus
            # dans chaque concept CABLE_BP = cables  a activer
            __TCAB = RECU_TABLE(CO=mcabl, NOM_TABLE='CABLE_BP')
            table_cable = __TCAB.EXTR_TABLE()
            col_nom_cable = table_cable.NOM_CABLE
            __typ_ma = typ_ma[ica]
            if __typ_ma.strip() == 'SEG2':
                set_GROUP_MA_A_SEG2.update(col_nom_cable.values())
            elif __typ_ma.strip() == 'SEG3':
                set_GROUP_MA_A_SEG3.update(col_nom_cable.values())
            else:
                raise Exception('type inconnu')
        __GROUP_MA_A_SEG2 = list(set_GROUP_MA_A_SEG2)
        __GROUP_MA_A_SEG3 = list(set_GROUP_MA_A_SEG3)

        # Creation de __GROUP_MA_I : liste des noms des cables contenus
        # dans chaque CABLE_BP_INACTIF
        # __GROUP_MA_CABLE = liste des cables actifs et inactifs
        set_GROUP_MA_I_SEG2 = set()
        set_GROUP_MA_I_SEG3 = set()

        if CABLE_BP_INACTIF:
            motscle6 = {}
            motscle6['RELA_CINE_BP'] = []
            for mcabl in CABLE_BP_INACTIF:
                __TCA0 = RECU_TABLE(CO=mcabl, NOM_TABLE='CABLE_BP')
                __TCA2 = RECU_TABLE(CO=mcabl, NOM_TABLE='CABLE_GL')
                col_nom_cable = __TCA0.EXTR_TABLE().NOM_CABLE
                __typ_ma = __TCA2.EXTR_TABLE().TYPE_MAILLE.values()[0]
                if __typ_ma.strip() == 'SEG2':
                    set_GROUP_MA_I_SEG2.update(col_nom_cable.values())
                elif __typ_ma.strip() == 'SEG3':
                    set_GROUP_MA_I_SEG3.update(col_nom_cable.values())
                else:
                    raise Exception('type inconnu')

                # Creation de mots-cles pour les AFFE_CHAR_MECA
                motscle6['RELA_CINE_BP'].append(_F(CABLE_BP=mcabl,
                                                   SIGM_BPEL='NON',
                                                   RELA_CINE='OUI',))
        __GROUP_MA_I_SEG2 = list(set_GROUP_MA_I_SEG2)
        __GROUP_MA_I_SEG3 = list(set_GROUP_MA_I_SEG3)
        __GROUP_MA_CABLES_SEG2 = __GROUP_MA_A_SEG2 + __GROUP_MA_I_SEG2
        __GROUP_MA_CABLES_SEG3 = __GROUP_MA_A_SEG3 + __GROUP_MA_I_SEG3

        # 1.4 Creation des mots-clés facteurs COMPORTEMENT
        # pour étape 2 (dComp_incr0) et étape 3 (dComp_incr1)
        # ------------------------------------------------------
        dComp_incr = []
        for j in COMPORTEMENT:
            dComp_incr.append(j.cree_dict_valeurs(j.mc_liste))
            for i in dComp_incr[-1].keys():
                if dComp_incr[-1][i] == None:
                    del dComp_incr[-1][i]
        dComp_incr0 = copy.copy(dComp_incr)
        dComp_incr1 = copy.copy(dComp_incr)

        PARM_THETA = 0.
        for j in range(len(COMPORTEMENT)):
            if dComp_incr[j]['RELATION'] == 'ELAS':
                PARM_THETA = dComp_incr[j]['PARM_THETA']

        if PARM_THETA == 0:
            PARM_THETA = dComp_incr[0]['PARM_THETA']

        dComp_incrElas = []
        affe_mo = []
        if __GROUP_MA_A_SEG3 != []:
            comp_seg3 = {'RELATION': 'KIT_CG', 'GROUP_MA':
                         __GROUP_MA_A_SEG3, 'PARM_THETA': PARM_THETA}
            comp_seg3['RELATION_KIT'] = ('ELAS', 'CABLE_GAINE_FROT',)
            dComp_incrElas.append(comp_seg3)
            affe_mo.append({'GROUP_MA': __GROUP_MA_A_SEG3,
                            'PHENOMENE': 'MECANIQUE',
                            'MODELISATION': 'CABLE_GAINE',
                            })
        if __GROUP_MA_A_SEG2 != []:
            dComp_incrElas.append(
                {'RELATION': 'ELAS', 'TOUT': 'OUI', 'PARM_THETA': PARM_THETA})
            affe_mo.append({'GROUP_MA': __GROUP_MA_A_SEG2,
                            'PHENOMENE': 'MECANIQUE',
                            'MODELISATION': 'BARRE',
                            })
        if __GROUP_MA_CABLES_SEG3 != []:
            dComp_incr0.append(_F(RELATION='KIT_CG',
                                  RELATION_KIT=('SANS', 'CABLE_GAINE_FROT',),
                                  GROUP_MA=__GROUP_MA_CABLES_SEG3,))
            if __GROUP_MA_I_SEG3:
                dComp_incr1.append(_F(RELATION='KIT_CG',
                                      RELATION_KIT=(
                                          'SANS', 'CABLE_GAINE_FROT',),
                                      GROUP_MA=__GROUP_MA_I_SEG3,))

        if __GROUP_MA_CABLES_SEG2 != []:
            dComp_incr0.append(
                _F(RELATION='SANS', GROUP_MA=__GROUP_MA_CABLES_SEG2,))
            if __GROUP_MA_I_SEG2:
                dComp_incr1.append(
                    _F(RELATION='SANS', GROUP_MA=__GROUP_MA_I_SEG2,))

        # 1.5 Modele contenant uniquement les cables de precontrainte
        # ---------------------------------------------------------
        __MOD = string.ljust(MODELE.nom, 8)
        __MOD1 = __MOD + '.MODELE    .LGRF        '
        __LMAIL = aster.getvectjev(__MOD1)
        __MAIL = string.strip(__LMAIL[0])

        objma = self.get_sd_avant_etape(__MAIL, self)
        __M_CA = AFFE_MODELE(MAILLAGE=objma,
                             AFFE=affe_mo)

        # 1.6 Blocage de tous les noeuds des cables actifs
        # --------------------------------------------------
        __GROUP_MA_A = __GROUP_MA_A_SEG2 + __GROUP_MA_A_SEG3
        _B_CA = AFFE_CHAR_MECA(MODELE=__M_CA,
                               DDL_IMPO=_F(GROUP_MA=__GROUP_MA_A,
                                           DX=0.,
                                           DY=0.,
                                           DZ=0.,),)

        # 1.7 Chargements concernant les cables
        # -------------------------------------
        _C_CN = AFFE_CHAR_MECA(MODELE=__M_CA, **motscles)
        _C_CA = AFFE_CHAR_MECA(MODELE=MODELE, **motscle2)
        _C_CT = AFFE_CHAR_MECA(MODELE=MODELE, **motscle3)
        if CABLE_BP_INACTIF:
            _C_CI = AFFE_CHAR_MECA(MODELE=MODELE, **motscle6)

        # -------------------------------------------------------------
        # 2. CALCULS
        # ------------------------------------------------------------
        #-------------------------------------------------------------------
        # 2.1 Premiere etape : calcul sur le(s) cable(s) et
        #     recuperation des _F_CAs aux noeuds
        #     on travaile entre tmin et tmax
        #-------------------------------------------------------------------
        __EV1 = STAT_NON_LINE(
            MODELE=__M_CA,
            CHAM_MATER=CHAM_MATER,
            CARA_ELEM=CARA_ELEM,
            EXCIT=(_F(CHARGE=_B_CA),
                   _F(CHARGE=_C_CN),),
            COMPORTEMENT =dComp_incrElas,
            INCREMENT =_F(LIST_INST=__LST0,
                          PRECISION=__prec),
            SOLVEUR = dSolveur,
            INFO =INFO,
            TITRE = TITRE,)
        __EV1 = CALC_CHAMP(reuse=__EV1,
                           RESULTAT=__EV1,
                           # GROUP_MA = __GROUP_MA_A,
                           FORCE='FORC_NODA')

        __REA = CREA_CHAMP(
            TYPE_CHAM='NOEU_DEPL_R',
            OPERATION='EXTR',
            RESULTAT=__EV1,
            NOM_CHAM='FORC_NODA',
            INST=__TMAX)

        __REAC0 = CREA_CHAMP(TYPE_CHAM='NOEU_DEPL_R',
                            OPERATION='AFFE',
                            MODELE=MODELE,
                            AFFE=_F(TOUT='OUI',
                                    NOM_CMP=('DX','DY','DZ','DRX','DRY','DRZ','GLIS','SITY'),
                                    VALE=(0.,0.,0.,0.,0.,0.,0.,0.)), )


        __REAC = CREA_CHAMP(TYPE_CHAM='NOEU_DEPL_R',
                            OPERATION='ASSE',
                            MODELE=MODELE,
                            ASSE=(_F(TOUT='OUI',
                                    CHAM_GD=__REAC0,
                                    COEF_R=1.),
                                  _F(GROUP_MA=__GROUP_MA_A,
                                    CHAM_GD=__REA,
                                    COEF_R=-1.), ))

        _F_CA = AFFE_CHAR_MECA(MODELE=MODELE,
                               VECT_ASSE=__REAC)

        #-----------------------------------------------------------------------
        # 2.2 Deuxieme etape : application de la precontrainte sur le beton
        #     en desactivant les cables
        #----------------------------------------------------------------------
        # Regeneration des mots-cles EXCIT passés en argument de la macro
        dExcit = []
        for j in EXCIT:
            dExcit.append(j.cree_dict_valeurs(j.mc_liste))
            for i in dExcit[-1].keys():
                if dExcit[-1][i] == None:
                    del dExcit[-1][i]

        if CABLE_BP_INACTIF:
            dExcit.append(_F(CHARGE=_C_CI),)

        # Creation du mots-cle EXCIT pour le STAT_NON_LINE
        dExcit1 = copy.copy(dExcit)
        dExcit1.append(_F(CHARGE=_C_CA),)
        dExcit1.append(_F(CHARGE=_F_CA,
                          FONC_MULT=__FCT),)

        if self.reuse:
            motscle4['reuse'] = self.reuse

        RES = STAT_NON_LINE(
            MODELE=MODELE,
            CARA_ELEM=CARA_ELEM,
            CHAM_MATER=CHAM_MATER,
            COMPORTEMENT=dComp_incr0,
            INCREMENT=dIncrement,
            ETAT_INIT=dEtatInit,
            METHODE=METHODE,
            CONVERGENCE=dConvergence,
            RECH_LINEAIRE=dRech_lin,
            SOLVEUR=dSolveur,
            ARCHIVAGE=_F(INST=__TINT),
            INFO=INFO,
            TITRE=TITRE,
            EXCIT=dExcit1,
            **motscle4)

        # Recuperation du dernier numero d'ordre pour pouvoir  l'écraser dans
        # RES
        __dico2 = RES.LIST_VARI_ACCES()
        __no = __dico2['NUME_ORDRE'][-1]

        #-----------------------------------------------------------------------
        # 2.2 Troisieme etape : on remet la tension dans les cables
        #----------------------------------------------------------------------
        # Creation du mots-cles EXCIT pour le STAT_NON_LINE
        dExcit2 = copy.copy(dExcit)
        dExcit2.append(_F(CHARGE=_C_CT,))

        # Calcul sur un seul pas (de __TINT a __TMAX)
        RES = STAT_NON_LINE(reuse=RES,
                            ETAT_INIT=_F(EVOL_NOLI=RES),
                            MODELE=MODELE,
                            CHAM_MATER=CHAM_MATER,
                            CARA_ELEM=CARA_ELEM,

                            COMPORTEMENT=dComp_incr1,
                            INCREMENT=_F(LIST_INST=__LST,
                                         PRECISION=__prec),
                            METHODE=METHODE,
                            #                     NEWTON =dNewton,
                            #                     IMPLEX=dImplex,

                            RECH_LINEAIRE=dRech_lin,
                            CONVERGENCE=dConvergence,
                            SOLVEUR=dSolveur,
                            INFO=INFO,
                            TITRE=TITRE,
                            EXCIT=dExcit2,
                            **motscle5
                            )
    elif adher == 'NON':
        motscle4 = {}
        motscle2 = {}
        motscle2 = {}
        motscle2['DDL_IMPO'] = []
        motscle2['RELA_CINE_BP'] = []
        motscle2a = {}
        motscle2a['DDL_IMPO'] = []
        motscle2a['RELA_CINE_BP'] = []
        motscle2b = {}
        motscle2b['DDL_IMPO'] = []
        motscle2b['RELA_CINE_BP'] = []
        motscle5 = {}
        motscle5['DDL_IMPO'] = []
        motscle5['RELA_CINE_BP'] = []
        motscle3 = {}
        motscle3['AFFE'] = [_F(TOUT='OUI', NOM_CMP=('DX','DY','DZ','DRX','DRY','DRZ','GLIS','SITY'),
                                                      VALE=(0.,0.,0.,0.,0.,0.,0.,0.)  )]
        motscle3a = {}
        motscle3a['AFFE'] = [_F(TOUT='OUI', NOM_CMP=('DX','DY','DZ','DRX','DRY','DRZ','GLIS','SITY'),
                                                      VALE=(0.,0.,0.,0.,0.,0.,0.,0.)  )]
        motscle3b = {}
        motscle3b['AFFE'] = [_F(TOUT='OUI', NOM_CMP=('DX','DY','DZ','DRX','DRY','DRZ','GLIS','SITY'),
                                                      VALE=(0.,0.,0.,0.,0.,0.,0.,0.)  )]
        motscle6 = {}
        motscle6['DDL_IMPO'] = []
        __ActifActif = False
        if self.reuse:
            motscle4['reuse'] = self.reuse
        # assert (len(CABLE_BP) == 1)
        # traitement des cables inactifs
        if type(CABLE_BP_INACTIF) is not types.NoneType:
            if not is_sequence(CABLE_BP_INACTIF):
                CABLE_BP_INACTIF0 = CABLE_BP_INACTIF
                CABLE_BP_INACTIF = []
                CABLE_BP_INACTIF.append(CABLE_BP_INACTIF0)
        else:
            CABLE_BP_INACTIF = []
        motscle6 = {}
        motscle6['RELA_CINE_BP'] = []
        for mcabl in CABLE_BP_INACTIF:
            # Creation de mots-cles pour les AFFE_CHAR_MECA
            motscle6['RELA_CINE_BP'].append(_F(CABLE_BP=mcabl,
                                               SIGM_BPEL='NON',
                                               RELA_CINE='OUI',))
        for mcabl in CABLE_BP:
            __TCAB1 = RECU_TABLE(CO=mcabl, NOM_TABLE='CABLE_GL')

            motscle2['RELA_CINE_BP'].append(_F(CABLE_BP=mcabl,
                                               SIGM_BPEL='NON',
                                               RELA_CINE='OUI',))
            motscle5['RELA_CINE_BP'].append(_F(CABLE_BP=mcabl,
                                               SIGM_BPEL='NON',
                                               RELA_CINE='OUI',))

            nb_cable = len(__TCAB1.EXTR_TABLE().NOM_ANCRAGE1.values())
            table_cable = __TCAB1.EXTR_TABLE()

            for icable in xrange(nb_cable):

                __typ_ancr = (table_cable.TYPE_ANCRAGE1.values()[
                              icable], table_cable.TYPE_ANCRAGE2.values()[icable])
                __typ_noeu = (table_cable.TYPE_NOEUD1.values()[
                              icable], table_cable.TYPE_NOEUD2.values()[icable])
                __nom_noeu = (table_cable.NOM_ANCRAGE1.values()[
                              icable], table_cable.NOM_ANCRAGE2.values()[icable])
                __tension = table_cable.TENSION.values()[icable]
                __recul = table_cable.RECUL_ANCRAGE.values()[icable]
                __recul_exists = (__recul != 0)
                __sens = table_cable.SENS.values()[icable]

                actif = 0
                ancr1_passif = 1
                for j in range(2):
                    if string.strip(__typ_ancr[j]) == 'PASSIF':
                        if j == 0:
                            ancr1_passif = -1
                        if string.strip(__typ_noeu[j]) == 'NOEUD':
                            motscle2[
                                'DDL_IMPO'].append(_F(NOEUD=string.strip(__nom_noeu[j]),
                                                      GLIS=0.))
                            if __recul_exists:
                                motscle5[
                                    'DDL_IMPO'].append(_F(NOEUD=string.strip(__nom_noeu[j]),
                                                          GLIS=0.))
                        else:
                            motscle2[
                                'DDL_IMPO'].append(_F(GROUP_NO=string.strip(__nom_noeu[j]),
                                                   GLIS=0.))
                            if __recul_exists:
                                motscle5[
                                    'DDL_IMPO'].append(_F(GROUP_NO=string.strip(__nom_noeu[j]),
                                                          GLIS=0.))
                    else:
                        actif += 1
                        if string.strip(__typ_noeu[j]) == 'NOEUD':
                            motscle3[
                                'AFFE'].append(_F(NOEUD=string.strip(__nom_noeu[j]), NOM_CMP='GLIS',
                                                  VALE=ancr1_passif * __sens * __tension * (-1) ** (j + 1)))
                            if j == 0:
                                motscle3b[
                                    'AFFE'].append(_F(NOEUD=string.strip(__nom_noeu[j]), NOM_CMP='GLIS',
                                                      VALE=__sens * __tension * (-1) ** (j + 1)))
                                motscle2a[
                                    'DDL_IMPO'].append(_F(NOEUD=string.strip(__nom_noeu[j]),
                                                          GLIS=0.))
                            else:
                                motscle3a[
                                    'AFFE'].append(_F(NOEUD=string.strip(__nom_noeu[j]), NOM_CMP='GLIS',
                                                      VALE=ancr1_passif * __sens * __tension * (-1) ** (j + 1)))
                                motscle2b[
                                    'DDL_IMPO'].append(_F(NOEUD=string.strip(__nom_noeu[j]),
                                                          GLIS=0.))
                            if __recul_exists:
                                motscle5[
                                    'DDL_IMPO'].append(_F(NOEUD=string.strip(__nom_noeu[j]),
                                                          GLIS=ancr1_passif * __sens * __recul * (-1) ** (j)))
                        else:
                            motscle3[
                                'AFFE'].append(_F(GROUP_NO=string.strip(__nom_noeu[j]), NOM_CMP='GLIS',
                                                  VALE=ancr1_passif * __sens * __tension * (-1) ** (j + 1)))
                            if j == 0:
                                motscle3b[
                                    'AFFE'].append(_F(GROUP_NO=string.strip(__nom_noeu[j]), NOM_CMP='GLIS',
                                                      VALE=__sens * __tension * (-1) ** (j + 1)))
                                motscle2a[
                                    'DDL_IMPO'].append(_F(GROUP_NO=string.strip(__nom_noeu[j]),
                                                          GLIS=0.))
                            else:
                                motscle3a[
                                    'AFFE'].append(_F(GROUP_NO=string.strip(__nom_noeu[j]), NOM_CMP='GLIS',
                                                      VALE=ancr1_passif * __sens * __tension * (-1) ** (j + 1)))
                                motscle2b[
                                    'DDL_IMPO'].append(_F(GROUP_NO=string.strip(__nom_noeu[j]),
                                                          GLIS=0.))
                            if __recul_exists:
                                motscle5[
                                    'DDL_IMPO'].append(_F(GROUP_NO=string.strip(__nom_noeu[j]),
                                                          GLIS=ancr1_passif * __sens * __recul * (-1) ** (j)))
                if (actif == 2):
                    __ActifActif = True
            # DETRUIRE(CONCEPT=_F(NOM=__TCAB1))

        dExcit = []
        for j in EXCIT:
            dExcit.append(j.cree_dict_valeurs(j.mc_liste))
            for i in dExcit[-1].keys():
                if dExcit[-1][i] == None:
                    del dExcit[-1][i]

        assert(len(motscle3) > 0)
        
        
        # determination des instants finaux de chaque étape
        
        nb_inst_dispo = len(__L2) -1
        nb_etapes = 1
        
        if __ActifActif:
            nb_etapes +=1
        if __recul_exists:
            nb_etapes +=1
        
        if nb_etapes == 1:
            t_fin_etape1 = __TMAX
            t_fin_etape2 = None
            
        elif nb_etapes == 2:
            #if nb_inst_dispo < nb_etapes:
                #__L2[-1:-1] = [__TINT]
                #t_fin_etape1 = __TINT
            #else:
                #[t_fin_etape1]=calc_etape(nb_etapes, __L2)
            #t_fin_etape2 = __TMAX
            #t_fin_etape3 = None
            
            # -------------------
            __L2[-1:-1] = [__TINT]
            t_fin_etape1 = __TINT
            t_fin_etape2 = __TMAX
            t_fin_etape3 = None
            #--------------------
            
        elif nb_etapes == 3:
            #if nb_etapes - nb_inst_dispo == 2:
                #__L2[-1:-1] = [__TINT, __TINT2]
                #t_fin_etape1 = __TINT
                #t_fin_etape2 = __TINT2
            #elif nb_etapes - nb_inst_dispo == 1:
                #t_fin_etape1 = __L2[-2]
                #__L2[-1:-1] = [__TINT]
                #t_fin_etape2 = __TINT
            #else:
                #[t_fin_etape1,t_fin_etape2]=calc_etape(nb_etapes, __L2)
            #t_fin_etape3 = __TMAX
            
            #------------------------------
            __L2[-1:-1] = [__TINT, __TINT2]
            t_fin_etape1 = __TINT
            t_fin_etape2 = __TINT2
            t_fin_etape3 = __TMAX
            #------------------------------
            
        __LSTR = DEFI_LIST_REEL(VALE=__L2,)
        __LST  = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__LSTR),)
        dIncrement['LIST_INST'] = __LST
        
        print 't_fin_etape1 ',t_fin_etape1
        print 't_fin_etape2 ',t_fin_etape2
        
        # construction des fonctions multiplicatrices
        
        __FCT1 = DEFI_FONCTION(INTERPOL=('LIN', 'LIN'),
                              NOM_PARA='INST',
                              VALE=(__TMIN, 0.0, t_fin_etape1, 1.0),)
        if nb_etapes >=2:
            __FCT2 = DEFI_FONCTION(INTERPOL=('LIN', 'LIN'),
                              NOM_PARA='INST',
                              VALE=(t_fin_etape1, 0.0, t_fin_etape2, 1.0),)
        if nb_etapes ==3:
            __FCT3 = DEFI_FONCTION(INTERPOL=('LIN', 'LIN'),
                              NOM_PARA='INST',
                              VALE=(t_fin_etape2, 0.0, t_fin_etape3, 1.0),)
        
        if CABLE_BP_INACTIF:
            _C_CI = AFFE_CHAR_MECA(MODELE=MODELE, **motscle6)
            dExcit.append(_F(CHARGE=_C_CI,))
        
        # pour recul d'ancrage
        _C_RA = AFFE_CHAR_MECA(MODELE=MODELE, **motscle5)
        dExcit2 = copy.copy(dExcit)
        
        
        if __ActifActif:
            dExcit1a = copy.copy(dExcit)
            dExcit1b = copy.copy(dExcit)
            # force de tension + liaisons cables-béton (motscle2)
            __CH1a = CREA_CHAMP(
                TYPE_CHAM='NOEU_DEPL_R', OPERATION='AFFE', MODELE=MODELE,
                          **motscle3a)
            __CH1b = CREA_CHAMP(
                TYPE_CHAM='NOEU_DEPL_R', OPERATION='AFFE', MODELE=MODELE,
                          **motscle3b)
            _C_CAc = AFFE_CHAR_MECA(MODELE=MODELE, VECT_ASSE=__CH1a,)
            _C_CAd = AFFE_CHAR_MECA(MODELE=MODELE, VECT_ASSE=__CH1b,)
            dExcit1a.append(_F(CHARGE=_C_CAc, FONC_MULT = __FCT1))
            dExcit1b.append(_F(CHARGE=_C_CAd, FONC_MULT = __FCT2))
            
            _C_CAe = AFFE_CHAR_MECA(MODELE=MODELE, **motscle2)
            _C_CAf = AFFE_CHAR_MECA(MODELE=MODELE, **motscle2)
            dExcit1a.append(_F(CHARGE=_C_CAe,))
            dExcit1b.append(_F(CHARGE=_C_CAf,))

            # blocage glissement aux noeuds d'ancrage opposés
            _C_CAa = AFFE_CHAR_MECA(MODELE=MODELE, **motscle2a)
            _C_CAb = AFFE_CHAR_MECA(MODELE=MODELE, **motscle2b)
            dExcit1a.append(_F(CHARGE=_C_CAa,TYPE_CHARGE='DIDI'))
            dExcit1b.append(_F(CHARGE=_C_CAb,TYPE_CHARGE='DIDI'))
            
            if __recul_exists:
                dExcit2.append(_F(CHARGE=_C_RA, TYPE_CHARGE='DIDI',
                                  FONC_MULT = __FCT3),)
            
        else:
            dExcit1 = copy.copy(dExcit)
            # force de tension
            __CH1 = CREA_CHAMP(
                TYPE_CHAM='NOEU_DEPL_R', OPERATION='AFFE', MODELE=MODELE,
                          **motscle3)
            _C_CA1 = AFFE_CHAR_MECA(MODELE=MODELE, VECT_ASSE=__CH1,)
            dExcit1.append(_F(CHARGE=_C_CA1, FONC_MULT = __FCT1),)
            
            # blocage glissement aux noeuds d'ancrage opposés
            # et liaisons cables-béton
            _C_CA = AFFE_CHAR_MECA(MODELE=MODELE, **motscle2)
            dExcit1.append(_F(CHARGE=_C_CA, TYPE_CHARGE='DIDI'),)
            
            if __recul_exists:
                dExcit2.append(_F(CHARGE=_C_RA, TYPE_CHARGE='DIDI',
                                  FONC_MULT = __FCT2),)

        dIncrement['INST_FIN'] = t_fin_etape1
        if __ActifActif:
            RES = STAT_NON_LINE(
                                MODELE=MODELE,
                                CARA_ELEM=CARA_ELEM,
                                CHAM_MATER=CHAM_MATER,
                                COMPORTEMENT=COMPORTEMENT,
                                INCREMENT=dIncrement,
                                NEWTON=_F(REAC_ITER=1),
                                ETAT_INIT=ETAT_INIT,
                                METHODE=METHODE,
                                CONVERGENCE=CONVERGENCE,
                                RECH_LINEAIRE=RECH_LINEAIRE,
                                SOLVEUR=SOLVEUR,
                                INFO=INFO,
                                TITRE=TITRE,
                                EXCIT=dExcit1a,
                                **motscle4)
            
            dIncrement['INST_FIN'] = t_fin_etape2

            RES = STAT_NON_LINE(reuse=RES,
                                ETAT_INIT=_F(EVOL_NOLI=RES),
                                MODELE=MODELE,
                                CARA_ELEM=CARA_ELEM,
                                CHAM_MATER=CHAM_MATER,
                                COMPORTEMENT=COMPORTEMENT,
                                INCREMENT=dIncrement,
                                NEWTON=_F(REAC_ITER=1),
                                METHODE=METHODE,
                                CONVERGENCE=CONVERGENCE,
                                RECH_LINEAIRE=RECH_LINEAIRE,
                                SOLVEUR=SOLVEUR,
                                INFO=INFO,
                                TITRE=TITRE,
                                EXCIT=dExcit1b,)

        else:
            RES = STAT_NON_LINE(
                                MODELE=MODELE,
                                CARA_ELEM=CARA_ELEM,
                                CHAM_MATER=CHAM_MATER,
                                COMPORTEMENT=COMPORTEMENT,
                                INCREMENT=dIncrement,
                                NEWTON=_F(REAC_ITER=1),
                                METHODE=METHODE,
                                ETAT_INIT=ETAT_INIT,
                                CONVERGENCE=CONVERGENCE,
                                RECH_LINEAIRE=RECH_LINEAIRE,
                                SOLVEUR=SOLVEUR,
                                INFO=INFO,
                                TITRE=TITRE,
                                EXCIT=dExcit1,
                                **motscle4)
            
            
        if __recul_exists:
            
            dIncrement['INST_FIN'] = __TMAX
            
            RES = STAT_NON_LINE(reuse=RES,
                                ETAT_INIT=_F(EVOL_NOLI=RES),
                                MODELE=MODELE,
                                CARA_ELEM=CARA_ELEM,
                                CHAM_MATER=CHAM_MATER,
                                COMPORTEMENT=COMPORTEMENT,
                                INCREMENT=dIncrement,
                                NEWTON=_F(REAC_ITER=1),
                                METHODE=METHODE,
                                CONVERGENCE=CONVERGENCE,
                                RECH_LINEAIRE=RECH_LINEAIRE,
                                SOLVEUR=SOLVEUR,
                                INFO=INFO,
                                TITRE=TITRE,
                                EXCIT=dExcit2,
                                )

    else:
        raise Exception(
            "erreur de programmation, adher different de OUI et NON")

    RetablirAlarme('COMPOR4_70')
    return ier
