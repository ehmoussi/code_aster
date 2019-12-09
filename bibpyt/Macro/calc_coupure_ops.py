# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 2019 Aether Engineering Solutions - www.aethereng.com
# Copyright (C) 2019 Kobe Innovation Engineering - www.kobe-ie.com
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
# aslint: disable=W4004

import numpy as NP
import os, math
from Utilitai.Utmess import UTMESS
from Utilitai.Table import Table
from code_aster.Cata.Syntax import _F
from code_aster.Cata.Commands import *
import itertools

import Messages
import aster

filter_columns = ('TOUT_ORDRE','NUME_ORDRE','NUME_MODE','LIST_ORDRE','LIST_MODE','FREQ','LIST_FREQ','NOM_CAS', 'CRITERE', 'PRECISION')
inte_by_efge = {'N':'NYY', 'VPL':'NXY', 'MHP':'MYY', 'VHP':'QY', 'MPL':'NYY'}
efge_comps = ('NXX', 'NYY', 'NXY', 'MXX', 'MYY', 'MXY','QX','QY')
space_dirs = ('X', 'Y', 'Z')

def calc_comb_modes(__tbresul, myintitule_by_num, comb_modes, resu, b_extrac, resu_nume_ordre):
    """
    Calcul des combinaisons modales à partir des résultantes
    Ajoute nouvelles lignes dans __tbresul
    """
    __nresu=EXTR_MODE(FILTRE_MODE=_F(MODE=resu, **b_extrac),IMPRESSION =_F(CUMUL='OUI'))
    # ~ __nresu=NORM_MODE(reuse=__nresu, MODE=__nresu,NORME='MASS_GENE',)
    __tbmodpar=RECU_TABLE(CO=__nresu,NOM_PARA = ('FREQ','FACT_PARTICI_DX','FACT_PARTICI_DY','FACT_PARTICI_DZ'))
    # ~ IMPR_TABLE(TABLE=__tbmodpar)
    resu_partab = __tbmodpar.EXTR_TABLE().values()
    DETRUIRE(CONCEPT=_F(NOM=(__nresu, __tbmodpar)))    
    l_freq = resu_partab['FREQ']
    l_omega = [2 * math.pi * f for f in l_freq]           
    pytbcoup = __tbresul.EXTR_TABLE()
    for comb_num, comb in enumerate(comb_modes, 1):
        comb_by_key = comb.cree_dict_toutes_valeurs()
        nappe_acces = comb['SPEC_OSCI']
        echelles = comb['ECHELLE']
        mode_signs = comb['MODE_SIGNE']
        comb_intitule = comb['NOM_CAS']
        if comb_intitule is None:
            comb_intitule = "comb%d"%comb_num
        if comb['AMOR_REDUIT'] is not None:
            l_amor = list(comb['AMOR_REDUIT'])
        else:
            l_amor = comb['LIST_AMOR'].Valeurs()
        if len(l_amor) == 1:
            l_amor = l_amor * len(resu_nume_ordre)             
        for lign_num in myintitule_by_num.keys():
            l_ri_by_comp = ((pytbcoup.INTITULE == myintitule_by_num[lign_num]) & (pytbcoup.TYPE == 'RESULTANTE')).values() # INTITULE must be unique and not empty here
            l_Ri_by_inte_by_space = {c:{inte_comp:[] for inte_comp in inte_by_efge.keys()} for c in space_dirs}
            l_fact_by_spacedir = {'X' : resu_partab['FACT_PARTICI_DX'], 'Y' : resu_partab['FACT_PARTICI_DY'], 'Z' : resu_partab['FACT_PARTICI_DZ']}
            for nume_ordre in resu_nume_ordre:
                amor = l_amor[nume_ordre-1]
                freq = l_freq[nume_ordre-1]                
                omega = 2 * math.pi * freq
                # ~ print("omega(%s):%s"%(nume_ordre,omega))
                for spacedir_index, space_dir in enumerate(space_dirs):
                    paras = ['INTITULE','NOM_CHAM','COMB','TYPE','NUME_ORDRE'] # 'FREQ',
                    vales = [myintitule_by_num[lign_num],"EFGE_NOEU",comb_intitule,"RI"+space_dir,nume_ordre]
                    nappe_acce = nappe_acces[spacedir_index]
                    acce = nappe_acce(amor, freq) * echelles[spacedir_index]
                    # ~ print("acce(%s):%s"%(space_dir,acce))
                    fpart = l_fact_by_spacedir[space_dir][nume_ordre-1]
                    # ~ print("fpart(%s):%s"%(space_dir,fpart))
                    for inte_comp in inte_by_efge.keys():
                        r_i = l_ri_by_comp[inte_comp][nume_ordre-1]
                        # ~ print("r_i(%s):%s"%(inte_comp,r_i))
                        R_i = r_i * fpart * acce / (omega ** 2)
                        l_Ri_by_inte_by_space[space_dir][inte_comp].append(R_i)
                        paras.append(inte_comp)
                        vales.append(R_i)
                        # ~ print("R_i(%s):%s"%(space_dir,R_i))
                        # ~ print("-"*72)                        
                    __tbresul=CALC_TABLE(reuse=__tbresul,TABLE=__tbresul,ACTION=_F(OPERATION='AJOUT_LIGNE',NOM_PARA=paras,VALE=vales),)

            Rm_by_inte_by_spacedir = {space_dir:{inte_comp:0.0 for inte_comp in inte_by_efge.keys()} for space_dir in space_dirs}
            for i in resu_nume_ordre:
                omega_i = l_omega[i-1]
                csi_i = l_amor[i-1]
                for j in resu_nume_ordre:
                    omega_j = l_omega[j-1]
                    csi_j = l_amor[j-1]
                    eta = omega_j / omega_i
                    rho_ij = (8*eta*math.sqrt(csi_i*csi_j*eta)*(csi_i+csi_j*eta)) / ((1-eta**2)**2+4*eta*csi_i*csi_j*(1+eta**2)+4*eta**2*(csi_i**2+csi_j**2))
                    #print("rho(%d,%d):%s"%(i,j,rho_ij))
                    for space_dir in space_dirs:
                        for inte_comp in inte_by_efge.keys():
                            R_i = l_Ri_by_inte_by_space[space_dir][inte_comp][i-1]
                            #print("R_i:%s"%R_i)
                            R_j = l_Ri_by_inte_by_space[space_dir][inte_comp][j-1]
                            #print("R_j:%s"%R_j)
                            Rm_by_inte_by_spacedir[space_dir][inte_comp] += rho_ij * R_i * R_j                           
            for spacedir_index, space_dir in enumerate(space_dirs):
                mode_sign = mode_signs[spacedir_index]
                if mode_sign not in resu_nume_ordre:
                    UTMESS('F', 'CALCCOUP_1')
                paras = ['INTITULE','NOM_CHAM','COMB','TYPE']
                vales = [myintitule_by_num[lign_num],"EFGE_NOEU",comb_intitule,"CQC"+space_dir]                                
                for inte_comp in inte_by_efge.keys():
                    R_k = l_Ri_by_inte_by_space[space_dir][inte_comp][mode_sign-1]
                    signR_k = math.copysign(1, R_k)
                    # ~ print("R_k(%s,%s):%s"%(space_dir, inte_comp, R_k))
                    # ~ print("signR_k(%s,%s):%s"%(space_dir, inte_comp, signR_k))
                    Rm_by_inte_by_spacedir[space_dir][inte_comp] = signR_k * math.sqrt(Rm_by_inte_by_spacedir[space_dir][inte_comp])
                    # ~ print("before sign Rm:%s"%math.sqrt(Rm_by_inte_by_spacedir[space_dir][inte_comp]))
                    # ~ print("sign Rm:%s"%Rm_by_inte_by_spacedir[space_dir][inte_comp])
                    paras.append(inte_comp)
                    vales.append(Rm_by_inte_by_spacedir[space_dir][inte_comp])
                #print("Em_by_comp:%s"%Em_by_comp)
                __tbresul=CALC_TABLE(reuse=__tbresul,TABLE=__tbresul,ACTION=_F(OPERATION='AJOUT_LIGNE',NOM_PARA=paras,VALE=vales),)

            Emax_by_inte = {inte_comp:0.0 for inte_comp in inte_by_efge.keys()}
            comb_coefs = (1.0, 0.4, 0.4)
            sym_by_permsign = {1 : '+', -1 : '-'}
            # ~ print("product:%s"%str(itertools.product((-1,1),(-1,1),(-1,1))))
            for permsign in itertools.product((-1,1),(-1,1),(-1,1)):
                for first_spacecomp_index, first_spacecomp in enumerate(space_dirs):
                    other_spacecomps = list(space_dirs)
                    other_spacecomps.pop(first_spacecomp_index)
                    permspace_comps = [first_spacecomp,] + other_spacecomps
                    paras = ['INTITULE','NOM_CHAM','COMB','TYPE']
                    permspace_labels = ['%.1f'%comb_coefs[idx]+c if comb_coefs[idx] != 1 else c for idx, c in enumerate(permspace_comps)]
                    zippermspace = zip([sym_by_permsign[p] for p in permsign], permspace_labels)
                    vales = [myintitule_by_num[lign_num],"EFGE_NOEU",comb_intitule,"NEWMARK"+''.join([''.join(x) for x in zippermspace])]
                    for inte_comp in inte_by_efge.keys():
                        Ei = 0.0
                        for spacedir_index, space_dir in enumerate(permspace_comps):
                            Ei = Ei + permsign[spacedir_index] * comb_coefs[spacedir_index] * Rm_by_inte_by_spacedir[space_dir][inte_comp]
                        Emax_by_inte[inte_comp] = max(abs(Ei), Emax_by_inte[inte_comp])
                        paras.append(inte_comp)
                        vales.append(Ei)
                    __tbresul=CALC_TABLE(reuse=__tbresul,TABLE=__tbresul,ACTION=_F(OPERATION='AJOUT_LIGNE',NOM_PARA=paras,VALE=vales),)
            paras = ['INTITULE','NOM_CHAM','COMB','TYPE']
            vales = [myintitule_by_num[lign_num],"EFGE_NOEU",comb_intitule,"NEWMARK_MAXABS"]
            for inte_comp in inte_by_efge.keys():
                paras.append(inte_comp)
                vales.append(Emax_by_inte[inte_comp])             
            __tbresul=CALC_TABLE(reuse=__tbresul,TABLE=__tbresul,ACTION=_F(OPERATION='AJOUT_LIGNE',NOM_PARA=paras,VALE=vales),)

    return __tbresul

