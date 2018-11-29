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

from Accas import _F
import string
import os
import numpy as np

try:
    import aster
    from Utilitai.Utmess import UTMESS
except:
    pass


def calc_bornes(inte_arias, duree, cav, dmaxi, vmaxi, amaxi, asv,
              inte_arias_refe, duree_refe, cav_refe, dmaxi_refe,
              vmaxi_refe, amaxi_refe, asv_refe):
    """
        Calcul des bornes pour la figure des indicateurs de nocivité
    """

    # limites axe y 
    val = []
    val.extend(inte_arias)
    val.extend(duree)
    val.extend(cav)
    val.extend(dmaxi)
    val.extend(vmaxi)
    val.extend(amaxi)
    val.extend(asv)
    val.extend(inte_arias_refe)
    val.extend(duree_refe)
    val.extend(cav_refe)
    val.extend(dmaxi_refe)
    val.extend(vmaxi_refe)
    val.extend(amaxi_refe)
    val.extend(asv_refe)
    
    ymin = min(val)
    ind = np.log(ymin)/np.log(10)
    if ind<0: ind-=1.
    ind = int(ind)
    ymin = 10**ind
    
    ymax = max(val)
    ind = np.log(ymax)/np.log(10)
    if ind>0: ind+=1.
    ind = int(ind)
    ymax = 10**ind
    
    return ymin, ymax


def get_unite_libre():
    """
        Retoune une unité de fichier libre.
    """
    from code_aster.Cata.Commands import DETRUIRE, INFO_EXEC_ASTER
    _UL = INFO_EXEC_ASTER(LISTE_INFO='UNITE_LIBRE')
    unite = _UL['UNITE_LIBRE', 1]
    DETRUIRE(CONCEPT=(_F(NOM=_UL),), INFO=1)
    return unite


def calc_grid(gx,gy):
    """
        Adaptation des pas de grille
        But : ne pas avec des pas de grille avec trop de decimales
    """
    pas_grid = [0.1,0.2,0.25,0.5,1.]
    
    g=[gx,gy]
    grid_out=[]
    for gr in g:
        nook = True
        coef = 1.
        while nook:
            if coef*gr < pas_grid[0]:
                coef = coef*10.
            elif coef*gr > pas_grid[-1]:
                coef = coef/10.
            else:
                pasm=pas_grid[0]
                for pas in pas_grid[1:]:
                    if coef*gr < pas:
                        if abs(pas-coef*gr) < abs(pasm-coef*gr):
                            grid_out.append(pas/coef)
                        else:
                            grid_out.append(pasm/coef)
                        nook = False
                        break
                    else:
                        pasm = pas
    return grid_out

