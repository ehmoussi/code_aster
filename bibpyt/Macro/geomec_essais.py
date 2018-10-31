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

from geomec_utils import *

# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
#                    ESSAI TRIAXIAL DRAINE MONOTONE                       #
#                A DEFORMATION CONTROLEE [TRIA_DR_M_D]                    #
# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
def essai_TRIA_DR_M_D(self, str_n_essai, DicoEssai,
                      MATER, COMPORTEMENT, CONVERGENCE, INFO,):
    """
    Objet: Essai Triaxial Draine Monotone a Deplacement controle [TRIA_DR_M_D]
    """
    import numpy as NP
    from Accas import _F
    import aster
    
    typessai = "TRIA_DR_M_D"

    # Recuperation des commandes Aster
    # -----------------------------------------
    DEFI_FONCTION  = self.get_cmd('DEFI_FONCTION')
    SIMU_POINT_MAT = self.get_cmd('SIMU_POINT_MAT')
    DETRUIRE       = self.get_cmd('DETRUIRE')
    CREA_TABLE     = self.get_cmd('CREA_TABLE')
    IMPR_TABLE     = self.get_cmd('IMPR_TABLE')
    DEFI_LIST_INST = self.get_cmd('DEFI_LIST_INST')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')
    
    # Recuperation des parametres d'essais
    # -----------------------------------------
    PRES_CONF   = DicoEssai['PRES_CONF']
    EPSI_IMPOSE = DicoEssai['EPSI_IMPOSE']
    KZERO       = DicoEssai['KZERO']
    NB_INST     = DicoEssai['NB_INST']
    
    # Recuperation des options d'impression
    # -----------------------------------------
    if DicoEssai.has_key('COULEUR'):
    
       COULEUR_NIV2= DicoEssai['COULEUR']
       
       assert len(COULEUR_NIV2) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste COULEUR" %(len(COULEUR_NIV2))+\
       " doit etre egale a        !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                        !!!\n"
       
    else:
       COULEUR_NIV2= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('MARQUEUR'):
    
       MARQUEUR_NIV2= DicoEssai['MARQUEUR']
       
       assert len(MARQUEUR_NIV2) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste MARQUEUR" %(len(MARQUEUR_NIV2))+\
       " doit etre egale a        !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                         !!!\n"
    else:
       MARQUEUR_NIV2= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('STYLE'):
    
       STYLE_NIV2= DicoEssai['STYLE']
       
       assert len(MARQUEUR_NIV2) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste STYLE" %(len(STYLE_NIV2))+\
       " doit etre egale a        !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                          !!!\n"
    else:
       STYLE_NIV2= [-1]*len(PRES_CONF)
    
    # Recuperation des variables supplementaires a imprimer
    # (si existantes) contenues sous le mot-cle 'NOM_CMP'
    # -----------------------------------------
    if DicoEssai.has_key('NOM_CMP'):
       List_Resu_Supp = list(DicoEssai['NOM_CMP'])
    else:
       List_Resu_Supp = None

    # dict permettant la gestion des graphiques
    # -----------------------------------------
    Courbes = dict()
    NomsFich= dict()
    Leg_x   = dict()
    Leg_y   = dict()

    # dict permettant la gestion des tables en sortie
    # -----------------------------------------
    Resu_Essai = {'LIST_CMP': []}
    
    cle = ['INST','EPS_AXI','EPS_LAT','EPS_VOL','SIG_AXI','SIG_LAT','P','Q',]
    if List_Resu_Supp:
    
       try:
          List_Resu_Supp.remove('INST')
       except:
          cle+= List_Resu_Supp
       else:
          cle+= List_Resu_Supp
    
    for c in cle:
       Resu_Essai[c] = [[] for k in xrange(len(PRES_CONF))]
    
    # Hors composantes de niveau 1
    # -----------------------------------------
    cle = ['INST','EPS_AXI','EPS_LAT','EPS_VOL','SIG_AXI','SIG_LAT','P','Q',]

    # preparation des graphiques
    # -----------------------------------------
    if str_n_essai:
       str_fich = "%s_%s_" %(typessai,str_n_essai)
    else:
       str_fich = "%s_" %(typessai,)
    
    preparer_graphique('2', DicoEssai, str_fich, Courbes, NomsFich,
                       Leg_x, Leg_y, {}, {},)

    # Creation de la liste d'instants
    # -----------------------------------------
    __RLIST = DEFI_LIST_REEL(DEBUT=0.,
                             INTERVALLE=_F(JUSQU_A=100.,
                                           NOMBRE =NB_INST,),
                             INFO=INFO)

    __DLIST = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__RLIST),
                             ECHEC=_F(SUBD_METHODE='MANUEL',
                                      SUBD_PAS    =2,
                                      SUBD_NIVEAU =10,),
                             INFO=INFO,)
# ---
# Boucle sur les pressions de confinement PRES_CONF
# ---
    for i,sig0__ in enumerate(PRES_CONF):
    
        sig0 = -sig0__

        if str_n_essai:
           affiche_infos_essai(str_n_essai, typessai, -sig0, EPSI_IMPOSE[i])
        else:
           affiche_infos_essai('1', typessai, -sig0, EPSI_IMPOSE[i])

        # ---
        # Definition des chargements
        # ---
        __CHAR1 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                VALE=(0., 0.,
                                    100., -EPSI_IMPOSE[i],),)

        __CHAR2 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                VALE=(0., KZERO * sig0,
                                    100., KZERO * sig0,),)
        # ---
        # Calcul
        # ---
        try:
           __EVOL = SIMU_POINT_MAT(INFO=INFO,
        
            COMPORTEMENT=COMPORTEMENT.List_F(),
            
            CONVERGENCE=CONVERGENCE.List_F(),
            
            MATER=MATER,
            
            INCREMENT=_F(LIST_INST=__DLIST,
                         INST_INIT=0.,
                         INST_FIN =100.,),
                         
            NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
            
            ARCHIVAGE=_F(LIST_INST=__RLIST,),
            
            SIGM_IMPOSE=_F(SIXX=__CHAR2,
                           SIYY=__CHAR2,),
            EPSI_IMPOSE=_F(EPZZ=__CHAR1,),
            
            SIGM_INIT=_F(SIXX=KZERO*sig0,
                         SIYY=KZERO*sig0,
                         SIZZ=sig0,),
                         
            EPSI_INIT=_F(EPXX=0.,
                         EPYY=0.,
                         EPZZ=0.,
                         EPXY=0.,
                         EPXZ=0.,
                         EPYZ=0.,),)
        
        except (aster.error,aster.onFatalError,), message:
   
           print '\n   !!!(@_@)!!! Arret pour la raison suivante !!!(@_@)!!!\n%s'\
                     %(message)
        
           __EVPOST = self.get_last_concept()
           TabRes   = __EVPOST.EXTR_TABLE().values()
           
           DETRUIRE(CONCEPT=_F(NOM=__EVPOST), INFO=1)

        else:
           TabRes = __EVOL.EXTR_TABLE().values()
           
           DETRUIRE(CONCEPT=_F(NOM=__EVOL), INFO=1)
            
        # ---
        # Post-traitements
        # ---
        #TabRes = __EVOL.EXTR_TABLE().values()
        
        sig_xx = NP.array(TabRes['SIXX'])
        sig_yy = NP.array(TabRes['SIYY'])
        sig_zz = NP.array(TabRes['SIZZ'])
        eps_xx = NP.array(TabRes['EPXX'])
        eps_yy = NP.array(TabRes['EPYY'])
        eps_zz = NP.array(TabRes['EPZZ'])
        inst   = TabRes['INST']
        
        eps_vol= eps_xx+eps_yy+eps_zz
        p      = (sig_xx+sig_yy+sig_zz)/3.
        q      = abs(sig_zz-sig_xx)

        # stockage pour ecriture dans les tables
        # ---------------------------------------
        Resu_Essai['INST'][i] = inst
        Resu_Essai['EPS_AXI'][i] = list(-eps_zz)
        Resu_Essai['EPS_LAT'][i] = list(-eps_xx)
        Resu_Essai['EPS_VOL'][i] = list(-eps_vol)
        Resu_Essai['SIG_AXI'][i] = list(-sig_zz)
        Resu_Essai['SIG_LAT'][i] = list(-sig_xx)
        Resu_Essai['P'][i] = list(-p)
        Resu_Essai['Q'][i] = list(q)
        
        # Recuperation des composantes supplementaires
        # existantes dans le resultat
        # --------------------------------------------------------
        if List_Resu_Supp:
           try:
             # Cas ou list_key existe deja (i>0)
             # list_key contient les composantes
             # EXISTANTES dans le resultat
             # (list_key pas necessairement egal a List_Resu_Supp)
             for lr in list_key:
                Resu_Essai[lr][i] =TabRes[lr]
               
           except:
             # Cas ou list_key n existe pas (i=0)
             list_key=[]
             for lr in List_Resu_Supp:
               if TabRes.has_key(lr):
                  list_key.append(lr)
                  Resu_Essai[lr][i] =TabRes[lr]
                  
           if not i:
             Resu_Essai['LIST_CMP']=TabRes.keys()
             
        # Impression graphique des composantes supplementaires
        # existantes dans le resultat
        # --------------------------------------------------------
        str_leg = "PRES_CONF=%.2E EPSI_IMPO=%.2E" %(-sig0,EPSI_IMPOSE[i],)
                  
        list_x=[list(-p),list(-eps_zz),list(-eps_zz),list(-p),]
        list_y=[list(q),list(q),list(-eps_vol),list(-eps_vol),]
        list_title=["P-Q","EPS_AXI-Q","EPS_AXI-EPS_VOL","P-EPS_VOL",]
        
        for g in DicoEssai['GRAPHIQUE']:
    
          if g in list_title:
          
            j = list_title.index(g)
            
            remplir_graphique(DicoEssai, Courbes, list_x[j],
                              list_y[j], str_leg, g,
                              COULEUR_NIV2[i],
                              MARQUEUR_NIV2[i],
                              STYLE_NIV2[i],)
          else:
       
            li  = g.split('-')
          
            if len(li)!=2:
               continue
            else:
               cmpx,cmpy=li[0],li[1]
               
            if (cmpx in Resu_Essai['LIST_CMP']+cle) and \
               (cmpy in Resu_Essai['LIST_CMP']+cle):
               
               remplir_graphique(DicoEssai, Courbes, Resu_Essai[cmpx][i],
                                 Resu_Essai[cmpy][i], str_leg, g,
                                 COULEUR_NIV2[i],
                                 MARQUEUR_NIV2[i],
                                 STYLE_NIV2[i],)
        
        DETRUIRE(CONCEPT=_F(NOM=(__CHAR1, __CHAR2,),), INFO=1)
# ---
# Fin boucle sur les pressions de confinement PRES_CONF
# ---

    # remplissage des tables
    # --------------------------------------------------------
    if str_n_essai:
       remplir_tables(self, typessai, str_n_essai, DicoEssai, Resu_Essai,)
    else:
       remplir_tables(self, typessai, '1', DicoEssai, Resu_Essai,)

    # impression des graphiques
    # --------------------------------------------------------
    impr_graphique(self, DicoEssai, Courbes, NomsFich, Leg_x, Leg_y,
                  {}, {}, typessai,)

    DETRUIRE(CONCEPT=_F(NOM=(__RLIST, __DLIST),), INFO=1)


# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
#                 ESSAI TRIAXIAL NON DRAINE MONOTONE                      #
#                 A DEFORMATION IMPOSEE [TRIA_ND_M_D]                     #
# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
def essai_TRIA_ND_M_D(self, str_n_essai, DicoEssai,\
                      MATER, COMPORTEMENT, CONVERGENCE, INFO):
    """
    Objet: Essai TRIAxial Non Draine Monotone a Deplacement controle
           (TRIA_ND_M_D)
    """
    import numpy as NP
    from Accas import _F
    import aster
    
    typessai= "TRIA_ND_M_D"
    
    # Recuperation des commandes Aster
    # -----------------------------------------
    DEFI_FONCTION  = self.get_cmd('DEFI_FONCTION')
    SIMU_POINT_MAT = self.get_cmd('SIMU_POINT_MAT')
    DETRUIRE       = self.get_cmd('DETRUIRE')
    CREA_TABLE     = self.get_cmd('CREA_TABLE')
    IMPR_TABLE     = self.get_cmd('IMPR_TABLE')
    DEFI_LIST_INST = self.get_cmd('DEFI_LIST_INST')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')
    
    # Recuperation des parametres d'essais
    # -----------------------------------------
    PRES_CONF   = DicoEssai['PRES_CONF']
    EPSI_IMPOSE = DicoEssai['EPSI_IMPOSE']
    KZERO       = DicoEssai['KZERO']
    BIOT_COEF   = DicoEssai['BIOT_COEF']
    NB_INST     = DicoEssai['NB_INST']
    
    # Recuperation des options d'impression
    # -----------------------------------------
    if DicoEssai.has_key('COULEUR'):
    
       COULEUR_NIV2= DicoEssai['COULEUR']
       
       assert len(COULEUR_NIV2) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste COULEUR" %(len(COULEUR_NIV2))+\
       " doit etre egale a        !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                        !!!\n"
       
    else:
       COULEUR_NIV2= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('MARQUEUR'):
    
       MARQUEUR_NIV2= DicoEssai['MARQUEUR']
       
       assert len(MARQUEUR_NIV2) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste MARQUEUR" %(len(MARQUEUR_NIV2))+\
       " doit etre egale a        !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                         !!!\n"
    else:
       MARQUEUR_NIV2= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('STYLE'):
    
       STYLE_NIV2= DicoEssai['STYLE']
       
       assert len(MARQUEUR_NIV2) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste STYLE" %(len(STYLE_NIV2))+\
       " doit etre egale a        !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                          !!!\n"
    else:
       STYLE_NIV2= [-1]*len(PRES_CONF)
    
    # Recuperation des variables supplementaires a imprimer
    # (si existantes) contenues sous le mot-cle 'NOM_CMP'
    # -----------------------------------------
    if DicoEssai.has_key('NOM_CMP'):
       List_Resu_Supp = list(DicoEssai['NOM_CMP'])
    else:
       List_Resu_Supp = None
       
    # dict permettant la gestion des graphiques
    # -----------------------------------------
    Courbes = dict()
    NomsFich= dict()
    Leg_x   = dict()
    Leg_y   = dict()

    # dict permettant la gestion des tables en sortie
    # -----------------------------------------
    Resu_Essai = {'LIST_CMP': []}
    
    cle = ['INST','EPS_AXI','EPS_LAT','SIG_AXI','SIG_LAT','P','Q','PRE_EAU',]
    if List_Resu_Supp:
    
       try:
          List_Resu_Supp.remove('INST')
       except:
          cle+= List_Resu_Supp
       else:
          cle+= List_Resu_Supp
    
    for c in cle:
       Resu_Essai[c] = [[] for k in xrange(len(PRES_CONF))]
       
    # Hors composantes de niveau 1
    # -----------------------------------------
    cle = ['INST','EPS_AXI','EPS_LAT','SIG_AXI','SIG_LAT','P','Q','PRE_EAU',]

    # preparation des graphiques
    # -----------------------------------------
    if str_n_essai:
       str_fich = "%s_%s_" %(typessai,str_n_essai)
    else:
       str_fich = "%s_" %(typessai,)
       
    preparer_graphique('2', DicoEssai, str_fich, Courbes, NomsFich,
                       Leg_x, Leg_y, {}, {},)

    # Creation de la liste d'instants
    # -----------------------------------------
    __RLIST = DEFI_LIST_REEL(DEBUT=0.,
                             INTERVALLE=_F(JUSQU_A=100.,
                                           NOMBRE=NB_INST,),
                             INFO=INFO)

    __DLIST = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__RLIST),
                             ECHEC=_F(SUBD_METHODE='MANUEL',
                                      SUBD_PAS    =2,
                                      SUBD_NIVEAU =10,),
                             INFO=INFO,)
# ---
# Boucle sur les pressions de confinement PRES_CONF
# ---
    for i,sig0__ in enumerate(PRES_CONF):
    
        sig0= -sig0__

        if str_n_essai:
           affiche_infos_essai(str_n_essai, typessai, -sig0, EPSI_IMPOSE[i])
        else:
           affiche_infos_essai('1', typessai, -sig0, EPSI_IMPOSE[i])

        # ---
        # Definition des chargements
        # ---
        __CHAR1 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                VALE=(0., 0., 100., -EPSI_IMPOSE[i],),)

        __CHAR2 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                VALE=(0., 0., 100., .5*EPSI_IMPOSE[i],),)

        # ---
        # Calcul, avec tr(eps) = 0 impose
        # ---
        try:
           __EVOL = SIMU_POINT_MAT(INFO=INFO,
        
            COMPORTEMENT=COMPORTEMENT.List_F(),
            
            CONVERGENCE=CONVERGENCE.List_F(),
            
            MATER=MATER,
            
            INCREMENT=_F(LIST_INST=__DLIST,
                         INST_INIT=0.,
                         INST_FIN =100.,),
                         
            NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
            
            ARCHIVAGE=_F(LIST_INST=__RLIST,),
            
            EPSI_IMPOSE=_F(EPZZ=__CHAR1,
                           EPXX=__CHAR2,
                           EPYY=__CHAR2,),
                           
            SIGM_INIT=_F(SIXX=KZERO * sig0,
                         SIYY=KZERO * sig0,
                         SIZZ=sig0,),
                         
            EPSI_INIT=_F(EPXX=0.,
                         EPYY=0.,
                         EPZZ=0.,
                         EPXY=0.,
                         EPXZ=0.,
                         EPYZ=0.,),)
        
        except (aster.error,aster.onFatalError,), message:
   
           print '\n   !!!(@_@)!!! Arret pour la raison suivante !!!(@_@)!!!\n%s'\
                     %(message)
        
           __EVPOST = self.get_last_concept()
           TabRes   = __EVPOST.EXTR_TABLE().values()
           
           DETRUIRE(CONCEPT=_F(NOM=__EVPOST), INFO=1)

        else:
           TabRes = __EVOL.EXTR_TABLE().values()
            
           DETRUIRE(CONCEPT=_F(NOM=__EVOL), INFO=1)
        # ---
        # Post-traitements
        # ---
        #TabRes = __EVOL.EXTR_TABLE().values()
        
        sig_xx = NP.array(TabRes['SIXX'])
        sig_yy = NP.array(TabRes['SIYY'])
        sig_zz = NP.array(TabRes['SIZZ'])
        eps_xx = NP.array(TabRes['EPXX'])
        eps_yy = NP.array(TabRes['EPYY'])
        eps_zz = NP.array(TabRes['EPZZ'])
        inst   = TabRes['INST']
        
        eps_vol= eps_xx + eps_yy + eps_zz
        pprime = (sig_xx + sig_yy + sig_zz) /3.
        q      = abs(sig_zz - sig_xx)
        p      = -1.*q/3. + sig0
        pre_eau= (p-pprime) /BIOT_COEF

        # stockage pour ecriture dans les tables
        # ---------------------------------------
        Resu_Essai['INST'][i]    = inst
        Resu_Essai['EPS_AXI'][i] = list(-eps_zz)
        Resu_Essai['EPS_LAT'][i] = list(-eps_xx)
        Resu_Essai['SIG_AXI'][i] = list(-sig_zz)
        Resu_Essai['SIG_LAT'][i] = list(-sig_xx)
        Resu_Essai['P'][i]       = list(-pprime)
        Resu_Essai['Q'][i]       = list(q)
        Resu_Essai['PRE_EAU'][i] = list(-pre_eau)
        
        # Recuperation des composantes supplementaires
        # existantes dans le resultat
        # --------------------------------------------------------
        if List_Resu_Supp:
           try:
             # Cas ou list_key existe deja (i>0)
             # list_key contient les composantes
             # EXISTANTES dans le resultat
             # (list_key pas necessairement egal a List_Resu_Supp)
             for lr in list_key:
                Resu_Essai[lr][i] =TabRes[lr]
               
           except:
             # Cas ou list_key n existe pas (i=0)
             list_key=[]
             for lr in List_Resu_Supp:
               if TabRes.has_key(lr):
                  list_key.append(lr)
                  Resu_Essai[lr][i] =TabRes[lr]
                  
           if not i:
             Resu_Essai['LIST_CMP']=TabRes.keys()
             
        # Impression graphique des composantes supplementaires
        # existantes dans le resultat
        # --------------------------------------------------------
        str_leg = "PRES_CONF=%.2E EPSI_IMPO=%.2E" %(-sig0,EPSI_IMPOSE[i],)
                  
        list_x=[list(-pprime),list(-eps_zz),list(-eps_zz),]
        list_y=[list(q),list(q),list(-pre_eau),]
        list_title=["P-Q","EPS_AXI-Q","EPS_AXI-PRE_EAU",]
        
        for g in DicoEssai['GRAPHIQUE']:
    
          if g in list_title:
          
            j = list_title.index(g)
            
            remplir_graphique(DicoEssai, Courbes, list_x[j],
                              list_y[j], str_leg, g,
                              COULEUR_NIV2[i],
                              MARQUEUR_NIV2[i],
                              STYLE_NIV2[i],)
          else:
       
            li  = g.split('-')
          
            if len(li)!=2:
               continue
            else:
               cmpx,cmpy=li[0],li[1]
               
            if (cmpx in Resu_Essai['LIST_CMP']+cle) and \
               (cmpy in Resu_Essai['LIST_CMP']+cle):
               
               remplir_graphique(DicoEssai, Courbes, Resu_Essai[cmpx][i],
                                 Resu_Essai[cmpy][i], str_leg, g,
                                 COULEUR_NIV2[i],
                                 MARQUEUR_NIV2[i],
                                 STYLE_NIV2[i],)

        DETRUIRE(CONCEPT=_F(NOM=(__CHAR1, __CHAR2,),), INFO=1)