def calc_resultante(lign_num, __tbresul, __tbextr, myintitule_by_num, resu_nume_ordre):
    """
    Calcul des resultates (par des integrales) à partir des données extraites
    Ajoute nouvelles lignes dans __tbresul
    """    
    pytbextr = __tbextr.EXTR_TABLE()
    midabsc = max(pytbextr.ABSC_CURV) / 2.0
    __fmidabs = FORMULE(NOM_PARA=('ABSC_CURV',),VALE='ABSC_CURV-midabsc',midabsc=midabsc)
    __abscnyy = FORMULE(NOM_PARA=('MABSC_CURV', 'NYY'),VALE='MABSC_CURV*NYY')
    __tbextr = CALC_TABLE(TABLE=__tbextr,
                          reuse=__tbextr,  
                          ACTION=(
                                _F(OPERATION='OPER', FORMULE=__fmidabs, NOM_PARA='MABSC_CURV'),
                                _F(OPERATION='OPER', FORMULE=__abscnyy, NOM_PARA='ABSC*NYY'),
                          )
                  )
    # ~ IMPR_TABLE(TABLE=__tbextr)
    DETRUIRE(CONCEPT=_F(NOM=(__fmidabs, __abscnyy)))
    for nume_ordre in resu_nume_ordre:
        paras = ['INTITULE','NOM_CHAM','TYPE','NUME_ORDRE']
        vales = [myintitule_by_num[lign_num],"EFGE_NOEU","RESULTANTE",nume_ordre]
        for inte_comp, efge_comp in inte_by_efge.items():

            if inte_comp == 'MPL':
                absc_col = 'MABSC_CURV'
                ordo_col = 'ABSC*NYY'
            else:
                absc_col = 'ABSC_CURV'
                ordo_col = efge_comp
            __fcomp = RECU_FONCTION(TABLE = __tbextr,
                                    FILTRE = _F( NOM_PARA = 'NUME_ORDRE', CRIT_COMP = 'EQ', VALE_I = nume_ordre , ),
                                    PARA_X = absc_col,
                                    PARA_Y = ordo_col,
                                    NOM_PARA='ABSC',
                                    NOM_RESU=inte_comp, )
            # ~ IMPR_FONCTION(COURBE=_F(FONCTION=__fcomp))
            __finte = CALC_FONCTION( INTEGRE=_F( FONCTION=__fcomp ),)
            inte = __finte.Ordo()[-1]
            # ~ print("__finte.Ordo():%s"%__finte.Ordo())
            paras.append(inte_comp)
            vales.append(inte)
            # ~ print("inte:%s"%inte)
            DETRUIRE(CONCEPT=_F(NOM=(__fcomp, __finte)))
        if __tbresul is None:
            pytbresul=Table()
            pytbresul.append(dict(zip(paras, vales)))
            __tbresul=CREA_TABLE(**pytbresul.dict_CREA_TABLE())
        else:
            __tbresul=CALC_TABLE(reuse=__tbresul,TABLE=__tbresul,ACTION=_F(OPERATION='AJOUT_LIGNE',NOM_PARA=paras,VALE=vales),)

    return __tbresul