#-----------------------------------------------------------------------
def impr_acce_seisme_ops(
    self, TABLE, NOCI_REFE, SPEC_OSCI, TITRE=None, DUREE=None, 
    SPEC_1_SIGMA=None, LIST_FREQ=None, FREQ_MIN=None, FREQ_MAX=None, 
    RATIO_HV=None, **args):
    """
        Ecriture de la macro IMPR_ACCE_SEISME
    """
    ier = 0

    # On importe les definitions des commandes a utiliser dans la macro
    INFO_FONCTION = self.get_cmd('INFO_FONCTION')
    RECU_FONCTION = self.get_cmd('RECU_FONCTION')
    DEFI_FONCTION = self.get_cmd('DEFI_FONCTION')
    CALC_FONCTION = self.get_cmd('CALC_FONCTION')
    IMPR_FONCTION = self.get_cmd('IMPR_FONCTION')
    DEFI_FICHIER = self.get_cmd('DEFI_FICHIER')
    DETRUIRE = self.get_cmd('DETRUIRE')
    CREA_TABLE = self.get_cmd('CREA_TABLE')
    IMPR_TABLE = self.get_cmd('IMPR_TABLE')

    # Comptage commandes + déclaration concept sortant
    self.set_icmd(1)
    macro = 'IMPR_ACCE_SEISME'
    
    # Chemin du repertoire REPE_OUT de l'execution courante d'Aster
    REPE_OUT = os.path.join(os.getcwd(), 'REPE_OUT')

    unite = get_unite_libre()
    
    ngrid = 10 # nombre de grille sur les figures
    amo_sro = 0.05
    pesant = 9.81
    # recuperation de NOCI_REFE
    noci_refe = []
    
    inte_arias_refe = []
    duree_refe = []
    cav_refe = []
    dmaxi_refe = []
    vmaxi_refe = []
    amaxi_refe = []
    asv_refe = []
    if NOCI_REFE is not None:
        for j in NOCI_REFE:
            noci_refe.append(j.cree_dict_valeurs(j.mc_liste))
            
        if noci_refe[0]['AMAX'] is not None: amaxi_refe = noci_refe[0]['AMAX']
        if noci_refe[0]['VMAX'] is not None: vmaxi_refe = noci_refe[0]['VMAX']
        if noci_refe[0]['DMAX'] is not None: dmaxi_refe = noci_refe[0]['DMAX']
        if noci_refe[0]['INTE_ARIAS'] is not None: inte_arias_refe = noci_refe[0]['INTE_ARIAS']
        if noci_refe[0]['DUREE_PHASE_FORTE'] is not None: duree_refe = noci_refe[0]['DUREE_PHASE_FORTE']
        if noci_refe[0]['VITE_ABSO_CUMU'] is not None: cav_refe = noci_refe[0]['VITE_ABSO_CUMU']
        if noci_refe[0]['ACCE_SUR_VITE'] is not None: asv_refe = noci_refe[0]['ACCE_SUR_VITE']
    

    nom_acce = ["ACCE1","ACCE2","ACCE3"]
    nom_comp = ["X","Y","Z"]
    
    tab_data = TABLE.EXTR_TABLE()
    nom_table = TABLE.get_name()
    
    if not 'FONCTION' in tab_data.para:
        UTMESS('F','SEISME_88')
    
    if "NOM_PARA" in tab_data.para:
        lival = tab_data.values()["NOM_PARA"]
        lival = [val.strip() for val in lival]
        nb_tirage = len(lival)
        # dimension
        dim = 0
        for acce in nom_acce:
            if acce in lival:
               dim+=1
        if dim < 2:
            raise Exception("Cas non prevu")
        nb_tirage = nb_tirage/dim
        lifonc = tab_data.values()["FONCTION"]
    else:
        lifonc = tab_data.values()["FONCTION"]
        nb_tirage = len(lifonc)
        dim = 1
    
    ratio_hv = 1.
    if RATIO_HV and dim<3:
        UTMESS('A','SEISME_91')
    elif RATIO_HV is None and dim==3:
        UTMESS('A','SEISME_92')
    elif RATIO_HV and dim==3:
        ratio_hv = RATIO_HV
        
    __specci=CALC_FONCTION(COMB=_F(FONCTION= SPEC_OSCI, COEF=1./ratio_hv),)
    
    __MOY = [None]*dim
        
    pas_grid = [0.1,0.2,0.25,0.5,1.]
    
    for idi in range(1,dim+1):
        
        inte_arias = []
        duree = []
        cav = []
        dmaxi = []
        vmaxi = []
        amaxi = []
        asv = []
        
        __F_ACCE = [None]*nb_tirage
        __F_VITE = [None]*nb_tirage
        __F_DEPL = [None]*nb_tirage
        __F_SRO  = [None]*nb_tirage
        liste_sro = []

        gym = 0.
        gymd = 0.
        for ii in range(nb_tirage):
            
            # signaux en accélération 
            
            if dim >=2:
                __F_ACCE[ii] = RECU_FONCTION(  TABLE=TABLE,
                        FILTRE=(_F(  NOM_PARA = 'NUME_ORDRE',  VALE_I = ii+1),
                                _F(NOM_PARA = 'NOM_PARA',    VALE_K = nom_acce[idi-1]),),
                        NOM_PARA_TABL='FONCTION',)
            
            else:
                __F_ACCE[ii] = RECU_FONCTION(  TABLE=TABLE,
                        FILTRE=(_F(  NOM_PARA = 'NUME_ORDRE',  VALE_I = ii+1),),
                        NOM_PARA_TABL='FONCTION',)
            
            
            nom_fic = nom_table+"_ACCE_"+nom_comp[idi-1]+"_tirage_%i"%(ii+1)+'.png'
            chem_fic = os.path.join(REPE_OUT, nom_fic)
            DEFI_FICHIER(ACTION='ASSOCIER',UNITE = unite,FICHIER=chem_fic)
            titre = TITRE+' '+"ACCE "+nom_comp[idi-1]
            
            l_inst, l_acce = __F_ACCE[ii].Valeurs()
            if DUREE is not None:
                if l_inst[-1]< DUREE:
                    UTMESS('F','SEISME_89',valr=[DUREE, l_inst[-1]])
                
                for i_inst, inst in enumerate(l_inst):
                    if inst > DUREE:
                        break
                __FONC_D = DEFI_FONCTION(NOM_PARA='INST',
                                         ABSCISSE=l_inst[:i_inst],
                                         ORDONNEE=l_acce[:i_inst])
                                         
                gx = (l_inst[i_inst-1] - l_inst[0])/ngrid
                gy = (max(l_acce[:i_inst]) - min(l_acce[:i_inst]))/ngrid
                
                gx,gy = calc_grid(gx,gy)
                
                
                IMPR_FONCTION (FORMAT='XMGRACE', PILOTE='PNG', 
                           COURBE=_F(FONCTION= __FONC_D,
                                     MARQUEUR=0,
                                     LEGENDE=" Tirage %i"%(ii+1)
                                    ),
                           UNITE = unite,
                           TITRE=titre,
                           LEGENDE_X='Temps (s)',
                           LEGENDE_Y='Acc\xe9l\xe9ration (m/s\\S2\\v{}\\z{})',
                           GRILLE_X = gx,
                           GRILLE_Y = gy,
                          )
                DETRUIRE(CONCEPT=_F(NOM=__FONC_D))
            else:
           
                gx = (l_inst[-1] - l_inst[0])/ngrid
                gy = (max(l_acce) - min(l_acce))/ngrid
                
                gx,gy = calc_grid(gx,gy)
                
                IMPR_FONCTION (FORMAT='XMGRACE', PILOTE='PNG', 
                               COURBE=_F(FONCTION= __F_ACCE[ii],
                                         MARQUEUR=0,
                                         LEGENDE=" Tirage %i"%(ii+1)
                                        ),
                               UNITE = unite,
                               TITRE=titre,
                               LEGENDE_X='Temps (s)',
                               LEGENDE_Y='Acc\xe9l\xe9ration (m/s\\S2\\v{}\\z{})',
                               GRILLE_X = gx,
                               GRILLE_Y = gy,
                              )
                           
            
            # grille pour la figure de tous les accelero
            gx = (l_inst[-1] - l_inst[0])/ngrid
            gy = (max(l_acce) - min(l_acce))/ngrid
            gx,gy = calc_grid(gx,gy)
            
            gym = max ([gy,gym])
            
            
            
            DEFI_FICHIER (ACTION='LIBERER',UNITE = unite)
            
            os.remove(chem_fic+'.hardcopy')
            os.remove(chem_fic+'.wrk')
                
            # vitesse et deplacement
            __F_VITE[ii]=CALC_FONCTION( INTEGRE=_F(  FONCTION = __F_ACCE[ii]) )
            __F_DEPL[ii]=CALC_FONCTION( INTEGRE=_F(  FONCTION = __F_VITE[ii]) )
            
            # grille pour tous les deplacements
            l_inst, l_acce = __F_DEPL[ii].Valeurs()
            gx = (l_inst[-1] - l_inst[0])/ngrid
            gy = (max(l_acce) - min(l_acce))/ngrid
            gx,gy = calc_grid(gx,gy)
            gymd = max ([gy,gymd])
            
             
            if LIST_FREQ :
                __F_SRO[ii]=CALC_FONCTION(SPEC_OSCI=_F(FONCTION= __F_ACCE[ii], LIST_FREQ = LIST_FREQ, 
                                          NORME=pesant, AMOR_REDUIT=(amo_sro,),),)
            else:
                __F_SRO[ii]=CALC_FONCTION(SPEC_OSCI=_F(FONCTION= __F_ACCE[ii],
                                          NORME=pesant, AMOR_REDUIT=(amo_sro,),),)
                                          
            liste_sro.append(__F_SRO[ii])
    
            # indicateur de nocivite
            
            
            __intea = INFO_FONCTION(  NOCI_SEISME=_F(OPTION='INTE_ARIAS',
                                     FONCTION = __F_ACCE[ii], PESANTEUR = pesant,
                                     ) )
            tab = __intea.EXTR_TABLE()
            inte_arias.extend(tab.values()["INTE_ARIAS"])

            __duree = INFO_FONCTION(  NOCI_SEISME=_F(OPTION='DUREE_PHAS_FORT',
                                     FONCTION = __F_ACCE[ii],
                                     PESANTEUR = pesant,
                                    ) )
            tab = __duree.EXTR_TABLE()
            duree.extend(tab.values()["DUREE_PHAS_FORT"])
            
            __cav = INFO_FONCTION(  NOCI_SEISME=_F(FONCTION = __F_ACCE[ii],  OPTION = 'VITE_ABSO_CUMU'))
            tab = __cav.EXTR_TABLE()
            cav.extend(tab.values()["VITE_ABSO_CUMU"])
            
            __maxi = INFO_FONCTION(  NOCI_SEISME=_F(FONCTION = __F_ACCE[ii],  OPTION = 'MAXI'))
            tab = __maxi.EXTR_TABLE()
            dmaxi.extend(tab.values()["DEPL_MAX"])
            vmaxi.extend(tab.values()["VITE_MAX"])
            amaxi.extend(tab.values()["ACCE_MAX"])
            asv.extend(tab.values()["ACCE_SUR_VITE"])
            

            DETRUIRE( CONCEPT = _F(NOM = (__intea, __duree, __maxi, __cav )) )
        
        # impressions de tous les acceleros

        courbes = []
        for ii in range(nb_tirage):
            dic = {'FONCTION' : __F_ACCE[ii],
                   'LEGENDE'  : "Tirage %i"%(ii+1),
                   'MARQUEUR' : 0,
                  }
            courbes.append(dic)
            
        nom_fic = nom_table+"_ACCE_"+nom_comp[idi-1]+"_TOUS"+'.png'
        chem_fic = os.path.join(REPE_OUT, nom_fic)
                    
        DEFI_FICHIER(ACTION='ASSOCIER',UNITE = unite,FICHIER=chem_fic)
                     
        titre = TITRE+' '+"ACCE "+nom_comp[idi-1]+" Tous signaux"
        IMPR_FONCTION (FORMAT='XMGRACE', PILOTE='PNG',
                       COURBE=courbes,
                       UNITE = unite,
                       TITRE=titre,
                       LEGENDE_X='Temps (s)',
                       LEGENDE_Y='Acc\xe9l\xe9ration (m/s\\S2\\v{}\\z{})',
                       GRILLE_X = gx,
                       GRILLE_Y = gym,
                      )
                       
        DEFI_FICHIER (ACTION='LIBERER',UNITE = unite)            
        os.remove(chem_fic+'.hardcopy')
        os.remove(chem_fic+'.wrk')
    
        # impression de tous les deplacements
        
        courbes = []
        for ii in range(nb_tirage):
            dic = {'FONCTION' : __F_DEPL[ii],
                   'LEGENDE'  : "Tirage %i"%(ii+1),
                   'MARQUEUR' : 0,
                  }
            courbes.append(dic)
            
        nom_fic = nom_table+"_DEPL_"+nom_comp[idi-1]+"_TOUS"+'.png'
        chem_fic = os.path.join(REPE_OUT, nom_fic)
                    
        DEFI_FICHIER(ACTION='ASSOCIER',UNITE = unite,FICHIER=chem_fic)
                     
        titre = TITRE+' '+"DEPL "+nom_comp[idi-1]+" Tous signaux"
        IMPR_FONCTION (FORMAT='XMGRACE', PILOTE='PNG',
                       COURBE=courbes,
                       UNITE = unite,
                       TITRE=titre,
                       LEGENDE_X='Temps (s)',
                       LEGENDE_Y='D\xe9placement (m)',
                       GRILLE_X = gx,
                       GRILLE_Y = gymd,
                      )
                       
        DEFI_FICHIER (ACTION='LIBERER',UNITE = unite)      
        os.remove(chem_fic+'.hardcopy')
        os.remove(chem_fic+'.wrk')
        
        # impression nocivite
        vale_refe = []
        epsilon = [n*1e-6 for n in range(nb_tirage)]
        
        for i, triplet in enumerate([amaxi_refe, vmaxi_refe, dmaxi_refe, asv_refe, 
                           duree_refe, cav_refe, inte_arias_refe,]):
            for ii,val in enumerate(triplet):
                vale_refe.extend([i+1+epsilon[ii], val]) 
        if vale_refe !=[]:
            __refe = DEFI_FONCTION( NOM_PARA='INST',
                        VALE=vale_refe,)
        
        
        vale_calc = []
        for i, lival in enumerate([amaxi, vmaxi, dmaxi, asv, 
                           duree, cav, inte_arias,]):
            for ii,val in enumerate(lival):
                vale_calc.extend([i+1+epsilon[ii], val]) 
        __calc = DEFI_FONCTION( NOM_PARA='INST',
                    VALE=vale_calc,)
        
        courbes = []
        if vale_refe !=[]:
            dic = {'FONCTION' :__refe,
                   'LEGENDE'  : "Valeurs de r\xe9f\xe9rence",
                   'MARQUEUR' : 8,
                   'STYLE'    : 0,
                  }
            courbes.append(dic)
        
        dic = {'FONCTION' :__calc,
               'LEGENDE'  : "Valeurs calcul\xe9es",
               'COULEUR'  : 4,
               'STYLE'    : 0,
               'MARQUEUR' : 1,
                  }
        courbes.append(dic)
        
        ymin, ymax = calc_bornes(inte_arias, duree, cav, dmaxi, vmaxi, amaxi, asv,
                  inte_arias_refe, duree_refe, cav_refe, dmaxi_refe,
                  vmaxi_refe, amaxi_refe, asv_refe)
        
        nom_fic = nom_table+"_nocivite_"+nom_comp[idi-1]+'.png'
        chem_fic = os.path.join(REPE_OUT, nom_fic)
        DEFI_FICHIER(ACTION='ASSOCIER',UNITE = unite,FICHIER=chem_fic)
                     
        legendx = ["1 = A\\smax\\v{}\\z{} (m/s\\S2\\v{}\\z{})",
                   "2 = V\\smax\\v{}\\z{} (m/s)",
                   "3 = D\\smax\\v{}\\z{} (m)",
                   "4 = A/V (m/s\\S-1\\v{}\\z{})",
                   "5 = DPF",
                   "6 = CAV (m/s)",
                   "7 = I\\sArias\\v{}\\z{} (m/s)",
                  ]
        legendx = ", ".join(legendx)
        
        
        titre = TITRE+" Indicateurs de nocivit\xe9"+" Dir "+nom_comp[idi-1]
        IMPR_FONCTION (FORMAT='XMGRACE', PILOTE='PNG',
                       COURBE=courbes,
                       UNITE = unite,
                       TITRE=titre,
                       LEGENDE_X=legendx,
                       ECHELLE_Y = 'LOG',
                       BORNE_Y = [ymin,ymax],
                      )
                       
        DEFI_FICHIER (ACTION='LIBERER',UNITE = unite)  
        os.remove(chem_fic+'.hardcopy')
        os.remove(chem_fic+'.wrk')   
                     
        if vale_refe !=[]:
            DETRUIRE( CONCEPT = _F(NOM = (__refe,)) )
        DETRUIRE( CONCEPT = _F(NOM = (__calc,)) )
        
        # tableau de statistiques
        # moyenne, mediane, valeurs +-1 sigma
        
        val_resu= [amaxi, vmaxi, dmaxi, asv, duree, cav, inte_arias]
        para = ["CRITERES", "MOYENNE",'MEDIANE','MOINS_UN_SIGMA','PLUS_UN_SIGMA']
        criteres = ["AMAX","VMAX","DMAX","A_SUR_V","DUREE_PHASE_FORTE","VITE_ABSO_CUMU",
                "INTE_ARIAS"]
        
        l_crea_table_liste = []
        l_crea_table_liste.append({"PARA" : para[0], "LISTE_K" : criteres, 
                                  "TYPE_K" : "K24"})
        
        l_moy= []
        l_med = []
        l_msig = []
        l_psig = []
        for val in val_resu:
            arr = np.array(val)
            moy = np.mean(arr,0)
            mediane = np.median(arr,0)
            msig = np.percentile(arr, 15)
            psig = np.percentile(arr, 85)
            
            l_moy.append(moy)
            l_med.append(mediane)
            l_msig.append(msig)
            l_psig.append(psig)
            
        
        l_crea_table_liste.append({"PARA" : para[1], "LISTE_R" : l_moy})
        l_crea_table_liste.append({"PARA" : para[2], "LISTE_R" : l_med})
        l_crea_table_liste.append({"PARA" : para[3], "LISTE_R" : l_msig})
        l_crea_table_liste.append({"PARA" : para[4], "LISTE_R" : l_psig})
        
        __TAB = CREA_TABLE(LISTE=l_crea_table_liste)
        
        nom_fic = nom_table+"_nocivite_"+nom_comp[idi-1]+"_STAT"+'.txt'
        chem_fic = os.path.join(REPE_OUT, nom_fic)
        DEFI_FICHIER(ACTION='ASSOCIER',UNITE = unite,FICHIER=chem_fic)
                     
        IMPR_TABLE (TABLE=__TAB,
                    UNITE = unite)
                       
        DEFI_FICHIER (ACTION='LIBERER',UNITE = unite)
        
        # spectres
        #     moyenne
        
        __MOY[idi-1] = CALC_FONCTION(MOYENNE=_F(FONCTION= liste_sro,) )
        
                
        lfreq, lval = __MOY[idi-1].Valeurs()[1][0]
        freq_marq = len(lfreq)/20
        
        gx = (lfreq[-1] - lfreq[0])/ngrid
        gy = (max(lval) - min(lval))/ngrid
        gx,gy = calc_grid(gx,gy)
        
        
        
        courbes = []
        dic = {'FONCTION' : __specci,
               'LEGENDE'  : "Spectre cible",
               'MARQUEUR' : 4,
              }
        courbes.append(dic)
        
        dic = {'FONCTION' :__MOY[idi-1],
               'LEGENDE'  : "Spectre moyen",
               'MARQUEUR' : 2,
               'FREQ_MARQUEUR' : freq_marq,
                  }
        courbes.append(dic)
        
        nom_fic = nom_table+"_SPEC_"+nom_comp[idi-1]+"_MOY_CIBLE"+'.png'
        chem_fic = os.path.join(REPE_OUT, nom_fic)
        
        DEFI_FICHIER(ACTION='ASSOCIER',UNITE = unite,FICHIER=chem_fic)
                     
        titre = TITRE+' '+"Spectre "+nom_comp[idi-1]+" cible et moyen"
        IMPR_FONCTION (FORMAT='XMGRACE', PILOTE='PNG',
                       COURBE=courbes,
                       UNITE = unite,
                       TITRE=titre,
                       LEGENDE_X='Fr\xe9quence (H)',
                       LEGENDE_Y='Acc\xe9l\xe9ration spectrale  (g)',
                       ECHELLE_X='LOG',
                       ECHELLE_Y='LOG',
                       GRILLE_X = gx,
                       GRILLE_Y = gy,
                      )
                       
        DEFI_FICHIER (ACTION='LIBERER',UNITE = unite)
        os.remove(chem_fic+'.hardcopy')
        os.remove(chem_fic+'.wrk')
        
        for ii, fonc in enumerate(liste_sro):
            dic = {'FONCTION' : fonc,
                   'LEGENDE'  : "Tirage %i"%(ii+1),
                   'MARQUEUR' : 0,   
                  }
            courbes.append(dic)
            
        nom_fic = nom_table+"_SPEC_"+nom_comp[idi-1]+"_TOUS"+'.png'
        chem_fic = os.path.join(REPE_OUT, nom_fic)
        
        DEFI_FICHIER(ACTION='ASSOCIER',UNITE = unite,FICHIER=chem_fic)
                     
        titre = TITRE+' '+"Spectre "+nom_comp[idi-1]+" Ensemble des tirages"
        IMPR_FONCTION (FORMAT='XMGRACE', PILOTE='PNG',
                       COURBE=courbes,
                       UNITE = unite,
                       TITRE=titre,
                       LEGENDE_X='Fr\xe9quence (H)',
                       LEGENDE_Y='Acc\xe9l\xe9ration spectrale  (g)',
                       ECHELLE_X='LOG',
                       ECHELLE_Y='LOG',
                       GRILLE_X = gx,
                       GRILLE_Y = gy,
                      )
                       
        DEFI_FICHIER (ACTION='LIBERER',UNITE = unite)
        os.remove(chem_fic+'.hardcopy')
        os.remove(chem_fic+'.wrk')
        
        # +- sigma
        if SPEC_1_SIGMA:
            
            __spec1s=CALC_FONCTION(COMB=_F(FONCTION= SPEC_1_SIGMA, COEF=1./ratio_hv),)
            
            # calcul du spectre -1 sigma cible
            #SPEC_MOINS_1_SIGMA = SPEC_OSCI * exp(-BETA) où BETA = log(SPEC_1_SIGMA/ SPEC_OSCI).

            
            freq_cib, acce_cib = __specci.Valeurs()
            freq_cib2, acce_cib2 = __spec1s.Valeurs()
            
            if len(freq_cib)!=len(freq_cib2):
                UTMESS('F','SEISME_90',)
            
            acce_cib3 = []
            for ifreq, freq in enumerate(freq_cib) :
                if abs((freq-freq_cib2[ifreq])/freq)>1e-4:
                    UTMESS('F','SEISME_90',)
                beta = np.log(acce_cib2[ifreq]/acce_cib[ifreq])
                acce_cib3.append(acce_cib[ifreq]*np.exp(-beta))
                
            
            __SPMSIG = DEFI_FONCTION(NOM_PARA='FREQ',
                                     ABSCISSE=freq_cib,
                                     ORDONNEE=acce_cib3)
            
            
            __MEDI=CALC_FONCTION(FRACTILE=_F(FONCTION= liste_sro,
                                 FRACT=0.5) )
            __PSIG=CALC_FONCTION(FRACTILE=_F(FONCTION= liste_sro,
                                 FRACT=0.84) )
            __MSIG=CALC_FONCTION(FRACTILE=_F(FONCTION= liste_sro,
                                 FRACT=0.15) )
            
            courbes = []
            
            dic = {'FONCTION' : SPEC_1_SIGMA,
                   'LEGENDE'  : "Spectre 1_Sigma cible",
                   #'MARQUEUR' : 4,
                  }
            courbes.append(dic)
            
            dic = {'FONCTION' : __SPMSIG,
                   'LEGENDE'  : "Spectre -1_Sigma cible",
                   #'MARQUEUR' : 4,
                  }
            courbes.append(dic)
        
            dic = {'FONCTION' :__MEDI,
                   'LEGENDE'  : "Spectre m\xe9dian",
                   #'MARQUEUR' : 2,
                   'FREQ_MARQUEUR' : freq_marq,
                      }
            courbes.append(dic)
            
            
            dic = {'FONCTION' :__PSIG,
                   'LEGENDE'  : "Spectre 1_Sigma",
                   #'MARQUEUR' : 2,
                   'FREQ_MARQUEUR' : freq_marq,
                      }
            courbes.append(dic)
            
            dic = {'FONCTION' :__MSIG,
                   'LEGENDE'  : "Spectre -1_Sigma",
                   #'MARQUEUR' : 2,
                   'FREQ_MARQUEUR' : freq_marq,
                      }
            courbes.append(dic)
            
            
            nom_fic = nom_table+"_SPEC_"+nom_comp[idi-1]+"_1_SIGMA"+'.png'
            chem_fic = os.path.join(REPE_OUT, nom_fic)
            
            DEFI_FICHIER(ACTION='ASSOCIER',UNITE = unite,FICHIER=chem_fic)
                     
            titre = TITRE+' '+"Spectre "+nom_comp[idi-1]+ " Plus et moins sigma"
            IMPR_FONCTION (FORMAT='XMGRACE', PILOTE='PNG',
                           COURBE=courbes,
                           UNITE = unite,
                           TITRE=titre,
                           LEGENDE_X='Fr\xe9quence (H)',
                           LEGENDE_Y='Acc\xe9l\xe9ration spectrale  (g)',
                           ECHELLE_X='LOG',
                           ECHELLE_Y='LOG',
                          )
                           
            DEFI_FICHIER (ACTION='LIBERER',UNITE = unite)
            os.remove(chem_fic+'.hardcopy')
            os.remove(chem_fic+'.wrk')
            
            DETRUIRE( CONCEPT = _F(NOM = (__PSIG, __MSIG, __SPMSIG, __MEDI, __spec1s)) )
                                          
        if FREQ_MIN:
            
            
            # verif :
            freq_moy, acce_moy = __MOY[idi-1].Valeurs()[1][0]
            freq_cib, acce_cib = __specci.Valeurs()

            
            if FREQ_MIN < max(freq_moy[0],freq_cib[0]): 
                UTMESS('F','SEISME_84', valr=[FREQ_MIN, max(freq_moy[0],freq_cib[0])])
            if FREQ_MAX > min(freq_moy[-1],freq_cib[-1]): 
                UTMESS('F','SEISME_85', valr=[FREQ_MAX, min(freq_moy[-1],freq_cib[-1])])
            
            coef_mult = 1.
            for i_freq, freq in enumerate(freq_moy):
                if freq < FREQ_MIN: continue
                if freq > FREQ_MAX: break
                
                acce = acce_moy[i_freq]
                
                for i_freq_cible in range(len(freq_cib)):
                    if freq_cib[i_freq_cible]>=freq:
                        break
                if i_freq_cible == len(freq_cib)-1 or i_freq_cible == 0:
                    coef = acce_cib[i_freq_cible]/acce
                else:
                    acce_inf = acce_cib[i_freq_cible-1]
                    acce_sup = acce_cib[i_freq_cible]
                    freq_inf = freq_cib[i_freq_cible-1]
                    freq_sup = freq_cib[i_freq_cible]
                    a = (acce_sup-acce_inf)/(freq_sup-freq_inf)
                    acce_interp = acce_inf + a * (freq-freq_inf)
                    coef = acce_interp/acce
                if coef>coef_mult: coef_mult=coef
            
            if coef_mult ==1:
                UTMESS('I','SEISME_86')
            else:
                __SPCOR = CALC_FONCTION(COMB=_F(FONCTION=__MOY[idi-1], COEF=coef_mult))
                
                courbes = []
                dic = {'FONCTION' : __specci,
                       'LEGENDE'  : "Spectre Cible",
                       #'MARQUEUR' : 4,
                      }
                courbes.append(dic)
            
                dic = {'FONCTION' :__SPCOR,
                       'LEGENDE'  : "Spectre moyen corrig\xe9",
                       #'MARQUEUR' : 2,
                       'FREQ_MARQUEUR' : freq_marq,
                          }
                courbes.append(dic)
                
                
                
                
                nom_fic = nom_table+"_SPEC_"+nom_comp[idi-1]+"_MOY_CORRIGE"+'.png'
                chem_fic = os.path.join(REPE_OUT, nom_fic)

                DEFI_FICHIER(ACTION='ASSOCIER',UNITE = unite,FICHIER=chem_fic)
                     
                titre = TITRE+' '+"Spectre "+nom_comp[idi-1]+ " cible et moyen"
                IMPR_FONCTION (FORMAT='XMGRACE', PILOTE='PNG',
                               COURBE=courbes,
                               UNITE = unite,
                               TITRE=titre,
                               SOUS_TITRE = "Facteur de correction =%s"%coef_mult,
                               LEGENDE_X='Fr\xe9quence (H)',
                               LEGENDE_Y='Acc\xe9l\xe9ration spectrale  (g)',
                               ECHELLE_X='LOG',
                               ECHELLE_Y='LOG',
                              )
                               
                DEFI_FICHIER (ACTION='LIBERER',UNITE = unite)
                os.remove(chem_fic+'.hardcopy')
                os.remove(chem_fic+'.wrk')
                
                
                DETRUIRE( CONCEPT = _F(NOM = (__SPCOR)) )
                
                UTMESS('I','SEISME_87',valr=coef_mult)
            
        DETRUIRE( CONCEPT = _F(NOM = (__TAB)) )
        for ii in range(nb_tirage):
            DETRUIRE( CONCEPT = _F(NOM = (__F_ACCE[ii],__F_VITE[ii], __F_DEPL[ii],
                                          __F_SRO[ii])) )
                                          
    #    moyenne géométrique des moyennes des spectres horizontaux
    if dim>=2:
        
        liste_moy = [{"FONCTION" :__MOY[0]},{"FONCTION" :__MOY[1]}]
        racn = 2
        
        __F_PROG=CALC_FONCTION(MULT=liste_moy)
        freqs, acce_spec = __F_PROG.Valeurs()[1][0]
        
        acce_spec2 = []
        for val in acce_spec:
            if val < 0: raise Exception("Erreur de développement, accélération spectrale négative")
            acce_spec2.append(val**(1./racn))

        
        __F_MOYG = DEFI_FONCTION(NOM_PARA='FREQ',
                                 ABSCISSE=freqs,
                                 ORDONNEE=acce_spec2)
        
        courbes = []
        dic = {'FONCTION' : __specci,
               'LEGENDE'  : "Spectre Cible",
               #'MARQUEUR' : 4,
              }
        courbes.append(dic)
    
        dic = {'FONCTION' :__F_MOYG,
               'LEGENDE'  : "Moyenne g\xe9om\xe9trique des spectres",
               #'MARQUEUR' : 2,
               'FREQ_MARQUEUR' : freq_marq,
                  }
        courbes.append(dic)
        
        nom_fic = nom_table+"_SPEC_horizontaux"+"_MOY_GEOM"+'.png'
        chem_fic = os.path.join(REPE_OUT, nom_fic)
        
        DEFI_FICHIER(ACTION='ASSOCIER',UNITE = unite,FICHIER=chem_fic)
                     
        titre = TITRE+' '+"Moyenne géom\xe9trique des spectres horizontaux moyens"
        IMPR_FONCTION (FORMAT='XMGRACE', PILOTE='PNG',
                       COURBE=courbes,
                       UNITE = unite,
                       TITRE=titre,
                       LEGENDE_X='Fr\xe9quence (H)',
                       LEGENDE_Y='Acc\xe9l\xe9ration spectrale  (g)',
                       ECHELLE_X='LOG',
                       ECHELLE_Y='LOG',
                      )
                       
        DEFI_FICHIER (ACTION='LIBERER',UNITE = unite)
        os.remove(chem_fic+'.hardcopy')
        os.remove(chem_fic+'.wrk')
        
        
        DETRUIRE( CONCEPT = _F(NOM = (__F_MOYG, __F_PROG)) ) 
    
    DETRUIRE( CONCEPT = _F(NOM = (__specci,)) ) 
    
    for idi in range(dim):
        DETRUIRE( CONCEPT = _F(NOM = (__MOY[idi])) )
    
    return ier