# ---
# Fin boucle sur les pressions de confinement PRES_CONF
# ---

    # remplissage des tables
    # --------------------------------------------------------
    if str_n_essai:
       remplir_tables(self, typessai, str_n_essai, DicoEssai, Resu_Essai)
    else:
       remplir_tables(self, typessai, '1', DicoEssai, Resu_Essai)

    # impression des graphiques
    # --------------------------------------------------------
    impr_graphique(self, DicoEssai, Courbes, NomsFich, Leg_x, Leg_y,
                  {}, {}, typessai,)

    DETRUIRE(CONCEPT=_F(NOM=(__RLIST, __DLIST),), INFO=1)


# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
#                ESSAI DE CISAILLEMENT CYCLIQUE DRAINE                    #
#                A DEFORMATION CONTROLEE (CISA_DR_C_D)                    #
# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
def essai_CISA_DR_C_D(self, str_n_essai, DicoEssai, MATER, COMPORTEMENT, CONVERGENCE, INFO):
    """
    Objet: Essai de CISAillement DRaine Cyclique a Deformation controlee
           (CISA_DR_C_D)
    """
    import numpy as NP
    import math as M
    from Accas import _F
    import aster
    from Utilitai.Utmess import UTMESS
    
    typessai = "CISA_DR_C_D"
    
    # Recuperation des commandes Aster
    # -----------------------------------------
    DEFI_FONCTION  = self.get_cmd('DEFI_FONCTION')
    SIMU_POINT_MAT = self.get_cmd('SIMU_POINT_MAT')
    DETRUIRE       = self.get_cmd('DETRUIRE')
    CREA_TABLE     = self.get_cmd('CREA_TABLE')
    IMPR_TABLE     = self.get_cmd('IMPR_TABLE')
    DEFI_LIST_INST = self.get_cmd('DEFI_LIST_INST')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')
    
    # Recuperation des parametres d'essais
    # -----------------------------------------
    PRES_CONF    = DicoEssai['PRES_CONF']
    GAMMA_IMPOSE = DicoEssai['GAMMA_IMPOSE']
    GAMMA_ELAS   = DicoEssai['GAMMA_ELAS']
    KZERO        = DicoEssai['KZERO']
    NB_CYCLE     = DicoEssai['NB_CYCLE']
    NB_INST      = DicoEssai['NB_INST']
    
    # Recuperation des options d'impression
    # -----------------------------------------
    if DicoEssai.has_key('COULEUR_NIV1'):
    
       COULEUR_NIV1= DicoEssai['COULEUR_NIV1']
       
       assert len(COULEUR_NIV1) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste COULEUR_NIV1" %(len(COULEUR_NIV1))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                        !!!\n"
       
    else:
       COULEUR_NIV1= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('MARQUEUR_NIV1'):
    
       MARQUEUR_NIV1= DicoEssai['MARQUEUR_NIV1']
       
       assert len(MARQUEUR_NIV1) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste MARQUEUR_NIV1" %(len(MARQUEUR_NIV1))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                         !!!\n"
    else:
       MARQUEUR_NIV1= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('STYLE_NIV1'):
    
       STYLE_NIV1= DicoEssai['STYLE_NIV1']
       
       assert len(MARQUEUR_NIV1) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste STYLE_NIV1" %(len(STYLE_NIV1))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                          !!!\n"
    else:
       STYLE_NIV1= [-1]*len(PRES_CONF)
       
    if DicoEssai.has_key('COULEUR_NIV2'):
    
       COULEUR_NIV2= DicoEssai['COULEUR_NIV2']
       
       assert len(COULEUR_NIV2) == len(GAMMA_IMPOSE),\
       "\n   !!!   La longueur %2d de la liste COULEUR_NIV2" %(len(COULEUR_NIV2))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste GAMMA_IMPOSE" %(len(GAMMA_IMPOSE))+\
       "                      !!!\n"
       
    else:
       COULEUR_NIV2= [-1]*len(GAMMA_IMPOSE)
    
    if DicoEssai.has_key('MARQUEUR_NIV2'):
    
       MARQUEUR_NIV2= DicoEssai['MARQUEUR_NIV2']
       
       assert len(MARQUEUR_NIV2) == len(GAMMA_IMPOSE),\
       "\n   !!!   La longueur %2d de la liste MARQUEUR_NIV2" %(len(MARQUEUR_NIV2))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste GAMMA_IMPOSE" %(len(GAMMA_IMPOSE))+\
       "                         !!!\n"
    else:
       MARQUEUR_NIV2= [-1]*len(GAMMA_IMPOSE)
    
    if DicoEssai.has_key('STYLE_NIV2'):
    
       STYLE_NIV2= DicoEssai['STYLE_NIV2']
       
       assert len(MARQUEUR_NIV2) == len(GAMMA_IMPOSE),\
       "\n   !!!   La longueur %2d de la liste STYLE_NIV2" %(len(STYLE_NIV2))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste GAMMA_IMPOSE" %(len(GAMMA_IMPOSE))+\
       "                        !!!\n"
    else:
       STYLE_NIV2= [-1]*len(GAMMA_IMPOSE)
    
    # Recuperation des variables supplementaires a imprimer
    # (si existantes) contenues sous le mot-cle 'NOM_CMP'
    # -----------------------------------------
    if DicoEssai.has_key('NOM_CMP'):
       List_Resu_Supp = list(DicoEssai['NOM_CMP'])
    else:
       List_Resu_Supp = None
       
    # Chargement lineaire par morceaux ou sinusoidal?
    # ------------------------------------------------
    sinusoidal = DicoEssai['TYPE_CHARGE'] == 'SINUSOIDAL'

    # dict permettant la gestion des graphiques
    # -----------------------------------------
    Courbes_niv1  =dict()
    NomsFich_niv1 =dict()
    Leg_x_niv1    =dict()
    Leg_y_niv1    =dict()
    Ech_x_niv1    =dict()
    Ech_y_niv1    =dict()
    Courbes_niv2  =dict()
    NomsFich_niv2 =dict()
    Leg_x_niv2    =dict()
    Leg_y_niv2    =dict()
    
    # dict permettant la gestion des tables en sortie
    # Les composantes de NIVEAU 1 sont:
    # - G_SUR_GMAX
    # - DAMPING
    # ----------------------------------------------------
    Resu_Essai = {'LIST_CMP': []}
    
    cle = ['INST','G_SUR_GMAX','DAMPING','GAMMA','SIG_XY',]
    if List_Resu_Supp:
    
       try:
          List_Resu_Supp.remove('INST')
       except:
          cle+= List_Resu_Supp
       else:
          cle+= List_Resu_Supp
    
    for c in cle:
       Resu_Essai[c] = [[] for k in xrange(len(PRES_CONF))]
       
    # Hors composantes de niveau 1
    # 'G_SUR_GMAX','DAMPING',
    # -----------------------------------------
    cle = ['INST','GAMMA','SIG_XY',]

    # NIVEAU 1: preparation des graphiques
    # -----------------------------------------
    if str_n_essai:
       str_fich_niv1 = "%s_%s_" %(typessai,str_n_essai)
    else:
       str_fich_niv1 = "%s_" %(typessai,)
    
    preparer_graphique('1', DicoEssai, str_fich_niv1, Courbes_niv1, NomsFich_niv1,
                       Leg_x_niv1, Leg_y_niv1, Ech_x_niv1, Ech_y_niv1,)

    # ---
    # Creation de la liste d'instants (NB_INST = nombre d'instants par 1/4 de cycle)
    # ---
    __RLIST = DEFI_LIST_REEL(DEBUT=0.,
                             INTERVALLE=[_F(JUSQU_A=10., NOMBRE=NB_INST,), ] +\
                                        [_F(JUSQU_A=10.*(2*k+1), NOMBRE=2*NB_INST,)
                                            for k in xrange(1, 2*NB_CYCLE+1)],
                             INFO=INFO)

    __DLIST = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__RLIST),
                             ECHEC=_F(SUBD_METHODE='MANUEL',
                                      SUBD_PAS    =2,
                                      SUBD_NIVEAU =10,),
                             INFO=INFO,)
# ---
# Boucle NIVEAU 1 sur les pressions de confinement PRES_CONF
# ---
    for i,sig0__ in enumerate(PRES_CONF):
    
        sig0 = -sig0__

        # NIVEAU 2: preparation des graphiques
        # ----------------------------------------
        str_fich_niv2 = str_fich_niv1 + "CONF" +\
                        int_2_str(i+1, len(PRES_CONF)) + "_"

        preparer_graphique('2', DicoEssai, str_fich_niv2, Courbes_niv2, NomsFich_niv2,
                           Leg_x_niv2, Leg_y_niv2, {}, {},)
        # ---
        # Calcul du module de cisaillement secant maximal (elasticite)
        # ---
        Gs_max = Calc_Gs_max(self, GAMMA_ELAS, sig0, KZERO,\
                             MATER, COMPORTEMENT, CONVERGENCE,)

    # ---
    # Boucle NIVEAU 2 sur les amplitudes de distorsion GAMMA_IMPOSE
    # ---
        for j,eps0 in enumerate(GAMMA_IMPOSE):

            if str_n_essai:
               affiche_infos_essai(str_n_essai, typessai, -sig0, eps0,)
            else:
               affiche_infos_essai('1', typessai, -sig0, eps0,)

            # ---
            # Definition des chargements
            # ---
            if sinusoidal:
            
               absc_peak= [10.*(2*k+1) for k in xrange(2*NB_CYCLE+1)]
               abscisse = [10.*k/3./NB_INST for k in xrange(3*NB_INST)]
               
               for inst_peak in absc_peak:
                  abscisse+= [inst_peak + 10.*kk/3./NB_INST for kk in xrange(6*NB_INST)]
               
               # absc_sinus varie de 0 a Pi/2 par intervalles de NB_INST=10s
               # (sinus varie de 0 a 1)
               # -------------------------------------------------------------
               absc_sinus= M.pi*NP.array(abscisse)/20.
               
               ordonnee = NP.sin(absc_sinus)*.5*eps0
               
            else:
               abscisse = [0.]+[10.*(2*k+1) for k in xrange(2*NB_CYCLE+1)]
               ordonnee = [0.]+[.5*eps0 * (-1.)**(k+1) for k in xrange(2*NB_CYCLE+1)]
            
            __CHAR1 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                    ABSCISSE=abscisse,
                                    ORDONNEE=list(ordonnee),)

            __CHAR2 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                    VALE=(0.                , sig0,
                                          10.*(4*NB_CYCLE+1), sig0,),)

            __CHAR3 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                    VALE=(0.                , KZERO*sig0,
                                          10.*(4*NB_CYCLE+1), KZERO*sig0,),)
            # ---
            # Calcul
            # ---
            try:
               __EVOL = SIMU_POINT_MAT(INFO=INFO,
            
                COMPORTEMENT=COMPORTEMENT.List_F(),
                
                CONVERGENCE=CONVERGENCE.List_F(),
                
                MATER=MATER,
                
                INCREMENT=_F(LIST_INST=__DLIST,
                             INST_INIT=0.,
                             INST_FIN =10.*(4*NB_CYCLE+1),),
                             
                NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
                
                ARCHIVAGE=_F(LIST_INST=__RLIST,),
                
                SIGM_IMPOSE=_F(SIXX=__CHAR3,
                               SIYY=__CHAR3,
                               SIZZ=__CHAR2,),
                               
                EPSI_IMPOSE=_F(EPXY=__CHAR1,),
                
                SIGM_INIT=_F(SIXX=KZERO*sig0,
                             SIYY=KZERO*sig0,
                             SIZZ=sig0,),
                             
                EPSI_INIT=_F(EPXX=0.,
                             EPYY=0.,
                             EPZZ=0.,
                             EPXY=0.,
                             EPXZ=0.,
                             EPYZ=0.,),)
                             
            except (aster.error,aster.onFatalError,),mess:
                    
               print\
      '\n!!!(@_@)!!! Arret pour la raison suivante !!!(@_@)!!!\n\n%s'\
      %(mess)
            
               __EVPOST = self.get_last_concept()
               TabRes   = __EVPOST.LIST_VARI_ACCES()
                
               DETRUIRE(CONCEPT=_F(NOM=__EVPOST), INFO=1)

            else:
               TabRes = __EVOL.EXTR_TABLE().values()
                
               DETRUIRE(CONCEPT=_F(NOM=__EVOL), INFO=1)
                
            # ---
            # Post-traitements.
            # ---
            #TabRes = __EVOL.EXTR_TABLE().values()
            
            inst   = TabRes['INST']
            sig_xx = NP.array(TabRes['SIXX'])
            sig_yy = NP.array(TabRes['SIYY'])
            sig_zz = NP.array(TabRes['SIZZ'])
            sig_xy = NP.array(TabRes['SIXY'])
            eps_xx = NP.array(TabRes['EPXX'])
            eps_yy = NP.array(TabRes['EPYY'])
            eps_zz = NP.array(TabRes['EPZZ'])
            eps_xy = NP.array(TabRes['EPXY'])
            
            gamma  = 2.*eps_xy
            #eps_vol= eps_xx + eps_yy + eps_zz
            p      = (sig_xx + sig_yy + sig_zz) /3.
            q      = abs(sig_zz-sig_xx)
            
            # ------------------------------------------------------
            #
            #    CALCUL DU MODULE SECANT POUR LA COURBE G-GAMMA
            #
            # ------------------------------------------------------
            #   ind1 -> indice au debut du dernier cycle
            #   ind2 -> indice a la moitie du dernier cycle
            #   ind3 -> indice a la fin du dernier cycle
            # ------------------------------------------------------
            ind1 = inst.index(10. * (2 * (2 * NB_CYCLE - 2) + 1))
            ind2 = inst.index(10. * (2 * (2 * NB_CYCLE - 1) + 1))
            ind3 = inst.index(10. * (2 * (2 * NB_CYCLE) + 1))

            # module de cisaillement secant normalise Gs
            # ------------------------------------------------------
            Gs = 0.5 * abs(sig_xy[ind3] - sig_xy[ind2]) /eps0
            Gs = Gs /Gs_max
            
            if not(Gs <= 1. or abs(Gs - 1.) <= 1.e-8):
                UTMESS('F', 'COMPOR2_36',
                       valk=(typessai, 'cisaillement', 'EPSI_ELAS'),
                       valr=(GAMMA_ELAS),)

            # taux d'amortissement D (aire delta_W : methode des trapezes)
            # ------------------------------------------------------
            # 1ere moitie de la boucle
            I = NP.sum(0.5 * (sig_xy[ind1:ind2] + sig_xy[ind1+1:ind2+1]) *\
                             (gamma[ind1+1:ind2+1] - gamma[ind1:ind2]))
            
            # 2eme moitie de la boucle
            J = NP.sum(0.5 * (sig_xy[ind2:ind3] + sig_xy[ind2+1:ind3+1]) *\
                             (gamma[ind2+1:ind3+1] - gamma[ind2:ind3]))
                
            delta_W = abs(I+J)
            
            # Definition gde l'amortissement hysteretique generalisee:
            # Aire du grand triangle: energie elastique sur le 1/2 du cycle
            # Kokusho,
            # "cyclic triaxial test of dynamic soil properties for wide strain range"
            # Soil & Foundations, 1980
            # --------------------------------------------------------
            # W = 0.5 * abs(sig_xy[ind3] * eps0)
            # D = delta_W / (4. * M.pi * W)
            
            W = abs((sig_xy[ind3]-sig_xy[ind2]) * eps0)
            D = delta_W / M.pi/W
            
            # Sauvegarde des resultats par defaut
            # ------------------------------------------------------
            Resu_Essai['GAMMA'][i].append(list(gamma))
            Resu_Essai['SIG_XY'][i].append(list(sig_xy))
            Resu_Essai['INST'][i].append(inst)
            Resu_Essai['G_SUR_GMAX'][i].append(Gs)
            Resu_Essai['DAMPING'][i].append(D)
            
            # Recuperation des composantes supplementaires
            # existantes dans le resultat
            # --------------------------------------------------------
            if List_Resu_Supp:
               try:
                 # Cas ou list_key existe deja (i>0)
                 # list_key contient les composantes
                 # EXISTANTES dans le resultat
                 # (list_key pas necessairement egal a List_Resu_Supp)
                 for lr in list_key:
                    Resu_Essai[lr][i].append(TabRes[lr])
               
               except:
                 # Cas ou list_key n existe pas (i=0)
                 list_key=[]
                 for lr in List_Resu_Supp:
                   if TabRes.has_key(lr):
                      list_key.append(lr)
                      Resu_Essai[lr][i].append(TabRes[lr])
                  
               if not i:
                 Resu_Essai['LIST_CMP'] =TabRes.keys()

            # NIVEAU 2: remplissage des graphiques
            # ------------------------------------------------------
            str_leg2 = "GAMA_IMPO=" + str("%.2E" %(eps0))
                                      
            list_x=[list(-p),list(gamma),]
            list_y=[list(q),list(sig_xy),]
            list_title=["P-Q","GAMMA-SIGXY",]
        
            for g in DicoEssai['GRAPHIQUE']:
    
              if g in list_title:
          
                k = list_title.index(g)
            
                remplir_graphique(DicoEssai, Courbes_niv2, list_x[k],
                                  list_y[k], str_leg2, g,
                                  COULEUR_NIV2[j],
                                  MARQUEUR_NIV2[j],
                                  STYLE_NIV2[j],)
              else:
       
                li  = g.split('-')
          
                if len(li)!=2:
                   continue
                else:
                   cmpx,cmpy=li[0],li[1]
               
                if (cmpx in Resu_Essai['LIST_CMP']+cle) and \
                   (cmpy in Resu_Essai['LIST_CMP']+cle):
               
                   remplir_graphique(DicoEssai, Courbes_niv2, Resu_Essai[cmpx][i][j],
                                     Resu_Essai[cmpy][i][j], str_leg2, g,
                                     COULEUR_NIV2[j],
                                     MARQUEUR_NIV2[j],
                                     STYLE_NIV2[j],)

            DETRUIRE(CONCEPT=_F(NOM=(__CHAR1, __CHAR2, __CHAR3,),),
                     INFO=1)
    # ---
    # Fin boucle sur les amplitudes de cisaillement EPSI_IMPOSE [j]
    # ---

        # NIVEAU 1: remplissage des graphiques
        # ------------------------------------------------------
        str_leg1 = "PRES_CONF=" + str("%.3E" %(sig0))

        if 'GAMMA-G_SUR_GMAX' in DicoEssai['GRAPHIQUE']:
        
           remplir_graphique(DicoEssai, Courbes_niv1, GAMMA_IMPOSE,\
                          Resu_Essai['G_SUR_GMAX'][i], str_leg1, "GAMMA-G_SUR_GMAX",
                          COULEUR_NIV1[i],
                          MARQUEUR_NIV1[i],
                          STYLE_NIV1[i],)
            
        if 'GAMMA-DAMPING' in DicoEssai['GRAPHIQUE']:
        
           remplir_graphique(DicoEssai, Courbes_niv1, GAMMA_IMPOSE,\
                          Resu_Essai['DAMPING'][i], str_leg1, "GAMMA-DAMPING",
                          COULEUR_NIV1[i],
                          MARQUEUR_NIV1[i],
                          STYLE_NIV1[i],)
            
        if 'G_SUR_GMAX-DAMPING' in DicoEssai['GRAPHIQUE']:
        
           remplir_graphique(DicoEssai, Courbes_niv1, Resu_Essai['G_SUR_GMAX'][i],\
                          Resu_Essai['DAMPING'][i], str_leg1, "G_SUR_GMAX-DAMPING",
                          COULEUR_NIV1[i],
                          MARQUEUR_NIV1[i],
                          STYLE_NIV1[i],)

        # NIVEAU 2: impression des graphiques
        # ------------------------------------------------------
        impr_graphique(self, DicoEssai, Courbes_niv2, NomsFich_niv2, Leg_x_niv2,
                       Leg_y_niv2, {}, {}, typessai+" - "+str_leg1,
                       graph=i*len(Courbes_niv2),)