#macro body
def calc_coupure_ops(self, **args):
    self.set_icmd(1) # commands in macro will be counted as one

    # La valeur par défaut n'est pas dans le catalogue, sinon le mot-clé devient
    # obligatoire dans AsterStudy
    UNITE_MAILLAGE = args.get("UNITE_MAILLAGE") or 25

    resu = args['RESULTAT']
    lign_coupe = args['LIGN_COUPE']
    operation = args['OPERATION']
    if 'COMB_MODE' in args:
        comb_modes = args['COMB_MODE']
    else:
        comb_modes = []

    resu_nume_ordre = resu.LIST_VARI_ACCES()['NUME_ORDRE']

    iret, ibid, n_cara_elem = aster.dismoi('CARA_ELEM', resu.nom, 'RESULTAT', 'F')
    n_cara_elem = n_cara_elem.rstrip()

    caraelem = self.get_concept(n_cara_elem.strip())

    self.DeclareOut('nomres', self.sd) # return variable declaration

    b_extrac = {}
    for motcle in filter_columns:
        if motcle in args and args[motcle] is not None:
            b_extrac[motcle] = args[motcle]
    if len(b_extrac) == 0:
        b_extrac['TOUT_ORDRE'] = 'OUI'

    __resefge = CALC_CHAMP(RESULTAT=resu,
                           CONTRAINTE='EFGE_ELNO', # MACR_LIGN_COUPE with repere COQUE does not want an NOEU field, needs an ELNO
                           # GROUP_MA=..., # MACR_LIGN_COUPE needs the field to exist on the whole mesh (otherwise it stops with error)
                           **b_extrac)

    macr_lign_extrac = {k:v for k,v in b_extrac.items() if k not in ('TOUT_ORDRE',)}

    lign_by_key = None
    lignextr_by_key = None
    intitule_by_num = {}
    myintitule_by_num = {}

    __tbresul = None
    for lign_num, lign in enumerate(lign_coupe, 1):
        lign_by_key = lign.cree_dict_toutes_valeurs()
        groupma = lign['GROUP_MA']

        lign_by_key['OPERATION'] = 'EXTRACTION'

        if 'INTITULE' in lign:
            # on remplace INTITULE pour le rendre unique (et pour l'utiliser comme filtre en suite)
            intitule_by_num[lign_num] = lign_by_key['INTITULE']
        myintitule = 'l.coupe%d'%lign_num
        lign_by_key['INTITULE'] = myintitule
        myintitule_by_num[lign_num] = myintitule
        lign_by_key['TYPE'] = "SEGMENT"
        del lign_by_key['GROUP_MA']

        vorig = NP.array(lign_by_key['COOR_ORIG'])
        vextr = NP.array(lign_by_key['COOR_EXTR'])
        xloc = vextr - vorig
        xloc /= NP.linalg.norm(xloc)
        __resuloc = MODI_REPERE(RESULTAT=__resefge,
                         REPERE='COQUE',
                         AFFE=_F(VECTEUR=xloc,GROUP_MA=groupma),
                         MODI_CHAM=_F(NOM_CHAM='EFGE_ELNO',
                                      TYPE_CHAM='COQUE_GENE',
                                      NOM_CMP= efge_comps,),
                         **b_extrac
                         )

        __resuloc = CALC_CHAMP(reuse=__resuloc,
                   RESULTAT=__resuloc,
                   CONTRAINTE='EFGE_NOEU', # Can compute NOEU field only after MACR_LIGN_COUPE
                   GROUP_MA=groupma,
                   **b_extrac)


        __tbextr = MACR_LIGN_COUPE(RESULTAT=__resuloc,
                                    NOM_CHAM='EFGE_NOEU',
                                    LIGN_COUPE=_F(**lign_by_key),
                                    UNITE_MAILLAGE=UNITE_MAILLAGE,
                                    **macr_lign_extrac)

        __tbextr = CALC_TABLE(TABLE=__tbextr,
                               reuse=__tbextr,
                               ACTION=(
                                       _F(OPERATION='AJOUT_COLONNE',NOM_PARA='TYPE',VALE='EXTRACTION'),
                                       _F(OPERATION='SUPPRIME', NOM_PARA=('NOEUD_CMP',)),
                                      )
                               )

        if operation == 'EXTRACTION':
            if __tbresul is None:
                __tbresul = __tbextr
            else:
                __tbresul = CALC_TABLE(TABLE=__tbresul,
                              reuse=__tbresul,
                              ACTION=(
                                      _F(OPERATION='COMB',NOM_PARA=('INTITULE','TYPE','NUME_ORDRE'),TABLE=__tbextr),
                                     )
                              )
                DETRUIRE(CONCEPT=_F(NOM=(__tbextr)))
        else:
            __tbresul = calc_resultante(lign_num, __tbresul, __tbextr, myintitule_by_num, resu_nume_ordre)
            DETRUIRE(CONCEPT=_F(NOM=(__tbextr)))            

    # Combinaison modale
    if len(comb_modes) >= 1:
        __tbresul = calc_comb_modes(__tbresul, myintitule_by_num, comb_modes, resu, b_extrac, resu_nume_ordre)

    # ~ IMPR_TABLE(TABLE=__tbresul)

    # Recostruction de l'intitule
    for lign_num, _ in enumerate(lign_coupe, 1):
        commands = []
        if lign_num in intitule_by_num:
            commands.extend([
                        _F(OPERATION='FILTRE', NOM_PARA='INTITULE', VALE_K=myintitule_by_num[lign_num]),
                        _F(OPERATION='SUPPRIME', NOM_PARA=('INTITULE')),
                        _F(OPERATION='AJOUT_COLONNE', NOM_PARA='INTITULE', VALE=intitule_by_num[lign_num]),                        
                        ])
        if lign_num == 1:
            __tbcoup2 = CALC_TABLE(TABLE=__tbresul, ACTION=commands)
        else:
            __tblign = CALC_TABLE(TABLE=__tbresul, ACTION=commands)
            __tbcoup2 = CALC_TABLE(TABLE=__tbcoup2, reuse=__tbcoup2, ACTION=_F(OPERATION='COMB', TABLE=__tblign))
            DETRUIRE(CONCEPT=_F(NOM=(__tblign)))

    # Table finale (pour garantir l'ordre des colonnes)
    res_data = __tbcoup2.EXTR_TABLE()
    DETRUIRE(CONCEPT=_F(NOM=(__tbresul,__tbcoup2)))

    order_columns = ['INTITULE', 'COMB', 'TYPE', 'NOM_CHAM']
    order_columns.extend(sorted(filter_columns))
    if operation == 'EXTRACTION':
        order_columns.extend(sorted(inte_by_efge.keys()))
    else:
        order_columns.extend(['ABSC_CURV', 'COOR_X', 'COOR_Y', 'COOR_Z'])
        order_columns.extend(efge_comps)
    res_data.OrdreColonne(order_columns)
    nomres=CREA_TABLE(**res_data.dict_CREA_TABLE())
            
    return None
