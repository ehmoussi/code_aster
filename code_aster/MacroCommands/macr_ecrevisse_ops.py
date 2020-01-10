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

import copy

from Contrib.calc_ecrevisse import CALC_ECREVISSE
from Utilitai.Table import merge
from Utilitai.Utmess import UTMESS, MasquerAlarme, RetablirAlarme

from ..Cata.Syntax import _F
from ..Commands import (AFFE_MATERIAU, CO, CREA_TABLE, DEFI_LIST_REEL,
                        DETRUIRE, PROJ_CHAMP, STAT_NON_LINE, THER_LINEAIRE)
from ..Objects import EntityType


def macr_ecrevisse_ops(self, **args):
    """
    Procédure de couplage Code_Aster-Ecrevisse.
    Exécution pour tous les pas de temps des calculs thermiques, mécaniques puis hydrauliques.
    Découpage/Génération par Aster du fichier de données d'Ecrevisse et lancement d'Ecrevisse.
    """

    #import warnings
    #warnings.warn("MACR_ECREVISSE must be refactored!", RuntimeWarning)
    #return

    CONV_CRITERE = args.get("CONV_CRITERE")
    TABLE = args.get("TABLE")
    TEMPER = args.get("TEMPER")
    DEBIT = args.get("DEBIT")
    MODELE_MECA = args.get("MODELE_MECA")
    MODELE_THER = args.get("MODELE_THER")
    FISSURE = args.get("FISSURE")
    ECOULEMENT = args.get("ECOULEMENT")
    LIST_INST = args.get("LIST_INST")
    MODELE_ECRE = args.get("MODELE_ECRE")
    CONVERGENCE_ECREVISSE = args.get("CONVERGENCE_ECREVISSE")
    COURBES = args.get("COURBES")
    LOGICIEL = args.get("LOGICIEL")
    VERSION = args.get("VERSION")
    ENTETE = args.get("ENTETE")
    IMPRESSION = args.get("IMPRESSION")
    CHAM_MATER = args.get("CHAM_MATER")
    TEMP_INIT = args.get("TEMP_INIT")
    CARA_ELEM = args.get("CARA_ELEM")
    CONTACT = args.get("CONTACT")
    EXCIT_MECA = args.get("EXCIT_MECA")
    EXCIT_THER = args.get("EXCIT_THER")
    COMPORTEMENT = args.get("COMPORTEMENT")
    NEWTON = args.get("NEWTON")
    CONVERGENCE = args.get("CONVERGENCE")
    ETAT_INIT = args.get("ETAT_INIT")
    ENERGIE = args.get("ENERGIE")
    INFO = args.get("INFO")

    # Parametres debug
    debug = False

    # Info
    InfoAster = 1
    info2 = (INFO == 2)
    if debug:
        info2 = True

    # IMPORTATION DE COMMANDES ASTER


    # alarme de STAT_NON_LINE si les mot-cles de COMPORTEMENT sont renseignes
    # a tort
    MasquerAlarme('COMPOR4_70')

    IsPoursuite = False
    IsInit = True
    # Traitement de l'etat initial en cas de poursuite
    if ETAT_INIT:
        dEtatInit = ETAT_INIT[0].cree_dict_toutes_valeurs()
        EVINIT = dEtatInit['EVOL_NOLI']
        _THINIT = dEtatInit['EVOL_THER']
        nume_ordre = dEtatInit['NUME_ORDRE']
        IsPoursuite = True
    else:
        dEtatInit = None

    # RECUPERATION DES MOTS-CLES FACTEURS

    l_dFISSURE = []
    for fissure in FISSURE:
        dFISSURE = fissure.cree_dict_toutes_valeurs()
        l_dFISSURE.append(dFISSURE)

    dECOULEMENT = ECOULEMENT[0].cree_dict_toutes_valeurs()
    # on ne supprime pas les valeurs None
    dMODELE_ECRE = MODELE_ECRE[0].cree_dict_valeurs(MODELE_ECRE[0].mc_liste)
    dCONVERGENCE_ECREVISSE = CONVERGENCE_ECREVISSE[
        0].cree_dict_toutes_valeurs()
    dCOMPORTEMENT = COMPORTEMENT[0].cree_dict_toutes_valeurs()
    dNEWTON = NEWTON[0].cree_dict_toutes_valeurs()
    dCONVERGENCE = CONVERGENCE[0].cree_dict_toutes_valeurs()

    # Recuperation des infos pour la convergence de la macro
    dMacr_Conv = CONV_CRITERE[0].cree_dict_toutes_valeurs()
    motclefsCALC_ECREVISSE = {}
    motclefsCALC_ECREVISSE['COURBES'] = COURBES,

    # --------------------------------------------------------------------------
    # Debut de la macro

    # Si LIST_INST est un DEFI_LIST_REEL :
    liste_inst = LIST_INST.getValues()
    if (debug):
        print('liste des instants liste_inst = ', liste_inst)

    # Drapeaux pour les 1ers calculs et les 1eres definitions
    # si l'execution d'Ecrevisse n'a pas plantee ou a ete realisee
    EcrevisseExe = False

    # Table python devant contenir toutes les tables Ecrevisse
    T_TABL_RES = None
    T_DEB_RES = None
    # Precision demandee pour converger sur le critere de la macro
    # Nombre de decoupages succesifs d'un pas de temps
    # Pas de temps en dessous duquel on ne decoupe plus
    if 'SUBD_NIVEAU' in dMacr_Conv:
        MacrNbDecoupage = dMacr_Conv['SUBD_NIVEAU']
    if 'SUBD_PAS_MINI' in dMacr_Conv:
        MacrPasMini = dMacr_Conv['SUBD_PAS_MINI']
    MacrTempRef = dMacr_Conv['TEMP_REF']
    MacrPresRef = dMacr_Conv['PRES_REF']
    MacrCritere = dMacr_Conv['CRITERE']
    if 'PREC_CRIT' in dMacr_Conv:
        MacrPrecisCritere = dMacr_Conv['PREC_CRIT']
    else:
        MacrPrecisCritere = None
    if 'NUME_ORDRE_MIN' in dMacr_Conv:
        MacrNumeOrdre = dMacr_Conv['NUME_ORDRE_MIN']

    #
    # il faut 2 pas au minimum dans la liste
    if (len(liste_inst) < 2):
        UTMESS('F', 'ECREVISSE0_20', vali=[2])

    if (not IsPoursuite):
        nume_ordre = 0
    else:
        # Dans le cas d'une poursuite :
        # On reconstruit une nouvelle liste d'instant composee de l'ancienne liste
        # jusqu'a l'instant recherche, puis de la nouvelle a partir de cet instant
        # ainsi le nume_ordre de la nouvelle liste correspond au nume_ordre de
        # l'ancienne
        __dico1 = _THINIT.LIST_VARI_ACCES()
        _list_precedente = __dico1['INST']
        _list_numordre_prec = __dico1['NUME_ORDRE']
        try:
            idx_last = _list_numordre_prec.index(nume_ordre)
        except:
            UTMESS('F', 'ECREVISSE0_25', vali=nume_ordre)

        _inst_init = _list_precedente[idx_last]
        new_list = _list_precedente[0:idx_last + 1]

        try:
            # si l'instant est dans la liste, on recupere l'index
            _idx = liste_inst.index(_inst_init)
            _idx += 1
        except:
            # on cherche le plus proche
            _idx = 0
            if _inst_init >= liste_inst[-1]:
                UTMESS('F', 'ECREVISSE0_26', valr=[
                       liste_inst[-1], _inst_init])

            for t in liste_inst:
                if t > _inst_init:
                    break
                _idx += 1

        # liste precedent jusqu'a l'instant a recalculer (inclus, ca permet de gerer
        # le cas ou l'instant a recalculer n'est pas dans la nouvelle liste : il sera ajoute)
        # on lui ajoute la nouvelle liste a partir du l'instant a recalculer
        new_list.extend(liste_inst[_idx:])
        liste_inst = copy.copy(new_list)

    #
    # Debut boucle sur la liste d'instant
    #
    RTHERM = None
    FinBoucle = False
    while (not FinBoucle):
        inst = liste_inst[nume_ordre]
        if (debug):
            print('Instant debut boucle', inst)
        # On boucle jusqu'a convergence
        NbIter = 0
        while True:
            if ((not IsPoursuite) or EcrevisseExe):
            # Le temps que l'on traite
                inst_p_un = liste_inst[nume_ordre + 1]
                IsInitEcre = False
                # Construction de la liste des pas
                __pas = DEFI_LIST_REEL(VALE=liste_inst, )
                if (debug):
                    print('=====> ===== ===== ===== <====')
                    print('Iteration numero : ', NbIter)
                    print('Instant          : ', inst)
                    print('Instant+1        : ', inst_p_un)
                    print('nume_ordre       : ', nume_ordre + 1)
                    print('Donnee Ecrevisse : ', EcrevisseExe)

                # ---------------------
                #        THERMIQUE
                # ---------------------
                # Recuperation des chargements thermiques
                _dEXCIT_THER = []
                if EXCIT_THER:
                    for excit_i in EXCIT_THER:
                        dEXCIT_THER_i = excit_i.cree_dict_toutes_valeurs()
                        _dEXCIT_THER.append(dEXCIT_THER_i)

                # Definition des chargements thermiques venant d Ecrevisse
                if (EcrevisseExe):
                    _dEXCIT_THER.append(_F(CHARGE=FLU1ECR0))
                    _dEXCIT_THER.append(_F(CHARGE=FLU2ECR0))

                # Definition de l'etat initial
                motclefs = {}
                if (nume_ordre == 0):
                    motclefs['ETAT_INIT'] = [
                        _F(VALE=TEMP_INIT, NUME_ORDRE=nume_ordre)]
                    if (debug):
                        print('thermique initialise avec tref')
                else:
                    if (IsInit):
                    # if (IsPoursuite) :
                        motclefs['reuse'] = _THINIT
                        motclefs['ETAT_INIT'] = [
                            _F(EVOL_THER=_THINIT, NUME_ORDRE=nume_ordre)]
                        if (debug):
                            print('thermique initialise avec etat_initial')
                    else:
                        motclefs['reuse'] = RTHERM
                        motclefs['ETAT_INIT'] = [
                            _F(EVOL_THER=RTHERM, NUME_ORDRE=nume_ordre)]
                        if (debug):
                            print('thermique initialise avec instant precedent')

                if (debug):
                    print('====> THER_LINEAIRE <====')
                    print('   Les charges thermiques')
                    print(EXCIT_THER)

                if IsPoursuite:
                    _THINIT = THER_LINEAIRE(
                        MODELE=MODELE_THER,
                        CHAM_MATER=CHAM_MATER,
                        EXCIT=_dEXCIT_THER,
                        INCREMENT=_F(LIST_INST=__pas,
                                     NUME_INST_INIT=nume_ordre,
                                     NUME_INST_FIN=nume_ordre + 1,),
                        INFO=InfoAster,
                        **motclefs)

                    _RTHMPJ = PROJ_CHAMP(RESULTAT=_THINIT,
                                         MODELE_1=MODELE_THER,
                                         MODELE_2=MODELE_MECA,
                                         METHODE='COLLOCATION',
                                         VIS_A_VIS=_F(TOUT_1='OUI',
                                                      TOUT_2='OUI',),
                                         INFO=2,)
                    RTHERM = _THINIT
                else:
                    RTHERM = THER_LINEAIRE(
                        MODELE=MODELE_THER,
                        CHAM_MATER=CHAM_MATER,
                        EXCIT=_dEXCIT_THER,
                        INCREMENT=_F(LIST_INST=__pas,
                                     NUME_INST_INIT=nume_ordre,
                                     NUME_INST_FIN=nume_ordre + 1,),
                        INFO=InfoAster,
                        **motclefs)

                    # Projection du champ thermique, a tous les instants
                    # sinon pas de deformations thermiques
                    _RTHMPJ = PROJ_CHAMP(RESULTAT=RTHERM,
                                         MODELE_1=MODELE_THER,
                                         MODELE_2=MODELE_MECA,
                                         METHODE='COLLOCATION',
                                         VIS_A_VIS=_F(TOUT_1='OUI',
                                                      TOUT_2='OUI',),
                                         INFO=2,)
                # Definition du materiau pour la mecanique
                # note : on doit le faire a chaque fois car le nom de concept _RTHMPJ
                #        est different a chaque passage
                motclefmater = {}
                vecTmp = CHAM_MATER.getVectorOfPartOfMaterialOnMesh()
                motclefmater['AFFE'] = []
                for item in vecTmp:
                    dictToAdd = {}
                    meshEntity = item.getMeshEntity()
                    entityType = meshEntity.getType()
                    if entityType is EntityType.GroupOfElementsType:
                        dictToAdd["GROUP_MA"] = meshEntity.getNames()
                    elif entityType is EntityType.ElementType:
                        dictToAdd["MAILLE"] = meshEntity.getNames()
                    elif entityType is EntityType.AllMeshEntitiesType:
                        dictToAdd["TOUT"] = "OUI"
                    else:
                        raise TypeError("Unexpected type for mesh entity: {0}".format(meshEntity))
                    dictToAdd["MATER"] = item.getVectorOfMaterial()
                    motclefmater['AFFE'].append(dictToAdd)
                motclefmater['MAILLAGE'] = CHAM_MATER.getMesh()

                # Set external state variables
                motclefmater['AFFE_VARC'] = []
                motclefmater['AFFE_VARC'] = [_F(NOM_VARC = 'TEMP', VALE_REF = TEMP_INIT, EVOL = _RTHMPJ)]

                __MATMEC = AFFE_MATERIAU(
                    **motclefmater
                )

                # ---------------------
                #        MECANIQUE
                # ---------------------
                _dEXCIT_MECA = []
                # Recuperation des chargements mecaniques
                if EXCIT_MECA:
                    for excit_i in EXCIT_MECA:
                        dEXCIT_MECA_i = excit_i.cree_dict_toutes_valeurs()
                        _dEXCIT_MECA.append(dEXCIT_MECA_i)

                # Definition des chargements venant d'Ecrevisse
                if (EcrevisseExe):
                    _dEXCIT_MECA.append(_F(CHARGE=MECAECR0))

                motclefs = {}
                if (not IsPoursuite):
                    if (nume_ordre != 0):
                        motclefs['reuse'] = MECANIC
                        motclefs['ETAT_INIT'] = [
                            _F(EVOL_NOLI=MECANIC, NUME_ORDRE=nume_ordre)]
                        if (debug):
                            print('etat meca initial = pas precedent')
                    else:
                        if (debug):
                            print('etat meca initial : vierge')
                else:
                    motclefs['reuse'] = EVINIT
                    motclefs['ETAT_INIT'] = [
                        _F(EVOL_NOLI=EVINIT, NUME_ORDRE=nume_ordre)]
                    if (debug):
                        print('etat meca initial dReuseM', motclefs)

                if ENERGIE:
                    motclefs['ENERGIE'] = ENERGIE[
                        0].cree_dict_valeurs(ENERGIE[0].mc_liste)

                if (debug):
                    print('====> STAT_NON_LINE <====')
                if (debug):
                    print('   Les charges mecaniques')
                    print(_dEXCIT_MECA)

                MECANIC = STAT_NON_LINE(
                    MODELE=MODELE_MECA,
                    CHAM_MATER=__MATMEC,
                    CARA_ELEM=CARA_ELEM,
                    CONTACT=CONTACT,
                    EXCIT=_dEXCIT_MECA,
                    COMPORTEMENT=_F(**dCOMPORTEMENT),
                    INCREMENT=_F(LIST_INST=__pas,
                                 NUME_INST_INIT=nume_ordre,
                                 NUME_INST_FIN=nume_ordre + 1,),
                    NEWTON=_F(**dNEWTON),
                    CONVERGENCE=_F(**dCONVERGENCE),
                    INFO=InfoAster,
                    **motclefs
                )
                # Destruction des concepts
                #  Thermique projete
                #  Liste des pas
                DETRUIRE(CONCEPT=(_F(NOM=_RTHMPJ),
                                  _F(NOM=__pas),),
                         INFO=1)

            else:
                #      CAS OU LA MACRO EST REENTRANTE : ON RELANCE ECREVISSE POUR CONNAITRE
                # LES CHARGEMENT A UTILISER POUR LES PROBLEMES THERMIQUES ET
                # MECANIQUES
                inst_p_un = inst
                IsInitEcre = True

            # -----------------------------------------------------------------------
            #        ECREVISSE : ATTENTION SI REPRISE CALCUL, ON RECALCULE LE DERNIER INSTANT
            # -------------------------------------------------------------------------
            # Si Ecrevisse a deja ete fait une fois.
            #   ==> Efface les concepts qui sont en sortie
            if (EcrevisseExe):
                DETRUIRE(
                    CONCEPT=(
                        _F(NOM=MECAECR1),
                        _F(NOM=FLU1ECR1),
                        _F(NOM=FLU2ECR1),
                        _F(NOM=TABLECR1),
                        _F(NOM=DEBIECR1),
                    ), INFO=1)

            # On remplace FONC_XXX par la valeur XXX correspondante a l'instant
            # inst_p_un
            dECOULEMENT_ecrevisse = copy.copy(dECOULEMENT)
            for fonc_name in [
                "PRES_ENTREE_FO", "PRES_SORTIE_FO", "PRES_PART_FO",
                    "TITR_MASS_FO", "TEMP_ENTREE_FO"]:
                if fonc_name in dECOULEMENT:
                    fonc = dECOULEMENT_ecrevisse.pop(fonc_name)
                    vale_name = fonc_name.replace('_FO', '')
                    dECOULEMENT_ecrevisse[vale_name] = fonc(inst_p_un)

            if (debug):
                print('====> ECREVISSE entree dans CALC_ECREVISSE <====')

            if (not IsPoursuite):
                CALC_ECREVISSE(
                    CHARGE_MECA=CO('MECAECR1'),
                    CHARGE_THER1=CO('FLU1ECR1'),
                    CHARGE_THER2=CO('FLU2ECR1'),
                    TABLE=CO('TABLECR1'),
                    DEBIT=CO('DEBIECR1'),
                    MODELE_MECA=MODELE_MECA,
                    MODELE_THER=MODELE_THER,
                    ENTETE=ENTETE,
                    IMPRESSION=IMPRESSION,
                    INFO=INFO,
                    RESULTAT=_F(THERMIQUE=RTHERM,
                                MECANIQUE=MECANIC,
                                INST=inst_p_un, ),
                    # chemin d acces a Ecrevisse
                    LOGICIEL=LOGICIEL,
                    VERSION=VERSION,
                    # donnees necessaire pour ecrevisse
                    # assurer la coherence des donnees en fonction
                    # de FLUIDE_ENTREE = iflow (voir doc Ecrevisse)
                    # activation eventuelle de TITR_VA et P_AIR
                    FISSURE=l_dFISSURE,
                    ECOULEMENT=_F(**dECOULEMENT_ecrevisse),
                    MODELE_ECRE=_F(**dMODELE_ECRE),

                    CONVERGENCE=_F(**dCONVERGENCE_ECREVISSE),
                    **motclefsCALC_ECREVISSE
                )
            else:
                CALC_ECREVISSE(
                    CHARGE_MECA=CO('MECAECR1'),
                    CHARGE_THER1=CO('FLU1ECR1'),
                    CHARGE_THER2=CO('FLU2ECR1'),
                    TABLE=CO('TABLECR1'),
                    DEBIT=CO('DEBIECR1'),
                    MODELE_MECA=MODELE_MECA,
                    MODELE_THER=MODELE_THER,
                    ENTETE=ENTETE,
                    IMPRESSION=IMPRESSION,
                    INFO=INFO,
                    RESULTAT=_F(THERMIQUE=_THINIT,
                                MECANIQUE=EVINIT,
                                INST=inst_p_un, ),
                    # chemin d acces a Ecrevisse
                    LOGICIEL=LOGICIEL,
                    VERSION=VERSION,
                    # donnees necessaire pour ecrevisse
                    # assurer la coherence des donnees en fonction
                    # de FLUIDE_ENTREE = iflow (voir doc Ecrevisse)
                    # activation eventuelle de TITR_VA et P_AIR
                    FISSURE=l_dFISSURE,
                    ECOULEMENT=_F(**dECOULEMENT_ecrevisse),
                    MODELE_ECRE=_F(**dMODELE_ECRE),

                    CONVERGENCE=_F(**dCONVERGENCE_ECREVISSE),
                    **motclefsCALC_ECREVISSE
                )

            if (debug):
                print('====> ECREVISSE sortie de CALC_ECREVISSE <====')

            # Recuperation des infos de la table resultat Ecrevisse
            T_TABL_TMP1 = TABLECR1.EXTR_TABLE()
            T_DEB_TMP1 = DEBIECR1.EXTR_TABLE()