# ---
# Fin boucle sur les sur les pressions de confinement PRES_CONF
# ---
    
    if str_n_essai:
       remplir_tables(self, typessai, str_n_essai, DicoEssai, Resu_Essai)
    else:
       remplir_tables(self, typessai, '1', DicoEssai, Resu_Essai)

    # NIVEAU 1: impression des graphiques
    # --------------------------------------------------------
    impr_graphique(self, DicoEssai, Courbes_niv1, NomsFich_niv1,
                   Leg_x_niv1, Leg_y_niv1, Ech_x_niv1, Ech_y_niv1,
                   typessai,graph=len(PRES_CONF)*len(Courbes_niv2),)

    DETRUIRE(CONCEPT=_F(NOM=(__RLIST, __DLIST),), INFO=1)
    

# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
#              ESSAI TRIAXIAL NON DRAINE CYCLIQUE ALTERNE                 #
#                   A FORCE CONTROLEE (TRIA_ND_C_F)                       #
# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
def essai_TRIA_ND_C_F(self, str_n_essai, DicoEssai, MATER, COMPORTEMENT,
                      CONVERGENCE, INFO):
    """
    Objet: Essai TRIAxial Non Draine Cyclique alterne a Force controlee
           (TRIA_ND_C_F)
    """
    import numpy as NP
    import math as M
    from Accas import _F
    import aster
    from Utilitai.Utmess import UTMESS
    from Comportement import catalc
    from Contrib.calc_point_mat import CALC_POINT_MAT
    
    typessai = "TRIA_ND_C_F"
    
    # Recuperation des commandes Aster
    # -----------------------------------------
    DEFI_FONCTION = self.get_cmd('DEFI_FONCTION')
    DETRUIRE      = self.get_cmd('DETRUIRE')
    CREA_TABLE    = self.get_cmd('CREA_TABLE')
    IMPR_TABLE    = self.get_cmd('IMPR_TABLE')
    DEFI_LIST_INST= self.get_cmd('DEFI_LIST_INST')
    DEFI_LIST_REEL= self.get_cmd('DEFI_LIST_REEL')
    
    # Recuperation des parametres d'essais
    # -----------------------------------------
    PRES_CONF   = DicoEssai['PRES_CONF']
    SIGM_IMPOSE = DicoEssai['SIGM_IMPOSE']
    BIOT_COEF   = DicoEssai['BIOT_COEF']
    UN_SUR_K    = DicoEssai['UN_SUR_K']
    KZERO       = DicoEssai['KZERO']
    NB_CYCLE    = DicoEssai['NB_CYCLE']
    NB_INST     = DicoEssai['NB_INST']
    NB_INST_MONO= DicoEssai['NB_INST_MONO']
#     NB_INST_MONO= 400
    arret       = DicoEssai['ARRET_LIQUEFACTION'] == 'OUI'
    K_EAU       = 1. / UN_SUR_K
    comp        = ['XX','YY','ZZ','XY','XZ','YZ']
    coef_eau    = K_EAU / BIOT_COEF
    vale_crit   = dict();
    nbcrit      = len(DicoEssai['CRIT_LIQUEFACTION']);
    
    for i,t in enumerate(DicoEssai['CRIT_LIQUEFACTION']):
    
       if t == 'RU_MAX':
       
          vale_crit[t]=DicoEssai['VALE_CRIT'][i]
       
          print '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
          print '   !                                                  !'
          print '   !          LE CRITERE DE LIQUEFACTION NO.%1d EST:    !' %(i+1)
          print '   !                                                  !'
          print '   !           RU > %.2f                              !' %(vale_crit[t])
          print '   !                                                  !'
          print '   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    
       if t == 'EPSI_ABSO_MAX':
       
          vale_crit[t]=DicoEssai['VALE_CRIT'][i]
       
          # Positif en compression
          # ----------------------
          print '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
          print '   !                                                  !'
          print '   !          LE CRITERE DE LIQUEFACTION NO.%1d EST:    !' %(i+1)
          print '   !                                                  !'
          if vale_crit[t] >0.:
             print '   !           EPSI_AXI > %.4e                 !' %(vale_crit[t])
          else:
             print '   !           EPSI_AXI < %.4e                 !' %(vale_crit[t])
          print '   !                                                  !'
          print '   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    
       if t == 'EPSI_RELA_MAX':
       
          vale_crit[t]=DicoEssai['VALE_CRIT'][i]
       
          # Positif en compression
          # ----------------------
          print '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
          print '   !                                                  !'
          print '   !          LE CRITERE DE LIQUEFACTION NO.%1d EST:    !' %(i+1)
          print '   !                                                  !'
          print '   !    EPSI_AXI_MAXI - EPSI_AXI_MINI > %.4e    !'\
                    %(vale_crit[t])
          print '   !                                                  !'
          print '   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    
    # Recuperation des options d'impression
    # -----------------------------------------
    if DicoEssai.has_key('COULEUR_NIV1'):
    
       COULEUR_NIV1= DicoEssai['COULEUR_NIV1']
       
       assert len(COULEUR_NIV1) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste COULEUR_NIV1" %(len(COULEUR_NIV1))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                        !!!\n"
       
    else:
       COULEUR_NIV1= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('MARQUEUR_NIV1'):
    
       MARQUEUR_NIV1= DicoEssai['MARQUEUR_NIV1']
       
       assert len(MARQUEUR_NIV1) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste MARQUEUR_NIV1" %(len(MARQUEUR_NIV1))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                         !!!\n"
    else:
       MARQUEUR_NIV1= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('STYLE_NIV1'):
    
       STYLE_NIV1= DicoEssai['STYLE_NIV1']
       
       assert len(MARQUEUR_NIV1) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste STYLE_NIV1" %(len(STYLE_NIV1))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                          !!!\n"
    else:
       STYLE_NIV1= [-1]*len(PRES_CONF)
       
    if DicoEssai.has_key('COULEUR_NIV2'):
    
       COULEUR_NIV2= DicoEssai['COULEUR_NIV2']
       
       assert len(COULEUR_NIV2) == len(SIGM_IMPOSE),\
       "\n   !!!   La longueur %2d de la liste COULEUR_NIV2" %(len(COULEUR_NIV2))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste SIGM_IMPOSE" %(len(SIGM_IMPOSE))+\
       "                      !!!\n"
       
    else:
       COULEUR_NIV2= [-1]*len(SIGM_IMPOSE)
    
    if DicoEssai.has_key('MARQUEUR_NIV2'):
    
       MARQUEUR_NIV2= DicoEssai['MARQUEUR_NIV2']
       
       assert len(MARQUEUR_NIV2) == len(SIGM_IMPOSE),\
       "\n   !!!   La longueur %2d de la liste MARQUEUR_NIV2" %(len(MARQUEUR_NIV2))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste SIGM_IMPOSE" %(len(SIGM_IMPOSE))+\
       "                         !!!\n"
    else:
       MARQUEUR_NIV2= [-1]*len(SIGM_IMPOSE)
    
    if DicoEssai.has_key('STYLE_NIV2'):
    
       STYLE_NIV2= DicoEssai['STYLE_NIV2']
       
       assert len(MARQUEUR_NIV2) == len(SIGM_IMPOSE),\
       "\n   !!!   La longueur %2d de la liste STYLE_NIV2" %(len(STYLE_NIV2))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste SIGM_IMPOSE" %(len(SIGM_IMPOSE))+\
       "                        !!!\n"
    else:
       STYLE_NIV2= [-1]*len(SIGM_IMPOSE)
    
    # Recuperation des variables supplementaires a imprimer
    # (si existantes) contenues sous le mot-cle 'NOM_CMP'
    # -----------------------------------------
    if DicoEssai.has_key('NOM_CMP'):
       List_Resu_Supp = list(DicoEssai['NOM_CMP'])
    else:
       List_Resu_Supp = None
       
    # Chargement lineaire par morceaux ou sinusoidal?
    # ------------------------------------------------
    sinusoidal = DicoEssai['TYPE_CHARGE'] == 'SINUSOIDAL'

    # recuperation du nombre de VI associe a la LdC
    # -----------------------------------------
    nom_lc = COMPORTEMENT.List_F()[0]['RELATION']
    num_lc, nb_vari, nbid = catalc.get_info(nom_lc)
    
    assert type(nb_vari) is int and nb_vari > 0

    # dict permettant la gestion des graphiques
    # -----------------------------------------
    Courbes_niv1 = dict()
    NomsFich_niv1= dict()
    Leg_x_niv1   = dict()
    Leg_y_niv1   = dict()
    Courbes_niv2 = dict()
    NomsFich_niv2= dict()
    Leg_x_niv2   = dict()
    Leg_y_niv2   = dict()
    
    # dict permettant la gestion des tables en sortie
    # Les composantes de NIVEAU 1 sont:
    # - NCYCL
    # - DSIGM
    # ----------------------------------------------------
    Resu_Essai = {'LIST_CMP': []}
    Vari_Supp  = dict()
    
    cle = ['INST','EPS_AXI','EPS_LAT','EPS_VOL','SIG_AXI','SIG_LAT',\
           'P','Q','PRE_EAU','RU','NCYCL','DSIGM',]
           
    if List_Resu_Supp:
    
       try:
          List_Resu_Supp.remove('INST')
       except:
          cle+= List_Resu_Supp
       else:
          cle+= List_Resu_Supp
       
       for c in List_Resu_Supp:
          Vari_Supp[c] = [[] for k in xrange(len(PRES_CONF))]
    
    for c in cle:
       Resu_Essai[c] = [[] for k in xrange(len(PRES_CONF))]
       
    # Hors composantes de niveau 1:
    # 'NCYCL','DSIGM',
    # -----------------------------------------
    cle = ['INST','EPS_AXI','EPS_LAT','EPS_VOL','SIG_AXI','SIG_LAT',\
           'P','Q','PRE_EAU','RU',]
           
    # !!!(@_@)!!! Attention: cette structure doit etre evitee:
    # !!!(@_@)!!! 
    # !!!(@_@)!!!     n_cyc_table = [[0.]*len(EPSI_IMPOSE)]*len(PRES_CONF)
    # !!!(@_@)!!! 
    # !!!(@_@)!!!     il faut creer les listes de niveau 2
    # !!!(@_@)!!!     au fur et a mesure
    n_cyc_table = []

    # NIVEAU 1: preparation des graphiques
    # -----------------------------------------
    if str_n_essai:
       str_fich_niv1 = "%s_%s_" %(typessai,str_n_essai)
    else:
       str_fich_niv1 = "%s_" %(typessai,)
    
    preparer_graphique('1', DicoEssai, str_fich_niv1, Courbes_niv1,
                       NomsFich_niv1, Leg_x_niv1, Leg_y_niv1, {}, {},)

    # ---
    # Creation de la liste d'instants:
    # - 4*NB_INST : nombre d'instants par cycles
    # - Duree d'un cycle = 4*10
    # ---
    __RLIST = DEFI_LIST_REEL(DEBUT=0.,
                             INTERVALLE=[_F(JUSQU_A=10.*(k+1), NOMBRE=NB_INST,)
                                         for k in xrange(4*NB_CYCLE)],
                             INFO=INFO)

    __DLIST = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__RLIST),
                             ECHEC=_F(SUBD_METHODE='MANUEL',
                                      SUBD_PAS    =2,
                                      SUBD_NIVEAU =10,),
                             INFO=INFO,)

    # IMPORTANT pour la gestion de l'instabilite (fiche 23451)
    # Date:    31/03/2015
    # ------------------------------------------------------------
    inst_peak = [10.+40.*k for k in range(NB_CYCLE)]
    #nb_redec1,nb_redec2 = 100,400
    nb_redec1,nb_redec2 = NB_INST_MONO,2*NB_INST_MONO

# ----------------------------------------------------------------
# Boucle NIVEAU 1 sur les pressions de confinement PRES_CONF
# ----------------------------------------------------------------
    for i,sig0 in enumerate(PRES_CONF):
    
        q0 = -sig0*(1.-KZERO)
        
        n_cyc_table.append( [0.]*len(SIGM_IMPOSE) );

        # NIVEAU 2: preparation des graphiques
        # ----------------------------------------
        str_fich_niv2 = str_fich_niv1 +\
                        "CONF" + int_2_str(i+1, len(PRES_CONF)) + "_"
            
        preparer_graphique('2', DicoEssai, str_fich_niv2, Courbes_niv2,
                           NomsFich_niv2, Leg_x_niv2, Leg_y_niv2, {}, {},)

    # ----------------------------------------------------------------
    # Boucle NIVEAU 2 sur les amplitudes de variation SIGM_IMPOSE
    # ----------------------------------------------------------------
        for j,dsig__ in enumerate(SIGM_IMPOSE):
            
            # dsig est negatif en compression
            dsig= -dsig__

            if str_n_essai:
               affiche_infos_essai(str_n_essai, typessai, sig0, dsig__,)
            else:
               affiche_infos_essai('1', typessai, sig0, dsig__,)

            # ---
            # Definition des chargements
            # ---
            if sinusoidal:

               absc_peak= [10. * (2*k+1) for k in xrange(2*NB_CYCLE)] +\
                          [10. * (4*NB_CYCLE)]
                          
               abscisse = [10.*k/3./NB_INST for k in xrange(3*NB_INST)]
   
               for ipeak in absc_peak[:-1]:
                  abscisse+= [ipeak + 10.*kk/3./NB_INST for kk in xrange(6*NB_INST)]
                  
               #abscisse+= [absc_peak[-1] + 10.*k/3./NB_INST for k in xrange(3*NB_INST)]
               
               # absc_sinus varie de 0 a Pi/2 par intervalles de NB_INST=10s
               # (sinus varie de 0 a 1)
               # -------------------------------------------------------------
               absc_sinus= M.pi*NP.array(abscisse)/20.
   
               ordonnee = -sig0 + NP.sin(absc_sinus)*dsig
   
            else:
               abscisse = [0.] +\
                         [10. * (2*k+1) for k in xrange(2*NB_CYCLE)] +\
                         [10. * (4*NB_CYCLE)]
               
               ordonnee = [-sig0] +\
                         [-sig0 + dsig*(-1)**k for k in xrange(2*NB_CYCLE)] +\
                         [-sig0]

            __CHAR1 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                    ABSCISSE=abscisse,
                                    ORDONNEE=list(ordonnee),)

            __CHAR2 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                    VALE=(0.                , -KZERO*sig0,
                                          10. * (4*NB_CYCLE), -KZERO*sig0,),
                                    PROL_DROITE ='CONSTANT',)
            # ---
            # Calcul
            # ---
            calc_ok = True
            #
            # -----------------------------------------
            # Mode debug = True : impression enrichie
            # -----------------------------------------
            info_dbg= False
            #
            try:
               # Contrainte SIGMA_1 imposee
               # -----------------------------------
                __EVOL = CALC_POINT_MAT(INFO=INFO,
                
                    COMPORTEMENT=COMPORTEMENT.List_F(),
                    
                    CONVERGENCE=CONVERGENCE.List_F(),
                    
                    MATER=MATER,
                    
                    INCREMENT=_F(LIST_INST=__DLIST,
                                 INST_INIT=0.,
                                 INST_FIN =10.*(4*NB_CYCLE),),
                                 
                    NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
                    
                    ARCHIVAGE=_F(LIST_INST=__RLIST,),
                    
                    VECT_IMPO=(_F(NUME_LIGNE=1, VALE=__CHAR2),
                               _F(NUME_LIGNE=2, VALE=__CHAR2),
                               _F(NUME_LIGNE=3, VALE=__CHAR1),),
                               
                    MATR_C1=(_F(NUME_LIGNE=1, NUME_COLONNE=1, VALE=1.),
                             _F(NUME_LIGNE=2, NUME_COLONNE=2, VALE=1.),
                             _F(NUME_LIGNE=3, NUME_COLONNE=3, VALE=1.),),
                             
                    MATR_C2=(_F(NUME_LIGNE=1, NUME_COLONNE=1, VALE=K_EAU),
                             _F(NUME_LIGNE=1, NUME_COLONNE=2, VALE=K_EAU),
                             _F(NUME_LIGNE=1, NUME_COLONNE=3, VALE=K_EAU),
                             _F(NUME_LIGNE=2, NUME_COLONNE=1, VALE=K_EAU),
                             _F(NUME_LIGNE=2, NUME_COLONNE=2, VALE=K_EAU),
                             _F(NUME_LIGNE=2, NUME_COLONNE=3, VALE=K_EAU),
                             _F(NUME_LIGNE=3, NUME_COLONNE=1, VALE=K_EAU),
                             _F(NUME_LIGNE=3, NUME_COLONNE=2, VALE=K_EAU),
                             _F(NUME_LIGNE=3, NUME_COLONNE=3, VALE=K_EAU),),
                             
                    SIGM_INIT= _F(SIXX=-KZERO*sig0,
                                  SIYY=-KZERO*sig0,
                                  SIZZ=-sig0,),)

            except (aster.error,aster.onFatalError,), message:
   
                print '\n   !!!(@_@)!!! Arret pour la raison suivante !!!(@_@)!!!\n%s'\
                     %(message)

                calc_ok  = False
                __EVPOST = self.get_last_concept()
                TabRes   = __EVPOST.EXTR_TABLE().values()
                
                DETRUIRE(CONCEPT=_F(NOM=__EVPOST), INFO=1)

            else:
                TabRes = __EVOL.EXTR_TABLE().values()
                
                DETRUIRE(CONCEPT=_F(NOM=__EVOL), INFO=1)

