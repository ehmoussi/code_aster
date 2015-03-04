# coding=utf-8

from Cata.Syntax import *
from Cata.DataStructure import *
from Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
# (AT YOUR OPTION) ANY LATER VERSION.
#
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.
#
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
# ======================================================================
# person_in_charge: jean-michel.proix at edf.fr
DEFI_COMPOR=OPER(nom="DEFI_COMPOR",op=59,sd_prod=compor_sdaster,
                   fr=tr("Définir le comportement d'un monocristal, d'un polycristal ou de groupes de fibres"),
                   reentrant='n',
            UIinfo={"groupes":("Modélisation",)},
# on exclut MULTIFBRE de MONOCRISTAL ou POLYCRISTAL car la structure de données n'est pas organisée pareil pour ces cas
                  regles=(UN_PARMI('MONOCRISTAL','POLYCRISTAL','MULTIFIBRE'),
                 PRESENT_PRESENT('MULTIFIBRE','GEOM_FIBRE','MATER_SECT'),
                         ),
          MONOCRISTAL    =FACT(statut='f', max=5,
             MATER           =SIMP(statut='o', typ=mater_sdaster, max=1),
             ECOULEMENT      =SIMP(statut='o', typ='TXM', max=1,
                   into=('MONO_VISC1', 'MONO_VISC2', 'MONO_DD_KR', 'MONO_DD_CFC', 'MONO_DD_CFC_IRRA',
                         'MONO_DD_CC', 'MONO_DD_CC_IRRA', 'MONO_DD_FAT',),
                   fr=tr("Donner le nom du mot-clé facteur de DEFI_MATERIAU précisant le type d'écoulement viscoplastique")),
             ELAS            =SIMP(statut='f', typ='TXM', max=1,
                   fr=tr("Donner le nom du mot-clé facteur de DEFI_MATERIAU précisant le comportement élastique (un et un seul)")),
             b_non_dd =BLOC(condition="ECOULEMENT=='MONO_VISC1' or ECOULEMENT=='MONO_VISC2'",
                   ECRO_ISOT       =SIMP(statut='o', typ='TXM', max=1,
                   fr=tr("Donner le nom du mot-clé facteur de DEFI_MATERIAU précisant le type d'écrouissage isotrope")),
                   ECRO_CINE       =SIMP(statut='o', typ='TXM', max=1,
                   fr=tr("Donner le nom du mot-clé facteur de DEFI_MATERIAU précisant le type d'écrouissage cinématique")),
                   FAMI_SYST_GLIS  =SIMP(statut='f',typ='TXM', max=1,
                                into=('OCTAEDRIQUE','BCC24','CUBIQUE1','CUBIQUE2','ZIRCONIUM','UNIAXIAL','UTILISATEUR'),
                                ),
                   b_util =BLOC(condition="FAMI_SYST_GLIS=='UTILISATEUR' ",
                          TABL_SYST_GLIS =SIMP(statut='f', typ=table_sdaster, max=1,),
                           ),
                                ),
             b_dd_kr =BLOC(condition="ECOULEMENT=='MONO_DD_KR' ",
                   FAMI_SYST_GLIS  =SIMP(statut='f',typ='TXM', max=1,
                                into=('BCC24','UTILISATEUR'),defaut=('BCC24',),),
                   b_util =BLOC(condition="FAMI_SYST_GLIS=='UTILISATEUR' ",
                          TABL_SYST_GLIS =SIMP(statut='f', typ=table_sdaster, max=1,),
                           ),
                                ),
             b_ecp_cfc =BLOC(condition="ECOULEMENT=='MONO_DD_FAT' ",
                   FAMI_SYST_GLIS  =SIMP(statut='f',typ='TXM', max=1,
                                into=('OCTAEDRIQUE','UTILISATEUR',),defaut=('OCTAEDRIQUE',),),
                                ),
             b_dd_cfc =BLOC(condition="ECOULEMENT=='MONO_DD_CFC'  or ECOULEMENT=='MONO_DD_CFC_IRRA'",
                   FAMI_SYST_GLIS  =SIMP(statut='f',typ='TXM', max=1,
                                into=('OCTAEDRIQUE','UTILISATEUR',),defaut=('OCTAEDRIQUE',),),
                   b_util =BLOC(condition="FAMI_SYST_GLIS=='UTILISATEUR' ",
                          TABL_SYST_GLIS =SIMP(statut='f', typ=table_sdaster, max=1,),
                           ),
                                ),
             b_dd_cc =BLOC(condition="ECOULEMENT=='MONO_DD_CC' or ECOULEMENT=='MONO_DD_CC_IRRA' ",
                   FAMI_SYST_GLIS  =SIMP(statut='f',typ='TXM', max=1,
                                into=('CUBIQUE1','UTILISATEUR',),defaut=('CUBIQUE1',),),
                   b_util =BLOC(condition="FAMI_SYST_GLIS=='UTILISATEUR' ",
                          TABL_SYST_GLIS =SIMP(statut='f', typ=table_sdaster, max=1,),
                           ),
                                ),
                                ),

          MATR_INTER =SIMP(statut='f', typ=table_sdaster, max=1,),

          ROTA_RESEAU =SIMP(statut='f', typ='TXM', max=1,into=('NON','POST','CALC'),defaut='NON',
                   fr=tr("rotation de reseau : NON, POST, CALC")),

          POLYCRISTAL    =FACT(statut='f', max='**',
           regles=(UN_PARMI('ANGL_REP','ANGL_EULER'),),
             MONOCRISTAL     =SIMP(statut='o', typ=compor_sdaster, max=1),
             FRAC_VOL  =SIMP(statut='o', typ='R', max=1,fr=tr("fraction volumique de la phase correspondant au monocristal")),
             ANGL_REP  =SIMP(statut='f',typ='R',max=3,fr=tr("orientation du monocristal : 3 angles nautiques en degrés")),
             ANGL_EULER=SIMP(statut='f',typ='R',max=3,fr=tr("orientation du monocristal : 3 angles d'Euler   en degrés")),
                                ),


          b_poly      =BLOC( condition = "POLYCRISTAL!=None",
              MU_LOCA     =SIMP(statut='o',typ='R',max=1),
              LOCALISATION=SIMP(statut='f', typ='TXM', max=1, into=('BZ', 'BETA',),
                                fr=tr("Donner le nom de la règle de localisation")),
              b_beta      =BLOC( condition = "LOCALISATION=='BETA'",
                  DL            =SIMP(statut='o',typ='R',max=1),
                  DA            =SIMP(statut='o',typ='R',max=1),),
          ),

#####################################################################################
          GEOM_FIBRE = SIMP(statut='f',max=1,typ=gfibre_sdaster,
                   fr=tr("Donner le nom du concept regroupant tous les groupes de fibres (issu de DEFI_GEOM_FIBRE)")),
          MATER_SECT = SIMP(statut='f',max=1,typ=mater_sdaster,
                   fr=tr("Donner le nom du materiau pour les caracteristiques homogeneisees sur la section")),
          MULTIFIBRE    = FACT(statut='f',max='**',
          GROUP_FIBRE        =SIMP(statut='o', typ='TXM', max='**'),
             MATER           =SIMP(statut='o', typ=mater_sdaster, max=1,
                                   fr=tr("Donner le nom du materiau pour le groupe de fibres")),
             RELATION        =SIMP(statut='f', typ='TXM', max=1,defaut="ELAS",into=C_RELATION('DEFI_COMPOR'),
                                  fr=tr("Donner le nom de la relation incrementale pour le groupe de fibres"),
                                  ),
           RELATION_KIT    =SIMP(statut='f',typ='TXM',max='**',validators=NoRepeat(),
                                 into=(
# MECA KIT_DDI
                                       "VMIS_ISOT_TRAC",
                                       "VMIS_ISOT_LINE",
                                       "VMIS_ISOT_PUIS",
                                       "GRANGER_FP",
                                       "GRANGER_FP_INDT",
                                       "GRANGER_FP_V",
                                       "BETON_UMLV_FP",
                                       "ROUSS_PR",
                                       "BETON_DOUBLE_DP",
                                       "ENDO_PORO_BETON",
                                       "FLUA_PORO_BETON",
                                       ),),
# on pourrait ajouter TOUT_GROUP_FIBRE

                                ) );