# On ajoute deux colonnes supplementaires
#         _nb_ligne = len(T_DEB_TMP1["DEBTOT"])
#         T_DEB_TMP1["NUME_ORDRE"] = [nume_ordre+1]*_nb_ligne
#         T_DEB_TMP1["INST"]       = [inst_p_un]*_nb_ligne

            # Le calcul Ecrevisse c'est bien passe ?
            EcrevisseExe = (T_TABL_TMP1.values()['COTES'][0] != -1)
            #
            if (not EcrevisseExe):
                # Destruction des concepts de sortie, et on arrete tout
                DETRUIRE(
                    CONCEPT=(_F(NOM=MECAECR1),
                             _F(NOM=FLU1ECR1),
                             _F(NOM=FLU2ECR1),
                             _F(NOM=TABLECR1),
                             _F(NOM=DEBIECR1),),
                    INFO=1)
                if (not IsInit):
                    DETRUIRE(
                        CONCEPT=(_F(NOM=MECAECR0),
                                 _F(NOM=FLU1ECR0),
                                 _F(NOM=FLU2ECR0),
                                 _F(NOM=TABLECR0),
                                 _F(NOM=DEBIECR0),),
                        INFO=1)
                FinBoucle = True
                break
            #
            # A t'on atteint la convergence
            #  TABLECR0 table Ecrevisse a inst
            #  TABLECR1 table Ecrevisse a inst_p_un
            # --------------------

            if (not IsInit):
                # On recupere la liste des temperatures a t et t+1
                lst_T_0 = T_TABL_TMP0.values()['TEMP']
                lst_T_1 = T_TABL_TMP1.values()['TEMP']
                # Le maximum des ecarts
                lst_T_diff_01 = []
                for v1, v2 in zip(lst_T_0, lst_T_1):
                    lst_T_diff_01.append(abs(v1 - v2))
                max_T_diff_01 = max(lst_T_diff_01)

                # On recupere la liste des pressions a t et t+1
                lst_P_0 = T_TABL_TMP0.values()['PRESSION']
                lst_P_1 = T_TABL_TMP1.values()['PRESSION']
                # Le maximum des ecarts
                lst_P_diff_01 = []
                for v1, v2 in zip(lst_P_0, lst_P_1):
                    lst_P_diff_01.append(abs(v1 - v2))
                max_P_diff_01 = max(lst_P_diff_01)
                #
                # "TEMP_PRESS","EXPLICITE","TEMP","PRESS"
                ErreurT = (max_T_diff_01 / MacrTempRef)
                ErreurP = (max_P_diff_01 / MacrPresRef)
                ErreurG = (ErreurT ** 2 + ErreurP ** 2) ** 0.5
                if (MacrCritere == 'TEMP'):
                    Erreur = ErreurT
                elif (MacrCritere == 'PRESS'):
                    Erreur = ErreurP
                else:
                    Erreur = ErreurG

                if (MacrCritere != 'EXPLICITE'):
                    Convergence = (Erreur <= MacrPrecisCritere)
                #
                if info2:
                        # Info Critere
                    UTMESS('I', 'ECREVISSE0_35', valr=inst_p_un,
                           valk=[MacrCritere, MacrPrecisCritere, Convergence])
                    # Info Convergence
                    UTMESS('I', 'ECREVISSE0_34',
                           valr=[inst_p_un, ErreurT, max_T_diff_01, ErreurP, max_P_diff_01, ErreurG])

            else:
                Convergence = True
                if info2:
                    UTMESS('I', 'ECREVISSE0_36', valr=[inst_p_un])
            # --------------------
            #

            if (MacrCritere == 'EXPLICITE'):
                Convergence = True
            else:
                if ((nume_ordre != 0) and (nume_ordre + 1 <= MacrNumeOrdre)):
                    UTMESS('A', 'ECREVISSE0_33',
                           vali=[nume_ordre + 1, MacrNumeOrdre], valr=inst_p_un)
                    Convergence = True

            if (Convergence):
                nb_lignes_t1 = len(T_TABL_TMP1["COTES"])
                # Ajout de deux colonnes supplementaires
                # POUR LA TABLE ECREVISSE
                T_TABL_TMP1["NUME_ORDRE"] = [nume_ordre + 1] * nb_lignes_t1
                T_TABL_TMP1["INST"] = [inst_p_un] * nb_lignes_t1

                # POUR LA TABLE DES DEBITS
                nb_ligne_t2 = len(T_DEB_TMP1["DEBTOT"])
                T_DEB_TMP1["NUME_ORDRE"] = [nume_ordre + 1] * nb_ligne_t2
                T_DEB_TMP1["INST"] = [inst_p_un] * nb_ligne_t2

                # Ajout des infos dans la table finale
                if (IsInit):
                    T_TABL_RES = T_TABL_TMP1
                    T_DEB_RES = T_DEB_TMP1
                else:
                    T_TABL_RES = merge(T_TABL_RES, T_TABL_TMP1)
                    T_DEB_RES = merge(T_DEB_RES, T_DEB_TMP1)
                    T_TABL_RES.titr = 'TABLE_SDASTER CHARGEMENT ECREVISSE'
                    T_DEB_RES.titr = 'TABLE_SDASTER DEBIT ECREVISSE'
                #
                # RAZ des compteurs de division
                NbIter = 0
                # On memorise les concepts valides
                MECAECR0 = MECAECR1
                FLU1ECR0 = FLU1ECR1
                FLU2ECR0 = FLU2ECR1
                TABLECR0 = TABLECR1
                DEBIECR0 = DEBIECR1
                #
                T_TABL_TMP0 = T_TABL_TMP1
                if (not IsInitEcre):
                    IsInit = False
                if (info2):
                    UTMESS('I', 'ECREVISSE0_37', valr=[inst_p_un])
                break

            else:
                NbIter += 1
                # A t'on le droit de decouper, par rapport au nombre de
                # division
                if (NbIter > MacrNbDecoupage):
                    FinBoucle = True
                    UTMESS('A', 'ECREVISSE0_30', valr=[inst, inst_p_un],
                           vali=[MacrNbDecoupage])
                    break
                #
                # on divise le pas de temps par 2
                tmp = (inst + inst_p_un) * 0.5
                # A t'on le droit de continuer, par rapport au pas de temps
                # minimum
                if ((tmp - inst) <= MacrPasMini):
                    FinBoucle = True
                    UTMESS('A', 'ECREVISSE0_31', valr=[
                           inst, inst_p_un, tmp, MacrPasMini])
                    break
                #
                if (info2):
                    UTMESS('A', 'ECREVISSE0_32', valr=[
                           inst, inst_p_un, tmp], vali=[NbIter])
                # on insere le nouveau temps dans la liste des instants avant
                # "inst_p_un"
                liste_inst.insert(nume_ordre + 1, tmp)

        # Convergence atteinte, on passe au pas de temps suivant, s'il en reste
        if IsInitEcre:
            continue
        elif (nume_ordre + 2 < len(liste_inst)):
            nume_ordre += 1
        else:
            # On a fait tous les pas de temps
            FinBoucle = True
    #
    #     Fin boucle sur les pas de temps
    #

    if RTHERM is not None and TEMPER is not None:
        self.register_result(RTHERM, TEMPER)

    # Creation du concept de la table en sortie
    if (T_TABL_RES is not None):
        dprod = T_TABL_RES.dict_CREA_TABLE()
        TABL_RES = CREA_TABLE(**dprod)
        self.register_result(TABL_RES, TABLE)
    if (T_DEB_RES is not None):
        debprod = T_DEB_RES.dict_CREA_TABLE()
        DEB_RES = CREA_TABLE(**debprod)
        self.register_result(DEB_RES, DEBIT)

    # Destruction des concepts temporaires
    DETRUIRE(
        CONCEPT=(_F(NOM=MECAECR1),
                 _F(NOM=FLU1ECR1),
                 _F(NOM=FLU2ECR1),
                 _F(NOM=TABLECR1),
                 _F(NOM=DEBIECR1),),
        INFO=1,)

    if (nume_ordre != 0):
        DETRUIRE(
            CONCEPT=(_F(NOM=MECAECR0),
                     _F(NOM=FLU1ECR0),
                     _F(NOM=FLU2ECR0),
                     _F(NOM=TABLECR0),
                     _F(NOM=DEBIECR0),),
            INFO=1,)

    RetablirAlarme('COMPOR4_70')
    return MECANIC