# =================================================================================
# Debut Modifs fiche 23451
# Author:  Marc KHAM  -----------------------
# Date:    31/03/2015 -----------------------
#
            titre='\n   # ===================================== #\n'+\
            '   #\n   # TNDC :: REPRISE MONOTONE APRES ECHEC  #\n   #\n'+\
            '   # ===================================== #\n'

            # ========================================================
            #
            # VERIFICATION DU CRITERE D'INSTABILITE:
            # (QUELLE QUE SOIT L'ISSUE DU CALCUL)
            #
            # 1- ON VERIFIE LES CRITERES D'INSTABILITE OU DE NON CV:
            #
            #    * CRIT1 = DELTA_EPZZ[N] / DELTA_EPZZ[N-1] > 10
            #
            #    * CRIT2 = DELTA_Q[N] / DELTA_P[N] < 0.25
            #
            #    * NON CV
            #
            # 2- ON EFFECTUE UNE SUCCESSION D'ESSAIS MONOTONES
            #    A EPSILON CONTROLE A PARTIR DU DERNIER INSTANT
            #
            # ========================================================
            inst  = TabRes['INST']

            q   =NP.array(TabRes['SIZZ']) - NP.array(TabRes['SIXX'])
            p   =(NP.array(TabRes['SIZZ'])+2.*NP.array(TabRes['SIXX'])) /3.
            epzz=NP.array(TabRes['EPZZ'])

            depzzm=NP.abs( (epzz[2:]-epzz[1:-1])/(epzz[1:-1]-epzz[:-2]) )
            dqdp  =NP.abs( (q[1:]-q[:-1])/(p[1:]-p[:-1]) )

            interv   =20
            indx_peak=[]

            for n,t in enumerate(inst_peak):
              if t<=inst[-1]:
                indx_peak.append(inst.index(t))

            if info_dbg:
              print '\n * INST FINAL    = %f' %(inst[-1])
              print ' * Q               = %e' %(q[-1])
              print ' * P               = %e' %(p[-1])
              print ' * INST PEAK LIST  = ',inst_peak
              print ' * INDEX PEAK LIST = ',indx_peak
              print ' * CONVERGENCE     = ',calc_ok

            indx_init,numcyc,inst_init,=-1,-1,0

            for k,n in enumerate(indx_peak):

               n0=min(interv,len(depzzm[:n]))
               depzzmax=max(depzzm[n-n0:n])
               dqdpmin =min(dqdp[n-n0:n])

               ncrit,nume1,nume2=0,0,0
               if depzzmax>10.:
                 nume1=list(depzzm).index(depzzmax)
                 ncrit+=1
               if dqdpmin<.25:
                 nume2=list(dqdp).index(dqdpmin)
                 ncrit+=1

               if info_dbg:
                 print '\n   + INDEX PEAK = %d' %(n)
                 print '   + P          = %e' %(p[n])
                 print '   + Q          = %e' %(q[n])
                 print '   + DEPM       = %f' %(depzzmax)
                 print '   + DQDP       = %f' %(dqdpmin)
                 print '   + CRIT       = %d   NUME_DEPS = %d   NUME_DQDP = %d'\
                     %(ncrit,nume1,nume2)

               if ncrit>=2:
               
                 indx_init=nume2
                 numcyc   =k
                 
                 print '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                 print '   !                                                   !'
                 print '   !      INSTABILITE DETECTEE A L INSTANT %.3f     !'\
                         %(inst[indx_init])
                 print '   !               AU CYCLE NUMERO %3d               !'\
                         %(numcyc+1)
                 print '   !                                                   !'
                 print '   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n'
                 
                 break
            #
            # Quand le calcul se termine en non CV sANS QUE LE CRITERE
            # SOIT ACTIF, on termine aussi par des cycles de deformation
            # imposee
            # ----------------------------------------------------------
            if numcyc==-1 and (not calc_ok):
            
               indx_init=len(inst)-2
              
               for n in range(NB_CYCLE):
               
                 if inst[-1]>=10.+40.*n and inst[-1]<=10.+40.*(n+1):
                 
                   numcyc=n
                   
                   print '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                   print '   !                                                   !'
                   print '   !            NON-CONVERGENCE DETECTEE A             !'
                   print '   !       L INSTANT %.3f AU CYCLE NUMERO %3d       !'\
                         %(inst[indx_init],numcyc+1)
                   print '   !                                                   !'
                   print '   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
            
                   break
                  
            if info_dbg:
                print '   + NUMCYC     = %d' %(numcyc)
            

            # ========================================================
            #
            # 2- SUCCESION DE TND MONOTONES A EPSILON IMPOSE
            #
            # ========================================================
            # if indx_init>0 or (not calc_ok):
            if indx_init>0:
              
              # 08/10/2018: heuristique pour detection de la 
              #             direction du chargement monotone:
              #             on recule de 2 pas de temps pour eviter
              #             un plateau eventuel
              indx_init-=2
              # Fin ---
              inst_init= inst[indx_init]

              print titre
              
              if info_dbg:
                print ' * ETAT INIT:'
                print '   =========\n'
                print '   + CYCLE NUMERO %d SUR %d' %(numcyc+1,NB_CYCLE)
                print '   + INDEX INIT=%d' %(indx_init)
                print '   + INST INIT =%f' %(inst_init)

              sigm,epsi,=[0.]*6,[0.]*6,
              for n in range(3):
                sigm[n]=TabRes['SI%s' %(comp[n])][indx_init]
                epsi[n]=TabRes['EP%s' %(comp[n])][indx_init]

                if info_dbg:
                  print '   + EP%s =%.6e   SI%s =%.6e'\
                  %(comp[n],epsi[n],comp[n],sigm[n])

              p = (sigm[0]+sigm[1]+sigm[2]) /3.
              q = sigm[2]-sigm[0]
              q2= TabRes['SIZZ'][indx_init-1]-TabRes['SIXX'][indx_init-1]
              q3= TabRes['SIZZ'][indx_init-2]-TabRes['SIXX'][indx_init-2]
              
#               for n in range(1,11):
#                 q2= TabRes['SIZZ'][indx_init-n]-TabRes['SIXX'][indx_init-n]
#                 if abs(q-q2)>1.e-3*abs(q):
#                    break

              if info_dbg:
                  print '   + P    =%.6e   Q[-1] =%.6e   Q[-2] =%.6e   Q[-3] =%.6e\n'\
                  %(p,q,q2,q3,)

              vari,nvari =[],0
              for n in range(60):
                if TabRes.has_key('V%d' %(n+1)):
                   vari.append(TabRes['V%d' %(n+1)][indx_init])
                   nvari +=1
                else:
                   break

              if info_dbg:
                print\
         '\n   <<<< BOUCLE SUR LES CYCLES TRIA_ND_C_F A EPSILON IMPOSE >>>>\n'

              indx_max,inst_max,=indx_init,inst_init,

              TabResm={'INST':[], 'SIXX':[], 'SIYY':[], 'SIZZ':[],\
                       'EPXX':[], 'EPYY':[], 'EPZZ':[],}
                       
              # ------------------------------------------
              # Modif 27/04/2017:
              # Ajout des composantes supplementaires
              # ATTTTENNTIONN: il faut encore gerer le fait que la compsante
              # supplementaire n'est pas dans la liste du dessus
              # ------------------------------------------
              list_key__=[]
              if List_Resu_Supp:
                 for lr in List_Resu_Supp:
                   if TabRes.has_key(lr) and (not (lr in TabResm.keys())):
                      list_key__.append(lr)
                      TabResm[lr] = []
              
              # --------------------------------------------
              #
              #        Boucle sur les gamma imposees
              #
              # --------------------------------------------
              #
              #  Pour savoir dans quel sens on doit charger
              #  on applique un petit chargement en compression
              #  depuis l'instant de reprise:
              #
              #  * si le delta_Q est dans le meme sens
              #    que celui calcule, on doit continuer a charger
              #    (nbc0=1)
              #
              #  * sinon on doit continuer a decharger (nbc0=0)
              #
              # ----------------------------------
              #
              # * epsi_max : deformation maximale imposee
              #              dans l'essai monotone
              #epsi_max   = 0.05
              epsi_max   = 0.04
              # ----------------------------------

              if info_dbg:
                print\
         '\n   <<<< DETERMINATION DE LA DIRECTION DE CHARGEMENT >>>>\n'
              
              __EVOLM,calc_ok_mono,=\
                 essai_TRIA_ND_C_D_mono(self, inst_max, sigm, epsi,
                 vari, DicoEssai, -sig0, MATER, COMPORTEMENT, CONVERGENCE,
                 INFO, nombre=1, inst_epsi=20., epsi_max=-1.e-6)

              __TabResm = __EVOLM.EXTR_TABLE().values()

              qcalc1=__TabResm['SIZZ'][-1] - __TabResm['SIXX'][-1]
              qcalc2=__TabResm['SIZZ'][-2] - __TabResm['SIXX'][-2]

              DETRUIRE(CONCEPT=_F(NOM=(__EVOLM)), INFO=1)
              
              if info_dbg:
                print '\n   + Q_ESSAI[-1]               = %e' %(qcalc1)
                print '   + Q_ESSAI[-2]               = %e' %(qcalc2)
                print '   + Q_ESSAI[-1] - Q_ESSAI[-2] = %e' %(qcalc1-qcalc2)
                print '   + Q0                        = %e' %(q0)
                print '   + DSIG (conv. aster)        = %e' %(dsig)
                print '   + Q_CALC[-1]                = %e' %(q)
                print '   + Q_CALC[-2]                = %e' %(q2)
                print '   + Q_CALC[-3]                = %e' %(q3)
                print '   + Q_CALC[-1] - Q_CALC[-2]   = %e' %(q-q2)
                
              # ==================================================================
              # On dertmine le sens du chargement:
              # nbc0 = | 1  :  Si on charge dans le meme sens
              #        | 0  :  Si on charge dans le sens oppose
              if NP.sign(qcalc1-qcalc2) == NP.sign(q-.5*q2-.5*q3):
              # dq_calcule est dans le meme sens que dq_previous
              
                nbc0=1
                
                if info_dbg:
                  print '\n   @ DQ_ESSAI et DQ_CALC SONT DANS LE MEME SENS => NBC0=%d' %(nbc0)
                        
              else:
              # dq_calcule est dans le sens oppose a dq_previous
                nbc0=0
                
                if info_dbg:
                  print '\n   @ DQ_ESSAI et DQ_CALC SONT EN SENS OPPOSE => NBC0=%d' %(nbc0)
              
              print '     SIGNE(Q_ESSAI[-1]-Q_ESSAI[-2]) ='+\
                    ' SIGNE(2*Q_CALC[-1]-Q_CALC[-2]-Q_CALC[-3]) = %.0f' %(NP.sign(q-.5*q2-.5*q3))

              # ==================================================================
              # On dertmine une modification du sens du chargement en fonction
              # d'autres criteres:
              # nbc0 += | 0  :  Si on charge dans le meme sens que precedemment
              #         | 1  :  Si on charge dans le sens oppose
              if abs(qcalc1-q0)>abs(dsig):
              # la consigne -dsig est depassee:
              # Normalement, etant donne que le controle est en force,
              # ce cas ne se produit jamais
                nbc0+=1
                
                if info_dbg:
                  print '   @ CONSIGNE DEPASSEE :: CHARGEMENT INVERSE ::' +\
                        ' | Q_ESSAI[-1] - Q0 | = %e > | DSIG | = %e'\
                       %(abs(qcalc1-q0), abs(dsig))
                
              elif abs(q-q2) < 1.e-4*abs(q):
              # le trajet s'est arrete sur un plateau
                #nbc0+=0
                
                if info_dbg:
                  print '   @ PLATEAU :: CHARGEMENT COLINEAIRE ::' +\
                        ' Q_CALC[-1] - Q_CALC[-2] = %e < 1e-4*Q_CALC = %e'\
                       %(q-q2, 1.e-4*abs(q))
#               else:
#                 nbc0=0
#                 
#                 if info_dbg:
#                   print '\n  @ DECHARGE (NBC=0)'
                
              if info_dbg:
                  print '\n   * NBC0              =%d' %(nbc0)

              coef_gamma      =4.
              NB_CYCLE_EPSILON=2*(NB_CYCLE-numcyc)
              
              # ---------------------------------------------------------
              #
              # DEBUT BOUCLE SUR LES CYCLES DE DEFORMATION IMPOSEE
              #
              # ---------------------------------------------------------
              # Modif 27/04/2017:
              # Pour optimiser le calcul, on se contente de faire SEULEMENT
              # 2 CYCLES EN DEFORMATION IMPOSEE (normalement, c'est celle
              # qui franchit la ligne d'instabilite). On termine ensuite
              # normalement l'essai en contrainte imposee
              # Author: Marc Kham
              #NB_CYCLE_EPSILON =2
              #
              rubool = [False]*nbcrit
              
              for nbc in range(NB_CYCLE_EPSILON):
                
                gamma =epsi_max*(-1.)**(nbc+nbc0)

                if info_dbg:
                  print '\n   <<<< 1/2-CYCLE EN DEF. IMPOSEE NUMERO NBC+1=%d SUR %d >>>>\n'\
                         %(nbc+1,NB_CYCLE_EPSILON)
                  print '   * GAMMA_MAX =%e' %(gamma)
                  
                  print '   * NB PAS    =%d' %(nb_redec1)

                __EVOLM,calc_ok_mono,=\
                 essai_TRIA_ND_C_D_mono(self, inst_max, sigm, epsi,
                 vari, DicoEssai, -sig0, MATER, COMPORTEMENT, CONVERGENCE,
                 INFO, nombre=nb_redec1, inst_epsi=20., epsi_max=gamma)

                __TabResm = __EVOLM.EXTR_TABLE().values()

                q =__TabResm['SIZZ'][-1] - __TabResm['SIXX'][-1]

                DETRUIRE(CONCEPT=_F(NOM=(__EVOLM)), INFO=1)

                if abs(q-q0) < abs(.95*dsig):

                   if info_dbg:
                      print '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                      print '   !                                                   !'
                      print '   !            NB REDECOUPAGE INITIAL %4d            !' %(nb_redec1)
                      print '   !         A GAMMA_MAX = %.4e INSUFFISANT      !' %(abs(gamma))
                      print '   !                                                   !'
                      print '   !     AUGMENTATION GAMMA_MAX = %.4e           !' %(coef_gamma*abs(gamma))
                      print '   !     NB PAS DE REDECOUPAGE  = %4d                 !' %(nb_redec2)
                      print '   !                                                   !'
                      print '   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

                   __EVOLM,calc_ok_mono,=\
                   essai_TRIA_ND_C_D_mono(self, inst_max, sigm, epsi,
                   vari, DicoEssai, -sig0, MATER, COMPORTEMENT, CONVERGENCE,
                   INFO, nombre=nb_redec2, inst_epsi=20., epsi_max=coef_gamma*gamma)

                   __TabResm = __EVOLM.EXTR_TABLE().values()

                   DETRUIRE(CONCEPT=_F(NOM=(__EVOLM,)), INFO=1)

                # ========================================================
                #
                # 3- DETECTION DU DEPASSEMENT DE LA CONTRAINTE MAXIMALE
                #    APPLIQUEE
                #
                # ========================================================
                # L'instant initial contenu dans __TabResm['INST']
                # est tjs egal a 0. (ceci est anormal)
                # On sustitue ici la bonne valeur
                # ---------------------------------------------------------
                inst  = [inst_max,]+__TabResm['INST'][1:]

                q =NP.array(__TabResm['SIZZ']) - NP.array(__TabResm['SIXX'])
                p =(NP.array(__TabResm['SIZZ'])+2*NP.array(__TabResm['SIXX'])) /3.
                
                # -----------------------------------------------
                # on recherche le point qui se rapproche le plus
                # de la consigne dsig, ie minimisant dq-dsig
                # -----------------------------------------------
                for nlon in range(1,8):
                
                   lon  =int(len(q)/2.**nlon)
                   #dq   =list(NP.abs( q-q0-(-1.)**(nbc+nbc0)*abs(dsig) ))
                   dq   =list(NP.abs( q-q0-NP.sign(q[-1]-q0)*abs(dsig) ))
                   dqmax=min(dq[lon:])
                   if abs(dqmax/dsig)<.01:
                      break
                      
                if info_dbg:
                    print '\n     + nbc+nbc0           =%d' %(nbc+nbc0)
                    print '     + LON                =%d' %(nlon)
                    print '     + DSIG (conv. aster) =%e' %(dsig)
                    print '     + GAMMA              =%e' %(gamma)
                    print '     + QMAX               =%e' %(q[-1]-q0)
                    print '     + DQMAX              =%e' %(dqmax)
                   
                indx_max=dq.index(dqmax)
                inst_max=inst[indx_max]
                # -------------------Fin recherche-----------------------
                
                for n in range(3):
                  sigm[n]=__TabResm['SI%s' %(comp[n])][indx_max]
                  epsi[n]=__TabResm['EP%s' %(comp[n])][indx_max]

                  if info_dbg:
                    print '\n   * EP%s =%e   SI%s =%e' %(comp[n],epsi[n],comp[n],sigm[n])

                for n in range(50):
                  vari[n]=__TabResm['V%d' %(n+1)][indx_max]

                  if info_dbg:
                    print '   * V%d  =%e' %(n,vari[n])
                
                if info_dbg:
                    print '\n   * INDEX MAX SIGMA=%d' %(indx_max)
                    print '   * INST MAX SIGMA =%f' %(inst_max)
                    print '   * MAX P          =%e  Q =%e' %(p[indx_max],q[indx_max])
                    print '   * DELTA T        =%f' %(inst[-1]-inst[-2])
                    print '   * INST FINAL     =%f' %(inst[-1])
                
#                 # On recupere la boucle precedente
#                 try:
#                    epszzm = TabResm['EPZZ'][-nf:]
#                 except:
#                    epszzm = TabResm['EPZZ'][-50:]
                
                nf=1000
                if nbc<NB_CYCLE_EPSILON:
                  nf =indx_max

                TabResm['INST']+=__TabResm['INST'][1:nf]
                TabResm['SIXX']+=__TabResm['SIXX'][1:nf]
                TabResm['SIYY']+=__TabResm['SIYY'][1:nf]
                TabResm['SIZZ']+=__TabResm['SIZZ'][1:nf]
                TabResm['EPXX']+=__TabResm['EPXX'][1:nf]
                TabResm['EPYY']+=__TabResm['EPYY'][1:nf]
                TabResm['EPZZ']+=__TabResm['EPZZ'][1:nf]
                
                # Ajout des composantes supplementaires
                # ------------------------------------------
                for c in list_key__:
                   TabResm[c]+=__TabResm[c][1:nf]
               
                if info_dbg:
                   print '\n   * Tabresm key=',TabResm.keys()
                   for v in TabResm:
                      print '       + LEN Tsbresm[%s][%d] = %d' %(v,i,len(TabResm[v]))

# ---------------------------------------------------------
# Modif 27/04/2017:
# Pour optimiser le calcul, on s'arrete des qu'on atteint le
# critere de liquefaction renseigne par l'utilisateur
#
# Author: Marc Kham
# ---------------------------------------------------------
                eps_zz = NP.array(__TabResm['EPZZ'][1:nf])
                
                for jcrit,crit in enumerate(DicoEssai['CRIT_LIQUEFACTION']):
                
                   if crit=="RU_MAX":
              
                      eps_xx = NP.array(__TabResm['EPXX'][1:nf])
                      eps_yy = NP.array(__TabResm['EPYY'][1:nf])
              
                      eps_vol      = eps_xx + eps_yy + eps_zz
                      pre_eau      = -1. * coef_eau * eps_vol
                      ru           = pre_eau * 3./(1.+2.*KZERO) / sig0
                      rubool__     = ru >= vale_crit[crit]
                      
                      if not rubool[jcrit]:
                      
                         rubool[jcrit] = rubool__.any()
              
                         if info_dbg and rubool[jcrit]:
                            print\
          '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+\
          '\n   !!!                                               !!!'+\
          '\n   !!!       CRITERE DE LIQUEFACTION RU > %.2f       !!!' \
          %(vale_crit[crit])+\
          '\n   !!!      ATTEINT AU CYCLE NUMERO %3d SUR %3d      !!!' \
          %(M.ceil((nbc+1.)/2.)+numcyc,NB_CYCLE_EPSILON,)+\
          '\n   !!!                                               !!!'+\
          '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                    
                   if crit=="EPSI_ABSO_MAX":
              
                      if vale_crit[crit]>0.:
                      
                         rubool__     = eps_zz <= -vale_crit[crit]
                         
                         if not rubool[jcrit]:
                         
                            rubool[jcrit]= rubool__.any()
                         
                            if info_dbg and rubool[jcrit]:
                               print\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!     CRITERE DE LIQUEFACTION EPS_ABS_COMPR > %.2e     !!!' \
         %(vale_crit[crit])+\
         '\n   !!!           ATTEINT AU CYCLE NUMERO %3d SUR %3d             !!!' \
         %(M.ceil((nbc+1.)/2.)+numcyc,NB_CYCLE_EPSILON,)+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
         
                      else:
                         rubool__ = eps_zz >= -vale_crit[crit]
                         
                         if not rubool[jcrit]:
                         
                            rubool[jcrit]= rubool__.any()
                         
                            if info_dbg and rubool[jcrit]:
                               print\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!     CRITERE DE LIQUEFACTION EPS_ABS_DILAT < %.2e     !!!' \
         %(vale_crit[crit])+\
         '\n   !!!           ATTEINT AU CYCLE NUMERO %3d SUR %3d             !!!' \
         %(M.ceil((nbc+1.)/2.)+numcyc,NB_CYCLE_EPSILON,)+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                    
                   if crit=="EPSI_RELA_MAX":
                      
#                       # On ajoute pour l'evaluation des criteres la
#                       # partie du cycle precedent se prolongeant dans
#                       # le cylce courant
#                       sign0  = NP.sign(eps_zz[1]-eps_zz[0])
#                       depszzm= NP.array(epszzm[1:])-NP.array(epszzm[:-1])
#                       sign   = depszzm == sign0
#                       
#                       try:
#                          indepsm= list(sign).index(True)
#                          epszz__= epszzm[indepsm:]+list(eps_zz)
#                          print 'extension de epsilon'
#                          for ee in epszzm[indepsm:]:
#                             print ee
#                       except:
#                          epszz__= list(eps_zz)
              
                      if not rubool[jcrit]:
                      
                         rubool[jcrit] = eps_zz.max()-eps_zz.min()\
                             >= vale_crit[crit]
                         
                         if info_dbg and rubool[jcrit]:
                            print\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!   CRITERE DE LIQUEFACTION EPS_MAX - EPS_MIN > %.2e   !!!' \
         %(vale_crit[crit])+\
         '\n   !!!           ATTEINT AU CYCLE NUMERO %3d SUR %3d             !!!' \
         %(M.ceil((nbc+1.)/2.)+numcyc,NB_CYCLE_EPSILON,)+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
         
                # La liquefaction est atteinte quand tous les criteres
                # sont actifs
                # ------------------------------------------------------
                if not any([not rubool[jcr] for jcr in range(nbcrit)])\
                   and arret:
                   break
              # ---------------------------------------------------------
              #
              # FIN BOUCLE SUR LES CYCLES DE DEFORMATION IMPOSEE
              #
              # ---------------------------------------------------------
            if info_dbg:
               print\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!        FIN DU CALCUL ET DEBUT DES POST-TRAITEMENTS        !!!'+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
#
#      Debut des post-traitements
# ---------------------------------
            #if indx_init>0 or (not calc_ok):
            if indx_init>0:

              calc_ok=calc_ok_mono

              inst = TabRes['INST'][:indx_init+1]+TabResm['INST']
              sig_xx = NP.array(TabRes['SIXX'][:indx_init+1]+TabResm['SIXX'])
              sig_yy = NP.array(TabRes['SIYY'][:indx_init+1]+TabResm['SIYY'])
              sig_zz = NP.array(TabRes['SIZZ'][:indx_init+1]+TabResm['SIZZ'])
              eps_xx = NP.array(TabRes['EPXX'][:indx_init+1]+TabResm['EPXX'])
              eps_yy = NP.array(TabRes['EPYY'][:indx_init+1]+TabResm['EPYY'])
              eps_zz = NP.array(TabRes['EPZZ'][:indx_init+1]+TabResm['EPZZ'])
              
              # Recuperation des comosantes supplementaires
              # dans le dictionnaire Vari_Supp
              # ------------------------------------------
              #for c in list_key:
              if List_Resu_Supp:
                for lr in List_Resu_Supp:
                  if TabResm.has_key(lr):
                    Vari_Supp[lr][i] = TabRes[lr][:indx_init+1]+TabResm[lr]
            else:

              inst = TabRes['INST']
              sig_xx = NP.array(TabRes['SIXX'])
              sig_yy = NP.array(TabRes['SIYY'])
              sig_zz = NP.array(TabRes['SIZZ'])
              eps_xx = NP.array(TabRes['EPXX'])
              eps_yy = NP.array(TabRes['EPYY'])
              eps_zz = NP.array(TabRes['EPZZ'])

              # Recuperation des comosantes supplementaires
              # dans le dictionnaire Vari_Supp
              # ------------------------------------------
              if List_Resu_Supp:
                 for lr in List_Resu_Supp:
                   if TabRes.has_key(lr):
                      Vari_Supp[lr][i] = TabRes[lr]
                 
            if info_dbg:
              print '\n>> INST FINAL = %f\n' %(inst[-1])
              print '   + LEN(%s[%d])    = %d (REFERENCE)' %('INST',i,len(inst))
              print '   + LEN(%s[%d])    = %d (REFERENCE)' %('SIXX',i,len(sig_xx))
              print '   + LEN(%s[%d])    = %d (REFERENCE)' %('SIYY',i,len(sig_yy))
              print '   + LEN(%s[%d])    = %d (REFERENCE)' %('SIZZ',i,len(sig_zz))
              print '   + LEN(%s[%d])    = %d (REFERENCE)' %('EPXX',i,len(eps_xx))
              print '   + LEN(%s[%d])    = %d (REFERENCE)' %('EPYY',i,len(eps_yy))
              print '   + LEN(%s[%d])    = %d (REFERENCE)' %('EPZZ',i,len(eps_zz))
              print '   + KEY(Vari_Supp) =',Vari_Supp.keys()
              
              for v in Vari_Supp:
                 print '     - LEN[%s[%d]] = %d (Vari_Supp)'\
                       %(v,i,len(Vari_Supp[v][i]))
            
# --- Fin modifs fiche 23451
# =================================================================================

            p       = (sig_xx + sig_yy + sig_zz) / 3.
            q       = sig_zz - sig_xx
            eps_vol = eps_xx + eps_yy + eps_zz
            pre_eau = -1. * coef_eau * eps_vol
            # ---sig0<0
            ru      = pre_eau * 3./(1.+2.*KZERO) / sig0

            # le critere de liquefaction est-il atteint?
            # --------------------------------------------------
            rubool   = [None]*nbcrit
            indcrit__= [None]*nbcrit
            
            for jcr,cr in enumerate(DicoEssai['CRIT_LIQUEFACTION']):
                
               if cr=="RU_MAX":
                  
                  rubool__   = ru >= vale_crit[cr]
                  rubool[jcr]= rubool__.any()
                  try:
                     indcrit__[jcr] = list(rubool__).index(True)
                  except:
                     indcrit__[jcr] = 0
                     
                  if rubool[jcr]:
                     print\
          '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+\
          '\n   !!!                                               !!!'+\
          '\n   !!!       CRITERE DE LIQUEFACTION RU > %.2f       !!!' \
          %(vale_crit[cr])+\
          '\n   !!!       ATTEINT A L INSTANT %.3e        !!!' \
          %(inst[indcrit__[jcr]])+\
          '\n   !!!                                               !!!'+\
          '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                  
               if cr=="EPSI_ABSO_MAX":
              
                  if vale_crit[cr]>0.:
                     rubool__ = eps_zz <= -vale_crit[cr]
                  else:
                     rubool__ = eps_zz >= -vale_crit[cr]
                  
                  rubool[jcr]= rubool__.any()
                  try:
                     indcrit__[jcr] = list(rubool__).index(True)
                  except:
                     indcrit__[jcr] = 0

                  if rubool[jcr]:
                  
                     if vale_crit[cr] >0.:
                        print\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!     CRITERE DE LIQUEFACTION EPS_ABS_COMPR > %.2e     !!!' \
         %(vale_crit[cr])+\
          '\n   !!!       ATTEINT A L INSTANT %.3e      !!!' \
          %(inst[indcrit__[jcr]])+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

                     else:
                        print\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!     CRITERE DE LIQUEFACTION EPS_ABS_DILAT < %.2e     !!!' \
         %(vale_crit[cr])+\
          '\n   !!!       ATTEINT A L INSTANT %.3e      !!!' \
          %(inst[indcrit__[jcr]])+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                     
               if cr=="EPSI_RELA_MAX":
               #
               # On cherche les extrema locaux aux instants ou les derivees
               # de epzz changent de signe. On stocke les extrema locaux
               # dans epzz_peak. Comme le chargement est alterne, les extrema
               # sont normalement alternes (min-max). On calcule les increments
               # de epzz_peak pas a pas dans depzzm. On teste enfin si une valeur
               # de depzzm depasse le critere relatif. On recupere dans indcrit__
               # l'indice ou le critere est depasse.
               #
                  depzzm    = NP.array(eps_zz[1:])-NP.array(eps_zz[:-1])
                  sign      = depzzm >= 0.
                  sign0     = sign[0]
                  epzz_peak = []
                  ind_peak  = []
                  
                  for js,s in enumerate(sign):
                     if s != sign0:
                       epzz_peak.append(eps_zz[js+1])
                       ind_peak.append(js+1)
                       sign0 = s

                  epzz_peak.append(eps_zz[-1])
                  ind_peak.append(len(eps_zz)-1)
                  depzzm = NP.array(epzz_peak[1:])-NP.array(epzz_peak[:-1])
                  
#                   print ' epzz_peak:'
#                   for pp in epzz_peak:
#                     print pp
#                     
#                   print ' d_epzz_peak, instant_peak'
#                   for jj,pp in enumerate(depzzm):
#                     print pp,inst[ind_peak[jj]]

                  rubool__    = NP.abs(depzzm) >= vale_crit[cr]
                  rubool[jcr] = rubool__.any()
                  try:
                     indcrit__[jcr] = ind_peak[ list(rubool__).index(True)+1 ]
                  except:
                     indcrit__[jcr] = 0
                     
                  if rubool[jcr]:
                     print\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!   CRITERE DE LIQUEFACTION EPS_MAX - EPS_MIN > %.2e    !!!' \
         %(vale_crit[cr])+\
         '\n   !!!            ATTEINT A L INSTANT %.3e               !!!'
 #         %(inst[indcrit__[jcr]])+\
#          '\n   !!!                                                           !!!'+\
#          '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

            # La liquefaction est atteinte quand tous les criteres
            # sont actifs
            # ------------------------------------------------------
            crit = not any([not r for r in rubool])
            
            if info_dbg:
              print '\n   * rubool  = ',rubool
              print '   * indcrit = ',indcrit__

            # codret = | '0' : CALC_POINT_MAT va jusqu'au bout et
            #          |       critere de liquefaction atteint
            #          |
            #          | '1' : CALC_POINT_MAT va jusqu'au bout et
            #          |       critere de liquefaction non atteint
            #          |
            #          | '2' : CALC_POINT_MAT s'arrete en NonConvergenceError
            #          |       et critere de liquefaction atteint
            #          |
            #          | '3' : CALC_POINT_MAT s'arrete en NonConvergenceError
            #          |       et critere de liquefaction non atteint
            # --------------------------------------------------
            if calc_ok and crit:
                codret = '0'
                
            elif calc_ok and (not crit):
                codret = '1'
                
            elif (not calc_ok) and crit:
                codret = '2'
                
            elif (not calc_ok) and (not crit):
                codret = '3'

            # SI CRITERE ATTEINT -> MAJ des listes pour "NCYCL-DSIGM"
            # --------------------------------------------------------
            ncycrit = 0
            if crit:
            
                # renvoie l'indice ou le critere liquefaction = True
                # --------------------------------------------------------------
                indcrit = max(indcrit__)
                
                # 2 cas:
                # -----
                # 1) ru > ru_max pendant les cycles de contrainte imposee
                #    (inst[indcrit] <= inst_init)
                #
                # 2) ru > ru_max pendant les cycles de deformation imposee
                # --------------------------------------------------------
                ncycrit           = M.ceil(inst[indcrit]/40.)
                n_cyc_table[i][j] = ncycrit
                
                if rubool[jcr]:
                   print\
         '   !!!            AU CYCLE NO.%2d                                 !!!'\
         %(ncycrit)+\
         '\n   !!!                                                           !!!'+\
         '\n   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                
                # Remarque de M. Jacquet: CRR = dq/2/p0
                Resu_Essai['DSIGM'][i].append(abs(dsig*3./(1.+2.*KZERO)/sig0))
                Resu_Essai['NCYCL'][i].append(ncycrit)

            # si CALC_POINT_MAT s'est arrete en NonConvergenceError
            # -> recup du numero de cycle d'arret du calcul
            # --------------------------------------------------
            ncyerro = 0
            if not calc_ok:
               if not inst_init:
                   ncyerro = M.ceil(inst[-1]/40.)
                   
               elif inst[-1] <= inst_init:
                   ncyerro = M.ceil(inst[-1]/40.)
                   
               else:
                   ncyerro = M.ceil((nbc+1.)/2.)+numcyc
            
            # Sauvegarde des resultats par defaut
            # ------------------------------------------------------
            Resu_Essai['EPS_AXI'][i].append(list(-eps_zz))
            Resu_Essai['EPS_LAT'][i].append(list(-eps_xx))
            Resu_Essai['SIG_AXI'][i].append(list(-sig_zz))
            Resu_Essai['SIG_LAT'][i].append(list(-sig_xx))
            Resu_Essai['EPS_VOL'][i].append(list(-eps_vol))
            Resu_Essai['INST'][i].append(inst)
            Resu_Essai['P'][i].append(list(-p))
            Resu_Essai['Q'][i].append(list(-q))
            Resu_Essai['PRE_EAU'][i].append(list(pre_eau))
            Resu_Essai['RU'][i].append(list(ru))
            
            # Recuperation des composantes supplementaires
            # existantes dans le resultat
            # --------------------------------------------------------
            if List_Resu_Supp:
               try:
                 # Cas ou list_key existe deja (i>0)
                 # list_key contient les composantes
                 # EXISTANTES dans le resultat
                 # (list_key pas necessairement egal a List_Resu_Supp)
                 for lr in list_key:
                    Resu_Essai[lr][i].append(Vari_Supp[lr][i])
               
               except:
                 # Cas ou list_key n existe pas (i=0)
                 list_key=[]
                 for lr in List_Resu_Supp:
                   if TabRes.has_key(lr):
                      list_key.append(lr)
                      Resu_Essai[lr][i].append(Vari_Supp[lr][i])
                  
               if not i:
                 Resu_Essai['LIST_CMP'] =TabRes.keys()

            # NIVEAU 2: remplissage des graphiques
            # --------------------------------------------------
            str_leg2 = "SIGM_IMPO=" + str("%.2E" %(-dsig))
                                      
            list_x=[list(-p),list(-sig_zz),list(-eps_zz),\
                    list(-sig_zz),list(-eps_zz),list(-eps_zz),]
                    
            list_y=[list(-q),list(pre_eau),list(pre_eau),\
                    list(ru),list(ru),list(-q),]
                    
            list_title=["P-Q","SIG_AXI-PRE_EAU","EPS_AXI-PRE_EAU",
                        "SIG_AXI-RU","EPS_AXI-RU","EPS_AXI-Q",]
        
            for g in DicoEssai['GRAPHIQUE']:
    
              if g in list_title:
          
                k = list_title.index(g)
            
                remplir_graphique(DicoEssai, Courbes_niv2, list_x[k],
                                  list_y[k], str_leg2, g,
                                  COULEUR_NIV2[j],
                                  MARQUEUR_NIV2[j],
                                  STYLE_NIV2[j],)
              else:
       
                li  = g.split('-')
          
                if len(li)!=2:
                   continue
                else:
                   cmpx,cmpy=li[0],li[1]
               
                if (cmpx in Resu_Essai['LIST_CMP']+cle) and \
                   (cmpy in Resu_Essai['LIST_CMP']+cle):
               
                   remplir_graphique(DicoEssai, Courbes_niv2, Resu_Essai[cmpx][i][j],
                                     Resu_Essai[cmpy][i][j], str_leg2, g,
                                     COULEUR_NIV2[j],
                                     MARQUEUR_NIV2[j],
                                     STYLE_NIV2[j],)
                
            # pour la gestion des alarmes
            # --------------------------------------------------
            if str_n_essai:
               affiche_alarm_TRIA_ND_C_F(str_n_essai, sig0, -dsig, codret, NB_CYCLE,\
                                ncycrit, ncyerro,)
            else:
               affiche_alarm_TRIA_ND_C_F('1', sig0, -dsig, codret, NB_CYCLE,\
                                ncycrit, ncyerro,)

            DETRUIRE(CONCEPT=_F(NOM=(__CHAR1, __CHAR2)), INFO=1)
   # ---
   # Fin boucle NIVEAU2 sur les amplitudes de variation SIGM_IMPOSE
   # ---
        str_leg1 = "PRES_CONF=" + str("%.3E" %(sig0))

        # NIVEAU 1: remplissage des graphiques
        # --------------------------------------------------
        if 'NCYCL-DSIGM' in DicoEssai['GRAPHIQUE']:
        
           remplir_graphique(DicoEssai, Courbes_niv1, Resu_Essai['NCYCL'][i],
                          Resu_Essai['DSIGM'][i], str_leg1, "NCYCL-DSIGM",
                          COULEUR_NIV1[i],
                          MARQUEUR_NIV1[i],
                          STYLE_NIV1[i],)

        # NIVEAU 2: impression des graphiques
        # --------------------------------------------------
        impr_graphique(self, DicoEssai, Courbes_niv2, NomsFich_niv2, Leg_x_niv2,
                       Leg_y_niv2, {}, {}, typessai+" - "+str_leg1,
                       graph=i*len(Courbes_niv2),)
# ---
# Fin boucle NIVEAU 1 sur les sur les pressions de confinement PRES_CONF
# ---

    # NIVEAU 1: impression des graphiques
    # --------------------------------------------------
    impr_graphique(self, DicoEssai, Courbes_niv1,
                   NomsFich_niv1, Leg_x_niv1, Leg_y_niv1, {}, {}, typessai,
                   graph=len(PRES_CONF)*len(Courbes_niv2),)
                   
    # remplissage des tables
    # --------------------------------------------------
    Resu_Essai['NCYCL'] = n_cyc_table
    Resu_Essai['DSIGM'] = [SIGM_IMPOSE]*len(PRES_CONF)
    
    if str_n_essai:
       remplir_tables(self, typessai, str_n_essai, DicoEssai, Resu_Essai)
    else:
       remplir_tables(self, typessai, '1', DicoEssai, Resu_Essai)

    DETRUIRE(CONCEPT=_F(NOM=(__RLIST, __DLIST),), INFO=1)

# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
#                ESSAI TRIAXIAL DRAINE CYCLIQUE ALTERNE                   #
#                A DEPLACEMENT CONTROLE  (TRIA_DR_C_D)                    #
# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
def essai_TRIA_DR_C_D(self, str_n_essai, DicoEssai,
                      MATER, COMPORTEMENT, CONVERGENCE, INFO):
    """
    Objet: Essai TRIAxial DRaine Cyclique alterne a Deplacement controle
          (TRIA_DR_C_D)
    """
    import numpy as NP
    import math as M
    from Accas import _F
    import aster
    from Utilitai.Utmess import UTMESS
    from Comportement import catalc
    
    typessai = "TRIA_DR_C_D"
    
    # Recuperation des commandes Aster
    # -----------------------------------------
    DEFI_FONCTION  = self.get_cmd('DEFI_FONCTION')
    SIMU_POINT_MAT = self.get_cmd('SIMU_POINT_MAT')
    DETRUIRE       = self.get_cmd('DETRUIRE')
    CREA_TABLE     = self.get_cmd('CREA_TABLE')
    IMPR_TABLE     = self.get_cmd('IMPR_TABLE')
    DEFI_LIST_INST = self.get_cmd('DEFI_LIST_INST')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')
    
    # Recuperation des parametres d'essais:
    # On definit le chargement en deformation par
    # EPSI_MAXI et EPSI_MINI imposes
    # -----------------------------------------
    PRES_CONF   = DicoEssai['PRES_CONF']
    # ---compression >0
    EPSI_MAXI   = DicoEssai['EPSI_MAXI']
    # ---extension <=0
    EPSI_MINI   = DicoEssai['EPSI_MINI']
    EPSI_ELAS   = DicoEssai['EPSI_ELAS']
    KZERO       = DicoEssai['KZERO']
    NB_CYCLE    = DicoEssai['NB_CYCLE']
    NB_INST     = DicoEssai['NB_INST']
    
    EPSI_IMPOSE = abs( NP.array(EPSI_MAXI)-NP.array(EPSI_MINI) )
    EPSI_IMPOSE = list(EPSI_IMPOSE)
    
    # Recuperation des options d'impression
    # -----------------------------------------
    if DicoEssai.has_key('COULEUR_NIV1'):
    
       COULEUR_NIV1= DicoEssai['COULEUR_NIV1']
       
       assert len(COULEUR_NIV1) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste COULEUR_NIV1" %(len(COULEUR_NIV1))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                        !!!\n"
       
    else:
       COULEUR_NIV1= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('MARQUEUR_NIV1'):
    
       MARQUEUR_NIV1= DicoEssai['MARQUEUR_NIV1']
       
       assert len(MARQUEUR_NIV1) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste MARQUEUR_NIV1" %(len(MARQUEUR_NIV1))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                         !!!\n"
    else:
       MARQUEUR_NIV1= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('STYLE_NIV1'):
    
       STYLE_NIV1= DicoEssai['STYLE_NIV1']
       
       assert len(MARQUEUR_NIV1) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste STYLE_NIV1" %(len(STYLE_NIV1))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                          !!!\n"
    else:
       STYLE_NIV1= [-1]*len(PRES_CONF)
       
    if DicoEssai.has_key('COULEUR_NIV2'):
    
       COULEUR_NIV2= DicoEssai['COULEUR_NIV2']
       
       assert len(COULEUR_NIV2) == len(EPSI_IMPOSE),\
       "\n   !!!   La longueur %2d de la liste COULEUR_NIV2" %(len(COULEUR_NIV2))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste EPSI_IMPOSE" %(len(EPSI_IMPOSE))+\
       "                      !!!\n"
       
    else:
       COULEUR_NIV2= [-1]*len(EPSI_IMPOSE)
    
    if DicoEssai.has_key('MARQUEUR_NIV2'):
    
       MARQUEUR_NIV2= DicoEssai['MARQUEUR_NIV2']
       
       assert len(MARQUEUR_NIV2) == len(EPSI_IMPOSE),\
       "\n   !!!   La longueur %2d de la liste MARQUEUR_NIV2" %(len(MARQUEUR_NIV2))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste EPSI_IMPOSE" %(len(EPSI_IMPOSE))+\
       "                         !!!\n"
    else:
       MARQUEUR_NIV2= [-1]*len(EPSI_IMPOSE)
    
    if DicoEssai.has_key('STYLE_NIV2'):
    
       STYLE_NIV2= DicoEssai['STYLE_NIV2']
       
       assert len(MARQUEUR_NIV2) == len(EPSI_IMPOSE),\
       "\n   !!!   La longueur %2d de la liste STYLE_NIV2" %(len(STYLE_NIV2))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste EPSI_IMPOSE" %(len(EPSI_IMPOSE))+\
       "                        !!!\n"
    else:
       STYLE_NIV2= [-1]*len(EPSI_IMPOSE)
    
    # Recuperation des variables supplementaires a imprimer
    # (si existantes) contenues sous le mot-cle 'NOM_CMP'
    # -----------------------------------------
    if DicoEssai.has_key('NOM_CMP'):
       List_Resu_Supp = list(DicoEssai['NOM_CMP'])
    else:
       List_Resu_Supp = None
       
    # Chargement lineaire par morceaux ou sinusoidal?
    # ------------------------------------------------
    sinusoidal = DicoEssai['TYPE_CHARGE'] == 'SINUSOIDAL'

    # recuperation du nombre de VI associe a la LdC
    # -----------------------------------------
    nom_lc = COMPORTEMENT.List_F()[0]['RELATION']
    num_lc, nb_vari, nbid = catalc.get_info(nom_lc)
    #num_lc, nb_vari = catalc.get_info(nom_lc)
    
    assert (type(nb_vari) is int) and nb_vari > 0

    # dict permettant la gestion des graphiques
    # -----------------------------------------
    Courbes_niv1  =dict()
    NomsFich_niv1 =dict()
    Leg_x_niv1    =dict()
    Leg_y_niv1    =dict()
    Ech_x_niv1    =dict()
    Ech_y_niv1    =dict()
    Courbes_niv2  =dict()
    NomsFich_niv2 =dict()
    Leg_x_niv2    =dict()
    Leg_y_niv2    =dict()
    
    # dict permettant la gestion des tables en sortie
    # Les composantes de NIVEAU 1 sont:
    # - E_SUR_EMAX
    # - DAMPING
    # ----------------------------------------------------
    Resu_Essai = {'LIST_CMP': []}
    
    cle = ['INST','EPS_AXI','EPS_LAT','EPS_VOL','SIG_AXI','SIG_LAT',
           'P','Q','E_SUR_EMAX','DAMPING',]
    if List_Resu_Supp:
    
       try:
          List_Resu_Supp.remove('INST')
       except:
          cle+= List_Resu_Supp
       else:
          cle+= List_Resu_Supp
    
    for c in cle:
       Resu_Essai[c] = [[] for i in range(len(PRES_CONF))]
       
    # Hors composantes de niveau 1
    # -----------------------------------------
    cle = ['INST','EPS_AXI','EPS_LAT','EPS_VOL','SIG_AXI','SIG_LAT',
           'P','Q',]

    # NIVEAU 1: preparation des graphiques
    # -----------------------------------------
    if str_n_essai:
       str_fich_niv1 = "%s_%s_" %(typessai,str_n_essai,)
    else:
       str_fich_niv1 = "%s_" %(typessai,)
    
    preparer_graphique('1', DicoEssai, str_fich_niv1, Courbes_niv1,
                       NomsFich_niv1, Leg_x_niv1, Leg_y_niv1, Ech_x_niv1, Ech_y_niv1)
    # ---
    # Creation de la liste d'instants (NB_INST = nombre d'instants par 1/4 de cycle )
    # ---
    __RLIST = DEFI_LIST_REEL(DEBUT=0.,
                             INTERVALLE=[_F(JUSQU_A=10., NOMBRE=NB_INST,),] +\
                                        [_F(JUSQU_A=10.*(2*k+1), NOMBRE=2*NB_INST,)
                                            for k in xrange(1, 2*NB_CYCLE+1)],
                             INFO=INFO)

    __DLIST = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__RLIST),
                             ECHEC=_F(SUBD_METHODE='MANUEL',
                                      SUBD_PAS    =2,
                                      SUBD_NIVEAU =10,),
                             INFO=INFO,)
# ---
# Boucle NIVEAU 1 sur les pressions de confinement PRES_CONF
# ---
    for i,sig0__ in enumerate(PRES_CONF):
    
        sig0 = -sig0__

        # ---
        # Calcul du module d'Young cyclique equivalent maximal (elasticite)
        # ---
        Es_max = Calc_Es_max(self, EPSI_ELAS, sig0, KZERO, MATER,\
                                COMPORTEMENT, CONVERGENCE)

        # NIVEAU 2: preparation des graphiques
        # ----------------------------------------
        str_fich_niv2 = str_fich_niv1 +\
                        "CONF" + int_2_str(i+1, len(PRES_CONF)) + "_"
            
        preparer_graphique('2', DicoEssai, str_fich_niv2, Courbes_niv2, NomsFich_niv2,
                           Leg_x_niv2, Leg_y_niv2, {}, {},)

   # ---
   # Boucle NIVEAU 2 sur les amplitudes de variation EPSI_MINI (en compression)
   # ---
        for j,eps0__ in enumerate(EPSI_MAXI):
        
            eps0 = -eps0__
            eps1 = -EPSI_MINI[j]
            
            if str_n_essai:
               affiche_infos_essai(str_n_essai, typessai, -sig0, -eps0, -eps1,)
            else:
               affiche_infos_essai('1', typessai, -sig0, -eps0, -eps1,)

            # ---
            # Definition des chargements
            # ---
            if sinusoidal:
   
               absc_peak= [10.*(2*k+1) for k in xrange(2*NB_CYCLE+1)]
               abscisse = [10.*k/3./NB_INST for k in xrange(3*NB_INST)]
   
               for inst_peak in absc_peak:
                  abscisse+= [inst_peak + 10.*kk/3./NB_INST for kk in xrange(6*NB_INST)]
   
               # absc_sinus varie de 0 a 2Pi par intervalles de 4*NB_INST=40s
               # (sinus varie de 0 a 1 a -1 a 0)
               # -------------------------------------------------------------
               absc_sinus = M.pi*NP.array(abscisse)/20.
               
               epsi_mean  = 0.5*(eps0+eps1)
               depsi      = 0.5*(eps0-eps1)
               
               ordonnee = list( NP.sin(absc_sinus[:3*NB_INST])*eps0 )
               ordonnee+= list( epsi_mean + NP.sin(absc_sinus[3*NB_INST:])*depsi )
   
            else:
               abscisse = [0.]+[10.*(2*k+1) for k in xrange(2*NB_CYCLE+1)]
               ordonnee = [0.]+[eps0,eps1]*NB_CYCLE + [eps0,]

            __CHAR1 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                    ABSCISSE=abscisse,
                                    ORDONNEE=ordonnee,)

            __CHAR2 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                    VALE=(0.                , KZERO*sig0,
                                          10.*(4*NB_CYCLE+1), KZERO*sig0,),)
            # ---
            # Calcul
            # ---
            try:
               __EVOL = SIMU_POINT_MAT(INFO=INFO,
            
                COMPORTEMENT=COMPORTEMENT.List_F(),
                
                CONVERGENCE=CONVERGENCE.List_F(),
                
                MATER=MATER,
                
                INCREMENT=_F(LIST_INST=__DLIST,
                             INST_INIT=0.,
                             INST_FIN =10.*(4*NB_CYCLE+1),),
                             
                NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
                
                ARCHIVAGE=_F(LIST_INST=__RLIST,),
                
                SIGM_IMPOSE=_F(SIXX=__CHAR2,
                               SIYY=__CHAR2,),
                               
                EPSI_IMPOSE=_F(EPZZ=__CHAR1,),
                
                SIGM_INIT=_F(SIXX=KZERO*sig0,
                             SIYY=KZERO*sig0,
                             SIZZ=sig0,),
                             
                EPSI_INIT=_F(EPXX=0.,
                             EPYY=0.,
                             EPZZ=0.,
                             EPXY=0.,
                             EPXZ=0.,
                             EPYZ=0.,),)

            except (aster.error,aster.onFatalError,), message:
   
               print '\n   !!!(@_@)!!! Arret pour la raison suivante !!!(@_@)!!!\n%s'\
                     %(message)
            
               __EVPOST = self.get_last_concept()
               TabRes   = __EVPOST.EXTR_TABLE().values()
               
               DETRUIRE(CONCEPT=_F(NOM=__EVPOST), INFO=1)

            else:
               TabRes = __EVOL.EXTR_TABLE().values()
               
               DETRUIRE(CONCEPT=_F(NOM=__EVOL), INFO=1)

            # post-traitements
            # ----------------------------------------
            inst   = TabRes['INST']
            sig_xx = NP.array(TabRes['SIXX'])
            sig_yy = NP.array(TabRes['SIYY'])
            sig_zz = NP.array(TabRes['SIZZ'])
            eps_xx = NP.array(TabRes['EPXX'])
            eps_yy = NP.array(TabRes['EPYY'])
            eps_zz = NP.array(TabRes['EPZZ'])
            
            p      = (sig_xx + sig_yy + sig_zz) / 3.
            q      = sig_zz - sig_xx
            eps_vol= eps_xx + eps_yy + eps_zz
            
            # ------------------------------------------------------
            #   ind1 -> indice au debut du dernier cycle
            #   ind2 -> indice a la moitie du dernier cycle
            #   ind3 -> indice a la fin du dernier cycle
            # ------------------------------------------------------
            ind1 = inst.index(10. * (2 * (2 * NB_CYCLE - 2) + 1))
            ind2 = inst.index(10. * (2 * (2 * NB_CYCLE - 1) + 1))
            ind3 = inst.index(10. * (2 * (2 * NB_CYCLE) + 1))

            # module d'Young cyclique equivalent normalise Es
            # S'agit-il d'un module d'Young? Peu importe...
            # ------------------------------------------------------
            Es = abs( (q[ind3]-q[ind2]) / (eps0-eps1) / Es_max)
            
            if not(Es <= 1. or abs(Es-1.) <= 1.e-8):
            
               UTMESS('F', 'COMPOR2_36',
                      valk=('TD_A', 'young', 'EPSI_ELAS'),
                      valr=(EPSI_ELAS),)
                      
            # Definition gde l'amortissement hysteretique generalisee:
            # Aire du grand triangle: energie elastique sur le 1/2 du cycle
            # Kokusho,
            # "cyclic triaxial test of dynamic soil properties for wide strain range"
            # Soil & Foundations, 1980
            # --------------------------------------------------------
            # D = dW/W:
            # Pour le calculer, on suppose l'eau incompressible:
            # => epsi_vol = 0  soit dW1 = dsig_vol*depsi_vol = 0
            # Donc dW = dW2 = (dsig_zz-dsig_xx) * (depsi_zz-dpesi_xx)
            # ------------------------------------------------------
            gamma = eps_zz-eps_xx
            
            # 1ere moitie de la boucle
            I = NP.sum(0.5 * (q[ind1:ind2] + q[ind1+1:ind2+1]) *\
                             (gamma[ind1+1:ind2+1] - gamma[ind1:ind2]))
            
            # 2eme moitie de la boucle
            J = NP.sum(0.5 * (q[ind2:ind3] + q[ind2+1:ind3+1]) *\
                             (gamma[ind2+1:ind3+1] - gamma[ind2:ind3]))
                
            delta_W = abs(I+J)
            
            # aire du triangle: energie elastique sur le 1/4 du cycle
            # ---------------------------------------------------------
            W = 0.5 * abs((q[ind3]-q[ind2])*(gamma[ind3]-gamma[ind2]))
            D = delta_W / M.pi/W
            
            # Sauvegarde des resultats par defaut
            # ------------------------------------------------------
            Resu_Essai['SIG_AXI'][i].append(list(-sig_zz))
            Resu_Essai['SIG_LAT'][i].append(list(-sig_xx))
            Resu_Essai['EPS_AXI'][i].append(list(-eps_zz))
            Resu_Essai['EPS_LAT'][i].append(list(-eps_xx))
            Resu_Essai['EPS_VOL'][i].append(list(-eps_vol))
            Resu_Essai['INST'][i].append(inst)
            Resu_Essai['P'][i].append(list(-p))
            Resu_Essai['Q'][i].append(list(q))
            Resu_Essai['E_SUR_EMAX'][i].append(Es)
            Resu_Essai['DAMPING'][i].append(D)
            
            # Recuperation des composantes supplementaires
            # existantes dans le resultat
            # --------------------------------------------------------
            if List_Resu_Supp:
               try:
                 # Cas ou list_key existe deja (i>0)
                 # list_key contient les composantes
                 # EXISTANTES dans le resultat
                 # (list_key pas necessairement egal a List_Resu_Supp)
                 for lr in list_key:
                    Resu_Essai[lr][i].append(TabRes[lr])
               
               except:
                 # Cas ou list_key n existe pas (i=0)
                 list_key=[]
                 for lr in List_Resu_Supp:
                   if TabRes.has_key(lr):
                      list_key.append(lr)
                      Resu_Essai[lr][i].append(TabRes[lr])
                  
               if not i:
                 Resu_Essai['LIST_CMP'] =TabRes.keys()

            # NIVEAU 2: remplissage des graphiques
            # ------------------------------------------------------
            str_leg2 = "EPSMAX=" + str("%.2E" %(-eps0)) +\
                      " EPSMIN=" + str("%.2E" %(-eps1))
                                      
            list_x=[list(-p),list(-eps_zz),list(-eps_zz),list(-eps_vol),list(-p),]
            list_y=[list(q),list(-eps_vol),list(q),list(q),list(-eps_vol),]
            list_title=["P-Q","EPS_AXI-EPS_VOL","EPS_AXI-Q",
                        "EPS_VOL-Q","P-EPS_VOL",]
        
            for g in DicoEssai['GRAPHIQUE']:
    
              if g in list_title:
          
                k = list_title.index(g)
            
                remplir_graphique(DicoEssai, Courbes_niv2, list_x[k],
                                  list_y[k], str_leg2, g,
                                  COULEUR_NIV2[j],
                                  MARQUEUR_NIV2[j],
                                  STYLE_NIV2[j],)
              else:
       
                li  = g.split('-')
          
                if len(li)!=2:
                   continue
                else:
                   cmpx,cmpy=li[0],li[1]
               
                if (cmpx in Resu_Essai['LIST_CMP']+cle) and \
                   (cmpy in Resu_Essai['LIST_CMP']+cle):

                   remplir_graphique(DicoEssai, Courbes_niv2, Resu_Essai[cmpx][i][j],
                                     Resu_Essai[cmpy][i][j], str_leg2, g,
                                     COULEUR_NIV2[j],
                                     MARQUEUR_NIV2[j],
                                     STYLE_NIV2[j],)

            DETRUIRE(CONCEPT=_F(NOM=(__CHAR1, __CHAR2,)), INFO=1)
    # ---
    # Fin boucle NIVEAU 2 sur les amplitudes de variation EPSI_IMPOSE
    # ---
        
        str_leg1 = "PRES_CONF = " + str("%.2E" %(-sig0))

        # NIVEAU 1: remplissage des graphiques
        # ------------------------------------------------------
        if 'DEPSI-E_SUR_EMAX' in DicoEssai['GRAPHIQUE']:
        
           depsi = list( NP.array(EPSI_MAXI) - NP.array(EPSI_MINI) )
        
           remplir_graphique(DicoEssai, Courbes_niv1, depsi,
                          Resu_Essai['E_SUR_EMAX'][i], str_leg1, "DEPSI-E_SUR_EMAX",
                          COULEUR_NIV1[i],
                          MARQUEUR_NIV1[i],
                          STYLE_NIV1[i],)
                          
        if 'DEPSI-DAMPING' in DicoEssai['GRAPHIQUE']:
        
           remplir_graphique(DicoEssai, Courbes_niv1, depsi,
                          Resu_Essai['DAMPING'][i], str_leg1, "DEPSI-DAMPING",
                          COULEUR_NIV1[i],
                          MARQUEUR_NIV1[i],
                          STYLE_NIV1[i],)

        # NIVEAU 2: impression des graphiques
        # ------------------------------------------------------
        impr_graphique(self, DicoEssai, Courbes_niv2, NomsFich_niv2, Leg_x_niv2,
                       Leg_y_niv2, {}, {}, typessai+" - "+str_leg1,
                       graph=i*len(Courbes_niv2),)
# ---
# Fin boucle NIVEAU 1 sur les sur les pressions de confinement PRES_CONF
# ---

    # NIVEAU 1: impression des graphiques
    # --------------------------------------------------------
    impr_graphique(self, DicoEssai, Courbes_niv1, NomsFich_niv1, Leg_x_niv1,
                   Leg_y_niv1, Ech_x_niv1, Ech_y_niv1, typessai,
                   graph=len(PRES_CONF)*len(Courbes_niv2),)
                   
    if str_n_essai:
       remplir_tables(self, typessai, str_n_essai, DicoEssai, Resu_Essai)
    else:
       remplir_tables(self, typessai, '1', DicoEssai, Resu_Essai)

    DETRUIRE(CONCEPT=_F(NOM=(__RLIST, __DLIST),), INFO=1)


# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
#              ESSAI TRIAXIAL NON DRAINE CYCLIQUE ALTERNE                 #
#                A DEPLACEMENT CONTROLE  (TRIA_ND_C_D)                    #
# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
def essai_TRIA_ND_C_D(self, str_n_essai, DicoEssai,
                      MATER, COMPORTEMENT, CONVERGENCE, INFO):
    """
    Objet: Essai TRIAxial Non Draine Cyclique alterne a Deplacement controle
          (TRIA_ND_C_D)
    """
    import numpy as NP
    import math as M
    from Accas import _F
    import aster
    from Utilitai.Utmess import UTMESS
    from Comportement import catalc
    
    typessai = "TRIA_ND_C_D"
    
    # Recuperation des commandes Aster
    # -----------------------------------------
    DEFI_FONCTION  = self.get_cmd('DEFI_FONCTION')
    SIMU_POINT_MAT = self.get_cmd('SIMU_POINT_MAT')
    DETRUIRE       = self.get_cmd('DETRUIRE')
    CREA_TABLE     = self.get_cmd('CREA_TABLE')
    IMPR_TABLE     = self.get_cmd('IMPR_TABLE')
    DEFI_LIST_INST = self.get_cmd('DEFI_LIST_INST')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')
    
    # Recuperation des parametres d'essais:
    # On definit le chargement en deformation par
    # EPSI_MAXI et EPSI_MINI imposes
    # -----------------------------------------
    PRES_CONF   = DicoEssai['PRES_CONF']
    EPSI_MAXI   = DicoEssai['EPSI_MAXI']
    EPSI_MINI   = DicoEssai['EPSI_MINI']
    EPSI_ELAS   = DicoEssai['EPSI_ELAS']
    BIOT_COEF   = DicoEssai['BIOT_COEF']
    UN_SUR_K    = DicoEssai['UN_SUR_K']
    KZERO       = DicoEssai['KZERO']
    NB_CYCLE    = DicoEssai['NB_CYCLE']
    NB_INST     = DicoEssai['NB_INST']
    RU_MAX      = DicoEssai['RU_MAX']
    K_EAU       = 1. / UN_SUR_K
    coef_eau    = K_EAU / BIOT_COEF
    
    EPSI_IMPOSE = abs( NP.array(EPSI_MAXI)-NP.array(EPSI_MINI) )
    EPSI_IMPOSE = list(EPSI_IMPOSE)
    
    # Recuperation des options d'impression
    # -----------------------------------------
    if DicoEssai.has_key('COULEUR_NIV1'):
    
       COULEUR_NIV1= DicoEssai['COULEUR_NIV1']
       
       assert len(COULEUR_NIV1) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste COULEUR_NIV1" %(len(COULEUR_NIV1))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                        !!!\n"
       
    else:
       COULEUR_NIV1= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('MARQUEUR_NIV1'):
    
       MARQUEUR_NIV1= DicoEssai['MARQUEUR_NIV1']
       
       assert len(MARQUEUR_NIV1) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste MARQUEUR_NIV1" %(len(MARQUEUR_NIV1))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                         !!!\n"
    else:
       MARQUEUR_NIV1= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('STYLE_NIV1'):
    
       STYLE_NIV1= DicoEssai['STYLE_NIV1']
       
       assert len(MARQUEUR_NIV1) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste STYLE_NIV1" %(len(STYLE_NIV1))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                          !!!\n"
    else:
       STYLE_NIV1= [-1]*len(PRES_CONF)
       
    if DicoEssai.has_key('COULEUR_NIV2'):
    
       COULEUR_NIV2= DicoEssai['COULEUR_NIV2']
       
       assert len(COULEUR_NIV2) == len(EPSI_IMPOSE),\
       "\n   !!!   La longueur %2d de la liste COULEUR_NIV2" %(len(COULEUR_NIV2))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste EPSI_IMPOSE" %(len(EPSI_IMPOSE))+\
       "                      !!!\n"
       
    else:
       COULEUR_NIV2= [-1]*len(EPSI_IMPOSE)
    
    if DicoEssai.has_key('MARQUEUR_NIV2'):
    
       MARQUEUR_NIV2= DicoEssai['MARQUEUR_NIV2']
       
       assert len(MARQUEUR_NIV2) == len(EPSI_IMPOSE),\
       "\n   !!!   La longueur %2d de la liste MARQUEUR_NIV2" %(len(MARQUEUR_NIV2))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste EPSI_IMPOSE" %(len(EPSI_IMPOSE))+\
       "                         !!!\n"
    else:
       MARQUEUR_NIV2= [-1]*len(EPSI_IMPOSE)
    
    if DicoEssai.has_key('STYLE_NIV2'):
    
       STYLE_NIV2= DicoEssai['STYLE_NIV2']
       
       assert len(MARQUEUR_NIV2) == len(EPSI_IMPOSE),\
       "\n   !!!   La longueur %2d de la liste STYLE_NIV2" %(len(STYLE_NIV2))+\
       " doit etre egale a   !!!" +\
       "\n   !!!   la longueur %2d de la liste EPSI_IMPOSE" %(len(EPSI_IMPOSE))+\
       "                        !!!\n"
    else:
       STYLE_NIV2= [-1]*len(EPSI_IMPOSE)
    
    # Recuperation des variables supplementaires a imprimer
    # (si existantes) contenues sous le mot-cle 'NOM_CMP'
    # -----------------------------------------
    if DicoEssai.has_key('NOM_CMP'):
       List_Resu_Supp = list(DicoEssai['NOM_CMP'])
    else:
       List_Resu_Supp = None
       
    # Chargement lineaire par morceaux ou sinusoidal?
    # ------------------------------------------------
    sinusoidal = DicoEssai['TYPE_CHARGE'] == 'SINUSOIDAL'

    # recuperation du nombre de VI associe a la LdC
    # -----------------------------------------
    nom_lc = COMPORTEMENT.List_F()[0]['RELATION']
    num_lc, nb_vari, nbid = catalc.get_info(nom_lc)
    #num_lc, nb_vari = catalc.get_info(nom_lc)
    
    assert type(nb_vari) is int and nb_vari > 0

    # dict permettant la gestion des graphiques
    # -----------------------------------------
    Courbes_niv1  =dict()
    NomsFich_niv1 =dict()
    Leg_x_niv1    =dict()
    Leg_y_niv1    =dict()
    Ech_x_niv1    =dict()
    Ech_y_niv1    =dict()
    Courbes_niv2  =dict()
    NomsFich_niv2 =dict()
    Leg_x_niv2    =dict()
    Leg_y_niv2    =dict()
    
    # dict permettant la gestion des tables en sortie
    # Les composantes de NIVEAU 1 sont:
    # - E_SUR_EMAX
    # ----------------------------------------------------
    Resu_Essai = {'LIST_CMP': []}
    
    cle = ['INST','EPS_AXI','EPS_LAT','EPS_VOL','SIG_AXI','SIG_LAT',
           'P','Q','PRE_EAU','RU','RU_MAX','NCYCL','DEPSI',
           'E_SUR_EMAX','DAMPING']
    if List_Resu_Supp:
    
       try:
          List_Resu_Supp.remove('INST')
       except:
          cle+= List_Resu_Supp
       else:
          cle+= List_Resu_Supp
    
    for c in cle:
       Resu_Essai[c] = [[] for k in xrange(len(PRES_CONF))]
       
    # Hors composantes de niveau 1:
    # 'RU_MAX','NCYCL','DEPSI','E_SUR_EMAX'
    # -----------------------------------------
    cle = ['INST','EPS_AXI','EPS_LAT','EPS_VOL','SIG_AXI','SIG_LAT',
           'P','Q','PRE_EAU','RU',]
           
    # !!!(@_@)!!! Attention: cette structure doit etre evitee:
    # !!!(@_@)!!! 
    # !!!(@_@)!!!     n_cyc_table = [[0.]*len(EPSI_IMPOSE)]*len(PRES_CONF)
    # !!!(@_@)!!! 
    # !!!(@_@)!!!     il faut creer les listes de niveau 2
    # !!!(@_@)!!!     au fur et a mesure
    n_cyc_table = []

    # NIVEAU 1: preparation des graphiques
    # -----------------------------------------
    if str_n_essai:
       str_fich_niv1 = "%s_%s_" %(typessai,str_n_essai,)
    else:
       str_fich_niv1 = "%s_" %(typessai,)
    
    preparer_graphique('1', DicoEssai, str_fich_niv1, Courbes_niv1,
                       NomsFich_niv1, Leg_x_niv1, Leg_y_niv1, Ech_x_niv1, Ech_y_niv1)
    # ---
    # Creation de la liste d'instants (NB_INST = nombre d'instants par 1/4 de cycle )
    # ---
    __RLIST = DEFI_LIST_REEL(DEBUT=0.,
                             INTERVALLE=[_F(JUSQU_A=10., NOMBRE=NB_INST,),] +\
                                        [_F(JUSQU_A=10.*(2*k+1), NOMBRE=2*NB_INST,)
                                            for k in xrange(1, 2*NB_CYCLE+1)],
                             INFO=INFO)

    __DLIST = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__RLIST),
                             ECHEC=_F(SUBD_METHODE='MANUEL',
                                      SUBD_PAS    =2,
                                      SUBD_NIVEAU =10,),
                             INFO=INFO,)
# ---
# Boucle NIVEAU 1 sur les pressions de confinement PRES_CONF
# ---
    for i,sig0__ in enumerate(PRES_CONF):
        
        sig0 = -sig0__
        
        n_cyc_table.append( [0.]*len(EPSI_IMPOSE) )

        # NIVEAU 2: preparation des graphiques
        # ----------------------------------------
        str_fich_niv2 = str_fich_niv1 +\
                        "CONF" + int_2_str(i+1, len(PRES_CONF)) + "_"
            
        preparer_graphique('2', DicoEssai, str_fich_niv2, Courbes_niv2, NomsFich_niv2,
                           Leg_x_niv2, Leg_y_niv2, {}, {},)
                           
        # ---
        # Calcul du module d'Young cyclique equivalent maximal (elasticite)
        # ---
        Es_max = Calc_Es_max(self, EPSI_ELAS, sig0, KZERO, MATER,\
                                COMPORTEMENT, CONVERGENCE)
   # ---
   # Boucle NIVEAU 2 sur les amplitudes de variation EPSI_MINI (en compression)
   # ---
        for j,eps0__ in enumerate(EPSI_MAXI):
            
            eps0 = -eps0__
            eps1 = -EPSI_MINI[j]
            
            if str_n_essai:
               affiche_infos_essai(str_n_essai, typessai, -sig0, -eps0, -eps1,)
            else:
               affiche_infos_essai('1', typessai, -sig0, -eps0, -eps1,)

            # ---
            # Definition des chargements
            # ---
            if sinusoidal:
   
               absc_peak= [10.*(2*k+1) for k in xrange(2*NB_CYCLE+1)]
               abscisse = [10.*k/3./NB_INST for k in xrange(3*NB_INST)]
   
               for inst_peak in absc_peak:
                  abscisse+= [inst_peak + 10.*kk/3./NB_INST for kk in xrange(6*NB_INST)]
   
               # absc_sinus varie de 0 a 2Pi par intervalles de 4*NB_INST=40s
               # (sinus varie de 0 a 1 a -1 a 0)
               # -------------------------------------------------------------
               absc_sinus = M.pi*NP.array(abscisse)/20.
               
               epsi_mean  = 0.5*(eps0+eps1)
               depsi      = 0.5*(eps0-eps1)
               
               ordonnee = list( NP.sin(absc_sinus[:3*NB_INST])*eps0 )
               ordonnee+= list( epsi_mean + NP.sin(absc_sinus[3*NB_INST:])*depsi )
   
            else:
               abscisse = [0.]+[10.*(2*k+1) for k in xrange(2*NB_CYCLE+1)]
               ordonnee = [0.]+[eps0,eps1]*NB_CYCLE + [eps0,]

            __CHAR1 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                    ABSCISSE=abscisse,
                                    ORDONNEE=ordonnee,)

            __CHAR2 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                    VALE=(0.                , KZERO*sig0,
                                          10.*(4*NB_CYCLE+1), KZERO*sig0,),)
            # ---
            # Calcul
            # ---
            try:
               __EVOL = SIMU_POINT_MAT(INFO=INFO,
            
                COMPORTEMENT=COMPORTEMENT.List_F(),
                
                CONVERGENCE=CONVERGENCE.List_F(),
                
                MATER=MATER,
                
                INCREMENT=_F(LIST_INST=__DLIST,
                             INST_INIT=0.,
                             INST_FIN =10.*(4*NB_CYCLE+1),),
                             
                NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
                
                ARCHIVAGE=_F(LIST_INST=__RLIST,),
                
                VECT_IMPO=(_F(NUME_LIGNE=1, VALE=__CHAR2),
                           _F(NUME_LIGNE=2, VALE=__CHAR2),
                           _F(NUME_LIGNE=3, VALE=__CHAR1),),
                           
                MATR_C1=(_F(NUME_LIGNE=1, NUME_COLONNE=1, VALE=1.),
                         _F(NUME_LIGNE=2, NUME_COLONNE=2, VALE=1.),),
                         
                MATR_C2=(_F(NUME_LIGNE=1, NUME_COLONNE=1, VALE=K_EAU),
                         _F(NUME_LIGNE=1, NUME_COLONNE=2, VALE=K_EAU),
                         _F(NUME_LIGNE=1, NUME_COLONNE=3, VALE=K_EAU),
                         _F(NUME_LIGNE=2, NUME_COLONNE=1, VALE=K_EAU),
                         _F(NUME_LIGNE=2, NUME_COLONNE=2, VALE=K_EAU),
                         _F(NUME_LIGNE=2, NUME_COLONNE=3, VALE=K_EAU),
                         _F(NUME_LIGNE=3, NUME_COLONNE=3, VALE=1.),),
                
                SIGM_INIT=_F(SIXX=KZERO*sig0,
                             SIYY=KZERO*sig0,
                             SIZZ=sig0,),
                             
                EPSI_INIT=_F(EPXX=0.,
                             EPYY=0.,
                             EPZZ=0.,
                             EPXY=0.,
                             EPXZ=0.,
                             EPYZ=0.,),)

            except ((aster.error,aster.onFatalError,),aster.onFatalError,), message:
   
               print '\n   !!!(@_@)!!! Arret pour la raison suivante !!!(@_@)!!!\n%s'\
                     %(message)
            
               __EVPOST = self.get_last_concept()
               TabRes   = __EVPOST.EXTR_TABLE().values()
               
               DETRUIRE(CONCEPT=_F(NOM=__EVPOST), INFO=1)

            else:
               TabRes = __EVOL.EXTR_TABLE().values()
               
               DETRUIRE(CONCEPT=_F(NOM=__EVOL), INFO=1)

            # post-traitements
            # ----------------------------------------
            inst   = TabRes['INST']
            sig_xx = NP.array(TabRes['SIXX'])
            sig_yy = NP.array(TabRes['SIYY'])
            sig_zz = NP.array(TabRes['SIZZ'])
            eps_xx = NP.array(TabRes['EPXX'])
            eps_yy = NP.array(TabRes['EPYY'])
            eps_zz = NP.array(TabRes['EPZZ'])
            
            # ------------------------------------------------------
            #
            #    CALCUL DU MODULE SECANT POUR LA COURBE E_SUR_EMAX-DEPSI
            #
            # ------------------------------------------------------
            #   ind1 -> indice au debut du dernier cycle
            #   ind2 -> indice a la moitie du dernier cycle
            #   ind3 -> indice a la fin du dernier cycle
            # ------------------------------------------------------
            ind1 = inst.index(10. * (2 * (2 * NB_CYCLE - 2) + 1))
            ind2 = inst.index(10. * (2 * (2 * NB_CYCLE - 1) + 1))
            ind3 = inst.index(10. * (2 * (2 * NB_CYCLE) + 1))
            
            p      = (sig_xx + sig_yy + sig_zz) / 3.
            q      = sig_zz - sig_xx
            eps_vol= eps_xx + eps_yy + eps_zz
            pre_eau= -1. * coef_eau * eps_vol
            ru     = -pre_eau * 3./(1.+2.*KZERO) / sig0
            Es     = abs( (q[ind3]-q[ind2]) / (eps0-eps1) / Es_max)
            
            # Definition gde l'amortissement hysteretique generalisee:
            # Aire du grand triangle: energie elastique sur le 1/2 du cycle
            # Kokusho,
            # "cyclic triaxial test of dynamic soil properties for wide strain range"
            # Soil & Foundations, 1980
            # --------------------------------------------------------
            # D = dW/W:
            # Pour le calculer, on suppose l'eau incompressible:
            # => epsi_vol = 0  soit dW1 = dsig_vol*depsi_vol = 0
            # Donc dW = dW2 = (dsig_zz-dsig_xx) * (depsi_zz-dpesi_xx)
            # ------------------------------------------------------
            gamma = eps_zz-eps_xx
            
            # 1ere moitie de la boucle
            I = NP.sum(0.5 * (q[ind1:ind2] + q[ind1+1:ind2+1]) *\
                             (gamma[ind1+1:ind2+1] - gamma[ind1:ind2]))
            
            # 2eme moitie de la boucle
            J = NP.sum(0.5 * (q[ind2:ind3] + q[ind2+1:ind3+1]) *\
                             (gamma[ind2+1:ind3+1] - gamma[ind2:ind3]))
                
            delta_W = abs(I+J)
            
            # aire du triangle: energie elastique sur le 1/4 du cycle
            # ---------------------------------------------------------
            W = 0.5 * abs((q[ind3]-q[ind2])*(gamma[ind3]-gamma[ind2]))
            D = delta_W / M.pi/W
            
            # le critere de liquefaction est-il atteint?
            # --------------------------------------------------
            rubool = ru >= RU_MAX
            
            crit = rubool.any()
            
            # SI CRITERE ATTEINT -> MAJ des listes pour "NCYCL-DEPSI"
            # --------------------------------------------------------
            # codret = | '0' : CALC_POINT_MAT va jusqu'au bout et
            #          |       critere de liquefaction atteint
            #          |
            #          | '1' : CALC_POINT_MAT va jusqu'au bout et
            #          |       critere de liquefaction non atteint
            if crit:
               codret  = '0'
               indcrit = list(rubool).index(True)
               ncycrit = M.ceil(inst[indcrit]/40.)
               n_cyc_table[i][j] = ncycrit
               Resu_Essai['DEPSI'][i].append(eps1-eps0)
               Resu_Essai['NCYCL'][i].append(ncycrit)
            else:
               codret = '1'
               ncycrit= 0
            
            # Sauvegarde des resultats par defaut
            # ------------------------------------------------------
            Resu_Essai['SIG_AXI'][i].append(list(-sig_zz))
            Resu_Essai['SIG_LAT'][i].append(list(-sig_xx))
            Resu_Essai['EPS_AXI'][i].append(list(-eps_zz))
            Resu_Essai['EPS_LAT'][i].append(list(-eps_xx))
            Resu_Essai['EPS_VOL'][i].append(list(-eps_vol))
            Resu_Essai['INST'][i].append(inst)
            Resu_Essai['P'][i].append(list(-p))
            Resu_Essai['Q'][i].append(list(-q))
            Resu_Essai['PRE_EAU'][i].append(list(pre_eau))
            Resu_Essai['RU'][i].append(list(ru))
            Resu_Essai['RU_MAX'][i].append(max(ru))
            Resu_Essai['E_SUR_EMAX'][i].append(Es)
            Resu_Essai['DAMPING'][i].append(D)
            
            # Recuperation des composantes supplementaires
            # existantes dans le resultat
            # --------------------------------------------------------
            if List_Resu_Supp:
               try:
                 # Cas ou list_key existe deja (i>0)
                 # list_key contient les composantes
                 # EXISTANTES dans le resultat
                 # (list_key pas necessairement egal a List_Resu_Supp)
                 for lr in list_key:
                    Resu_Essai[lr][i].append(TabRes[lr])
               
               except:
                 # Cas ou list_key n existe pas (i=0)
                 list_key=[]
                 for lr in List_Resu_Supp:
                   if TabRes.has_key(lr):
                      list_key.append(lr)
                      Resu_Essai[lr][i].append(TabRes[lr])
                  
               if not i:
                 Resu_Essai['LIST_CMP'] =TabRes.keys()

            # NIVEAU 2: remplissage des graphiques
            # ------------------------------------------------------
            str_leg2 = "EPSMAX=" + str("%.2E" %(-eps0)) +\
                      " EPSMIN=" + str("%.2E" %(-eps1))
                                      
            list_x=[list(-p),list(-eps_zz),list(-eps_zz),list(-p),
                    list(-eps_zz),list(-eps_zz),list(-p),]
                    
            list_y=[list(-q),list(-eps_vol),list(-q),list(-eps_vol),
                    list(pre_eau),list(ru),list(pre_eau),]
                    
            list_title=["P-Q","EPS_AXI-EPS_VOL","EPS_AXI-Q","P-EPS_VOL",
                        "EPS_AXI-PRE_EAU","EPS_AXI-RU","P-PRE_EAU",]
        
            for g in DicoEssai['GRAPHIQUE']:
    
              if g in list_title:
          
                k = list_title.index(g)
            
                remplir_graphique(DicoEssai, Courbes_niv2, list_x[k],
                                  list_y[k], str_leg2, g,
                                  COULEUR_NIV2[j],
                                  MARQUEUR_NIV2[j],
                                  STYLE_NIV2[j],)
              else:
       
                li  = g.split('-')
          
                if len(li)!=2:
                   continue
                else:
                   cmpx,cmpy=li[0],li[1]
               
                if (cmpx in Resu_Essai['LIST_CMP']+cle) and \
                   (cmpy in Resu_Essai['LIST_CMP']+cle):

                   remplir_graphique(DicoEssai, Courbes_niv2, Resu_Essai[cmpx][i][j],
                                     Resu_Essai[cmpy][i][j], str_leg2, g,
                                     COULEUR_NIV2[j],
                                     MARQUEUR_NIV2[j],
                                     STYLE_NIV2[j],)

            DETRUIRE(CONCEPT=_F(NOM=(__CHAR1, __CHAR2,)), INFO=1)
    # ---
    # Fin boucle NIVEAU 2 sur les amplitudes de variation EPSI_IMPOSE
    # ---

        # NIVEAU 1: remplissage des graphiques
        # ------------------------------------------------------
        str_leg1 = "PRES_CONF = " + str("%.2E" %(sig0))
        
        if 'NCYCL-DEPSI' in DicoEssai['GRAPHIQUE']:
        
           remplir_graphique(DicoEssai, Courbes_niv1, Resu_Essai['NCYCL'][i],
                          Resu_Essai['DEPSI'][i], str_leg1, "NCYCL-DEPSI",
                          COULEUR_NIV1[i],
                          MARQUEUR_NIV1[i],
                          STYLE_NIV1[i],)
                          
        if 'DEPSI-RU_MAX' in DicoEssai['GRAPHIQUE']:
        
           remplir_graphique(DicoEssai, Courbes_niv1, EPSI_IMPOSE,
                          Resu_Essai['RU_MAX'][i], str_leg1, "DEPSI-RU_MAX",
                          COULEUR_NIV1[i],
                          MARQUEUR_NIV1[i],
                          STYLE_NIV1[i],)

        if 'DEPSI-E_SUR_EMAX' in DicoEssai['GRAPHIQUE']:
        
           remplir_graphique(DicoEssai, Courbes_niv1, EPSI_IMPOSE,
                          Resu_Essai['E_SUR_EMAX'][i], str_leg1, "DEPSI-E_SUR_EMAX",
                          COULEUR_NIV1[i],
                          MARQUEUR_NIV1[i],
                          STYLE_NIV1[i],)
                          
        if 'DEPSI-DAMPING' in DicoEssai['GRAPHIQUE']:
        
           remplir_graphique(DicoEssai, Courbes_niv1, EPSI_IMPOSE,
                          Resu_Essai['DAMPING'][i], str_leg1, "DEPSI-DAMPING",
                          COULEUR_NIV1[i],
                          MARQUEUR_NIV1[i],
                          STYLE_NIV1[i],)

        # NIVEAU 2: impression des graphiques
        # ------------------------------------------------------
        impr_graphique(self, DicoEssai, Courbes_niv2, NomsFich_niv2, Leg_x_niv2,
                       Leg_y_niv2, {}, {}, typessai+" - "+str_leg1,
                       graph=i*len(Courbes_niv2),)
# ---
# Fin boucle NIVEAU 1 sur les sur les pressions de confinement PRES_CONF
# ---

    # NIVEAU 1: impression des graphiques
    # --------------------------------------------------------
    impr_graphique(self, DicoEssai, Courbes_niv1, NomsFich_niv1, Leg_x_niv1,
                   Leg_y_niv1, Ech_x_niv1, Ech_y_niv1, typessai,
                   graph=len(PRES_CONF)*len(Courbes_niv2),)

    # remplissage des tables
    # --------------------------------------------------
    Resu_Essai['NCYCL'] = n_cyc_table
    Resu_Essai['DEPSI'] = [EPSI_IMPOSE]*len(PRES_CONF)
    
    if str_n_essai:
       remplir_tables(self, typessai, str_n_essai, DicoEssai, Resu_Essai)
    else:
       remplir_tables(self, typessai, '1', DicoEssai, Resu_Essai)

    DETRUIRE(CONCEPT=_F(NOM=(__RLIST, __DLIST),), INFO=1)
    
    
# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
#                                                                         #
#                    ESSAI OEDOMETRIQUE DRAINE CYCLIQUE                   #
#                    A CONTRAINTE IMPOSEE  [OEDO_DR_C_F]                  #
#                                                                         #
# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
def essai_OEDO_DR_C_F(self, str_n_essai, DicoEssai, MATER,
                 COMPORTEMENT, CONVERGENCE, INFO, oedometer=True,):
    """
    Objet: Essai OEDOmetrique DRaine Cyclique a Force imposee
           (OEDO_DR_C_F)
    """
    import numpy as NP
    import math as M
    from Accas import _F
    import aster
    from Utilitai.Utmess import UTMESS
    from Comportement import catalc
    
    # Essai de type oedometre ou isotrope?
    # -----------------------------------------
    if oedometer:
       typessai = 'OEDO_DR_C_F'
    else:
       typessai = 'ISOT_DR_C_F'
    
    # Recuperation des commandes Aster
    # -----------------------------------------
    DEFI_FONCTION  = self.get_cmd('DEFI_FONCTION')
    SIMU_POINT_MAT = self.get_cmd('SIMU_POINT_MAT')
    DETRUIRE       = self.get_cmd('DETRUIRE')
    CREA_TABLE     = self.get_cmd('CREA_TABLE')
    IMPR_TABLE     = self.get_cmd('IMPR_TABLE')
    DEFI_LIST_INST = self.get_cmd('DEFI_LIST_INST')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')
    
    # Recuperation des parametres d'essais
    # -----------------------------------------
    PRES_CONF   = DicoEssai['PRES_CONF']
    SIGM_DECH   = DicoEssai['SIGM_DECH']
    SIGM_IMPOSE = DicoEssai['SIGM_IMPOSE']
    KZERO       = DicoEssai['KZERO']
    NB_INST     = DicoEssai['NB_INST']
    NB_CYCLE    = len(SIGM_IMPOSE)-1
    
    # Recuperation des options d'impression
    # -----------------------------------------
    if DicoEssai.has_key('COULEUR'):
    
       COULEUR_NIV2= DicoEssai['COULEUR']
       
       assert len(COULEUR_NIV2) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste COULEUR" %(len(COULEUR_NIV2))+\
       " doit etre egale a        !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                        !!!\n"
       
    else:
       COULEUR_NIV2= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('MARQUEUR'):
    
       MARQUEUR_NIV2= DicoEssai['MARQUEUR']
       
       assert len(MARQUEUR_NIV2) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste MARQUEUR" %(len(MARQUEUR_NIV2))+\
       " doit etre egale a        !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                         !!!\n"
    else:
       MARQUEUR_NIV2= [-1]*len(PRES_CONF)
    
    if DicoEssai.has_key('STYLE'):
    
       STYLE_NIV2= DicoEssai['STYLE']
       
       assert len(MARQUEUR_NIV2) == len(PRES_CONF),\
       "\n   !!!   La longueur %2d de la liste STYLE" %(len(STYLE_NIV2))+\
       " doit etre egale a        !!!" +\
       "\n   !!!   la longueur %2d de la liste PRES_CONF" %(len(PRES_CONF))+\
       "                          !!!\n"
    else:
       STYLE_NIV2= [-1]*len(PRES_CONF)
    
    # Recuperation des variables supplementaires a imprimer
    # (si existantes) contenues sous le mot-cle 'NOM_CMP'
    # -----------------------------------------
    if DicoEssai.has_key('NOM_CMP'):
       List_Resu_Supp = list(DicoEssai['NOM_CMP'])
    else:
       List_Resu_Supp = None
       
    # Chargement lineaire par morceaux ou sinusoidal?
    # ------------------------------------------------
    sinusoidal = DicoEssai['TYPE_CHARGE'] == 'SINUSOIDAL'

    # recuperation du nombre de VI associe a la LdC
    # -----------------------------------------
    nom_lc = COMPORTEMENT.List_F()[0]['RELATION']
    num_lc, nb_vari, nbid = catalc.get_info(nom_lc)
    #num_lc, nb_vari = catalc.get_info(nom_lc)
    
    assert type(nb_vari) is int and nb_vari > 0

    # dict permettant la gestion des graphiques
    # -----------------------------------------
    Courbes_niv2  =dict()
    NomsFich_niv2 =dict()
    Leg_x_niv2    =dict()
    Leg_y_niv2    =dict()
    
    # dict permettant la gestion des tables en sortie
    # ----------------------------------------------------
    Resu_Essai    ={'LIST_CMP': []}
    
    cle = ['INST','SIG_AXI','SIG_LAT','EPS_VOL','P',]
    if List_Resu_Supp:
    
      try:
          List_Resu_Supp.remove('INST')
      except:
          cle+= List_Resu_Supp
      else:
          cle+= List_Resu_Supp
    
    for c in cle:
       Resu_Essai[c] = [[] for k in xrange(len(PRES_CONF))]
       
    # Hors composantes de niveau 1
    # -----------------------------------------
    cle = ['INST','SIG_AXI','SIG_LAT','EPS_VOL','P',]

    # NIVEAU 2: preparation des graphiques
    # -----------------------------------------
    if str_n_essai:
       str_fich_niv2 = "%s_%s_" %(typessai,str_n_essai,)
    else:
       str_fich_niv2 = "%s_" %(typessai,)
    
    preparer_graphique('2', DicoEssai, str_fich_niv2, Courbes_niv2, NomsFich_niv2,
                       Leg_x_niv2, Leg_y_niv2, {}, {},)
                       
    # ---
    # Creation de la liste d'instants (NB_INST = nombre d'instants par 1/4 de cycle)
    # ---
    __RLIST = DEFI_LIST_REEL(DEBUT=0.,
                             INTERVALLE=[_F(JUSQU_A=10., NOMBRE=NB_INST,), ] +\
                                        [_F(JUSQU_A=10.*(2*k+1), NOMBRE=2*NB_INST,)
                                            for k in xrange(1, 2*NB_CYCLE+2)],
                             INFO=INFO)

    __DLIST = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__RLIST),
                             ECHEC=_F(SUBD_METHODE='MANUEL',
                                      SUBD_PAS    =2,
                                      SUBD_NIVEAU =10,),
                             INFO=INFO,)
# ---
# Boucle NIVEAU 1 sur les pressions de consolidation initiale PRES_CONF
# ---
    for i,sig0__ in enumerate(PRES_CONF):
    
        sig0   = -sig0__
        sigtrac= -SIGM_DECH[i]
        
        for j,sigcomp__ in enumerate(SIGM_IMPOSE):
           
           sigcomp =-sigcomp__
           
           if str_n_essai:
              affiche_infos_essai(str_n_essai, typessai, -sig0, -sigcomp, -sigtrac,)
           else:
              affiche_infos_essai('1', typessai, -sig0, -sigcomp, -sigtrac,)
              
        # ---
        # Definition des chargements
        # ---
        if sinusoidal:
   
           absc_peak= [10.*(2*k+1) for k in xrange(2*NB_CYCLE+1)]
           abscisse = [10.*k/3./NB_INST for k in xrange(3*NB_INST)]
   
           for inst_peak in absc_peak:
              abscisse+= [inst_peak + 10.*kk/3./NB_INST\
                          for kk in xrange(6*NB_INST)]
   
           # absc_sinus varie de 0 a Pi/2 par intervalles de NB_INST=10s
           # (sinus varie de 0 a 1)
           # -------------------------------------------------------------
           absc_sinus= M.pi*NP.array(abscisse)/20.
       
           sigm_mean = 0.5*(-SIGM_IMPOSE[0]+sig0)
       
           dsigm     = 0.5*(-SIGM_IMPOSE[0]-sig0)
           
           ordonnee  = list( sigm_mean +\
                      NP.sin(-0.5*M.pi+2.*absc_sinus[:3*NB_INST])*dsigm )
       
           sigm_mean = 0.5*(-SIGM_IMPOSE[0]+sigtrac)
       
           dsigm     = 0.5*(-SIGM_IMPOSE[0]-sigtrac)
           
           ordonnee += list( sigm_mean +\
                       NP.sin(absc_sinus[3*NB_INST:9*NB_INST])*dsigm )
           
           for j,sigcomp__ in enumerate(SIGM_IMPOSE[1:]):
           
              sigcomp =-sigcomp__
       
              sigm_mean = 0.5*(sigcomp+sigtrac)
       
              dsigm     = 0.5*(sigcomp-sigtrac)
           
              ordonnee += list( sigm_mean +\
                NP.sin(absc_sinus[(9+12*j)*NB_INST:(9+12*(j+1))*NB_INST])*dsigm )
        else:
        
           abscisse = [0.]+[10.*(2*k+1) for k in xrange(2*NB_CYCLE+2)]
           
           ordonnee =[sig0,]
           for j,sigcomp__ in enumerate(SIGM_IMPOSE):
           
              sigcomp =-sigcomp__
              #ordon += [sigcomp,sigtrac]
              # permet de retrouver le chargement defini par S. Assandi
              # finalement, parait + logique
#               if not j:
#                  ordonnee += [sigcomp+sig0,sigtrac]
#               else:
#                  ordonnee += [sigcomp+sigtrac,sigtrac]
              
              ordonnee += [sigcomp,sigtrac,]

        __CHAR1 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                ABSCISSE=abscisse,
                                ORDONNEE=list(ordonnee),
                                PROL_DROITE='LINEAIRE',)
                                
        __CHAR2 = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                                VALE=(0.                , 0.,
                                      10.*(4*NB_CYCLE+3), 0.,),
                                PROL_DROITE='CONSTANT',)
        if oedometer:
        
           sigm_impo = _F(SIZZ=__CHAR1,)
           
           epsi_impo = _F(EPXX=__CHAR2,
                          EPYY=__CHAR2,
                          EPXY=__CHAR2,
                          EPXZ=__CHAR2,
                          EPYZ=__CHAR2,)
        else:
           sigm_impo = _F(SIXX=__CHAR1,
                          SIYY=__CHAR1,
                          SIZZ=__CHAR1,)
                          
           epsi_impo = _F(EPXY=__CHAR2,
                          EPXZ=__CHAR2,
                          EPYZ=__CHAR2,)
        # ---
        # Calcul
        # ---
        try:
           __EVOL = SIMU_POINT_MAT(INFO=INFO,
        
            COMPORTEMENT=COMPORTEMENT.List_F(),
            
            CONVERGENCE=CONVERGENCE.List_F(),
            
            MATER=MATER,
            
            SUPPORT='POINT',
            
            INCREMENT=_F(LIST_INST=__DLIST,
                         INST_INIT=0.,
                         INST_FIN =10.*(4*NB_CYCLE+3),),
                         
            NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
            
            ARCHIVAGE=_F(LIST_INST=__RLIST,),
            
            SIGM_IMPOSE=sigm_impo,
            
            EPSI_IMPOSE=epsi_impo,
                           
            SIGM_INIT= _F(SIXX=KZERO*sig0,
                          SIYY=KZERO*sig0,
                          SIZZ=sig0      ,),
                          
            EPSI_INIT= _F(EPXX=0.,
                          EPYY=0.,
                          EPZZ=0.,
                          EPXY=0.,
                          EPXZ=0.,
                          EPYZ=0.,),
                          
            VARI_INIT= _F(VALE=[0.]*nb_vari),)
        
        except (aster.error,aster.onFatalError,), message:
   
           print '\n   !!!(@_@)!!! Arret pour la raison suivante !!!(@_@)!!!\n%s'\
                     %(message)
        
           __EVPOST = self.get_last_concept()
           TabRes   = __EVPOST.EXTR_TABLE().values()
           
           DETRUIRE(CONCEPT=_F(NOM=__EVPOST), INFO=1)

        else:
           TabRes = __EVOL.EXTR_TABLE().values()
           
           DETRUIRE(CONCEPT=_F(NOM=__EVOL), INFO=1)
            
        # ---
        # Post-traitements.
        # ---
        #TabRes = __EVOL.EXTR_TABLE().values()
        
        sig_xx = NP.array(TabRes['SIXX'])
        sig_yy = NP.array(TabRes['SIYY'])
        sig_zz = NP.array(TabRes['SIZZ'])
        eps_xx = NP.array(TabRes['EPXX'])
        eps_yy = NP.array(TabRes['EPYY'])
        eps_zz = NP.array(TabRes['EPZZ'])
        inst   = TabRes['INST']
        
        p      = (sig_xx + sig_yy + sig_zz) /3.
        eps_vol= eps_xx + eps_yy + eps_zz
        
        # Sauvegarde des resultats par defaut
        # ------------------------------------------------------
        Resu_Essai['EPS_VOL'][i] =list(-eps_vol)
        Resu_Essai['SIG_AXI'][i] =list(-sig_zz)
        Resu_Essai['SIG_LAT'][i] =list(-sig_xx)
        Resu_Essai['P'][i]       =list(-p)
        Resu_Essai['INST'][i]    =inst
        
        # Recuperation des composantes supplementaires
        # existantes dans le resultat
        # --------------------------------------------------------
        if List_Resu_Supp:
           try:
             # Cas ou list_key existe deja (i>0)
             # list_key contient les composantes
             # EXISTANTES dans le resultat
             # (list_key pas necessairement egal a List_Resu_Supp)
             for lr in list_key:
                Resu_Essai[lr][i] =TabRes[lr]
           
           except:
             # Cas ou list_key n existe pas (i=0)
             list_key=[]
             for lr in List_Resu_Supp:
               if TabRes.has_key(lr):
                  list_key.append(lr)
                  Resu_Essai[lr][i]=TabRes[lr]
              
           if not i:
             Resu_Essai['LIST_CMP'] =TabRes.keys()
             
        # NIVEAU 2: remplissage des graphiques
        # ------------------------------------------------------
        str_leg2 = "PCONF=" + str("%.2E" %(-sig0)) +\
                  " SIDECH=" + str("%.2E" %(-sigtrac))
                                      
        list_x=[list(-p),list(-sig_zz),]
        list_y=[list(-eps_vol),list(-eps_vol),]
        list_title=["P-EPS_VOL","SIG_AXI-EPS_VOL",]
        
        for g in DicoEssai['GRAPHIQUE']:
    
          if g in list_title:
        
            k = list_title.index(g)
        
            remplir_graphique(DicoEssai, Courbes_niv2, list_x[k],
                              list_y[k], str_leg2, g,
                              COULEUR_NIV2[i],
                              MARQUEUR_NIV2[i],
                              STYLE_NIV2[i],)
          else:
       
            li  = g.split('-')
        
            if len(li)!=2:
               continue
            else:
               cmpx,cmpy=li[0],li[1]
           
            if (cmpx in Resu_Essai['LIST_CMP']+cle) and \
               (cmpy in Resu_Essai['LIST_CMP']+cle):
           
               remplir_graphique(DicoEssai, Courbes_niv2, Resu_Essai[cmpx][i],
                                 Resu_Essai[cmpy][i], str_leg2, g,
                                 COULEUR_NIV2[i],
                                 MARQUEUR_NIV2[i],
                                 STYLE_NIV2[i],)
# ---
# Fin boucle sur les pressions de consolidation isotrope initiale PRES_CONF
# ---

    # NIVEAU 2: impression des graphiques
    # ------------------------------------------------------
    impr_graphique(self, DicoEssai, Courbes_niv2,
                   NomsFich_niv2, Leg_x_niv2, Leg_y_niv2, {}, {}, typessai,)

    # remplissage des tables
    # ------------------------------------------------------
    if str_n_essai:
       remplir_tables(self, typessai, str_n_essai, DicoEssai, Resu_Essai)
    else:
       remplir_tables(self, typessai, '1', DicoEssai, Resu_Essai)


# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
#                                                                         #
#             ESSAI DE CONSOLIDATION ISOTROPE DRAINEE CYCLIQUE            #
#                   A CONTRAINTE IMPOSEE  [ISOT_DR_C_F]                   #
#                                                                         #
# ----------------------------------------------------------------------- #
# ----------------------------------------------------------------------- #
def essai_ISOT_DR_C_F(self, str_n_essai, DicoEssai, MATER, COMPORTEMENT, CONVERGENCE, INFO):
    """
    Objet: Essai de consolidation ISOTrope DRainee Cyclique a Force imposee
           (ISOT_DR_C_F)
    """
    DicoEssai['KZERO'] = 1.
    
    essai_OEDO_DR_C_F(self, str_n_essai, DicoEssai, MATER, COMPORTEMENT,
                 CONVERGENCE, INFO, oedometer=False,)
