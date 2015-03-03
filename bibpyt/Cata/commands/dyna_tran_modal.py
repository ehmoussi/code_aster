# coding=utf-8

from Cata.Descriptor import *
from Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: emmanuel.boyere at edf.fr
DYNA_TRAN_MODAL=OPER(nom="DYNA_TRAN_MODAL",op=  74,sd_prod=tran_gene,
                     fr=tr("Calcul de la reponse dynamique transitoire d'un systeme amorti ou non en coordonees generalisees"
                        " par superposition modale ou par sous structuration"),
                     reentrant='f',
            UIinfo={"groupes":("Resolution","Dynamique",)},
      regles=(EXCLUS('AMOR_MODAL','MATR_AMOR'),
              PRESENT_ABSENT('MODE_STAT','MODE_CORR'),),
          SCHEMA_TEMPS  =FACT(statut='d',
                SCHEMA  =SIMP(statut='f',typ='TXM',defaut="NEWMARK",
  into=("NEWMARK","EULER","DEVOGE","ADAPT_ORDRE1","ADAPT_ORDRE2","ITMI","RUNGE_KUTTA_54","RUNGE_KUTTA_32")),
                b_newmark     =BLOC(condition="SCHEMA=='NEWMARK'",
                        BETA           =SIMP(statut='f',typ='R',defaut= 0.25 ),
                        GAMMA           =SIMP(statut='f',typ='R',defaut= 0.5 ),
                        ),
                b_runge_kutta     =BLOC(condition="SCHEMA=='RUNGE_KUTTA_54' or SCHEMA=='RUNGE_KUTTA_32'",
                        TOLERANCE           =SIMP(statut='f',typ='R',defaut= 1.E-3 ),
                        ),
                b_itmi          =BLOC(condition = "SCHEMA=='ITMI'",
               regles=(ENSEMBLE('BASE_ELAS_FLUI','NUME_VITE_FLUI'),),
                BASE_ELAS_FLUI  =SIMP(statut='f',typ=melasflu_sdaster ),
                NUME_VITE_FLUI  =SIMP(statut='f',typ='I' ),
                ETAT_STAT       =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),
                PREC_DUREE      =SIMP(statut='f',typ='R',defaut= 1.E-2 ),
                CHOC_FLUI       =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),
                NB_MODE         =SIMP(statut='f',typ='I' ),
                NB_MODE_FLUI    =SIMP(statut='f',typ='I' ),
                TS_REG_ETAB     =SIMP(statut='f',typ='R' ),
         ),
         ),
         MATR_MASS       =SIMP(statut='o',typ=matr_asse_gene_r ),
         MATR_RIGI       =SIMP(statut='o',typ=matr_asse_gene_r ),
         MATR_AMOR       =SIMP(statut='f',typ=matr_asse_gene_r ),
         VITESSE_VARIABLE     =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),
         b_variable          =BLOC(condition="VITESSE_VARIABLE=='OUI'",
               MATR_GYRO       =SIMP(statut='o',typ=matr_asse_gene_r ),
               VITE_ROTA       =SIMP(statut='o',typ=(fonction_sdaster,formule) ),
               MATR_RIGY       =SIMP(statut='f',typ=matr_asse_gene_r ),
               ACCE_ROTA       =SIMP(statut='f',typ=(fonction_sdaster,formule) ),
           ),
         b_constante         =BLOC(condition="VITESSE_VARIABLE=='NON'",
               VITE_ROTA          = SIMP(statut='o',typ='R',defaut=0.E0),
               COUPLAGE_EDYOS     =FACT(statut='f',max=1,
                                   PAS_TPS_EDYOS      = SIMP(statut='o',typ='R' ),
         ),

           ),

         AMOR_MODAL      =FACT(statut='f', max=1,
                    regles=(EXCLUS('AMOR_REDUIT','LIST_AMOR'),),
                AMOR_REDUIT     =SIMP(statut='f',typ='R',max='**'),
                LIST_AMOR       =SIMP(statut='f',typ=listr8_sdaster ),
         ),

         ROTOR_FISS = FACT(statut='f',max='**',
                           regles=(UN_PARMI('NOEUD_D','GROUP_NO_D'),
                                   EXCLUS('NOEUD_G','GROUP_NO_G'),
                                   PRESENT_PRESENT('NOEUD_D','NOEUD_G'),
                                   PRESENT_PRESENT('GROUP_NO_D','GROUP_NO_G',),),
                             ANGL_INIT          = SIMP(statut='o',typ='R',defaut=0.E0),
                             ANGL_ROTA          = SIMP(statut='f',typ=(fonction_sdaster,formule) ),
                             NOEUD_G            = SIMP(statut='f',typ=no),
                             NOEUD_D            = SIMP(statut='f',typ=no),
                             GROUP_NO_G         = SIMP(statut='f',typ=grno),
                             GROUP_NO_D         = SIMP(statut='f',typ=grno),
                             K_PHI              = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
                             DK_DPHI            = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
         ),

         PALIER_EDYOS      =FACT(statut='f',max='**',
         regles=(PRESENT_ABSENT('UNITE','GROUP_NO'),
                 PRESENT_ABSENT('UNITE','TYPE_EDYOS'),
                 EXCLUS('GROUP_NO','NOEUD'),),
                                     UNITE       = SIMP(statut='f',typ='I',),
                                     GROUP_NO    = SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
                                     NOEUD       = SIMP(statut='f',typ=no),
                                     TYPE_EDYOS  = SIMP(statut='f',typ='TXM',
                                     into=("PAPANL","PAFINL","PACONL","PAHYNL",),),
         ),

         ETAT_INIT       =FACT(statut='f',
           regles=(EXCLUS('RESULTAT','DEPL'),
                   EXCLUS('RESULTAT','VITE'),),
           RESULTAT   =SIMP(statut='f',typ=tran_gene ),
           b_resu     =BLOC(condition = "RESULTAT != None",
           regles=(EXCLUS('NUME_ORDRE','INST_INIT' ),),
             INST_INIT       =SIMP(statut='f',typ='R' ),
             NUME_ORDRE      =SIMP(statut='f',typ='I' ),
             CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU",),),
             b_prec_rela=BLOC(condition="(CRITERE=='RELATIF')",
                PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
             b_prec_abso=BLOC(condition="(CRITERE=='ABSOLU')",
                PRECISION       =SIMP(statut='o',typ='R',),),
           ),
           DEPL  =SIMP(statut='f',typ=vect_asse_gene ),
           VITE  =SIMP(statut='f',typ=vect_asse_gene ),
         ),
         INCREMENT       =FACT(statut='o',max='**',
           regles=(UN_PARMI('LIST_INST','PAS'),),
           LIST_INST       =SIMP(statut='f',typ=listr8_sdaster ),
           b_list_inst         =BLOC(condition = "LIST_INST != None",
           regles=(EXCLUS('NUME_FIN','INST_FIN'),),
               NUME_FIN       =SIMP(statut='f',typ='I' ),
               INST_FIN        =SIMP(statut='f',typ='R' ),
           ),
           PAS             =SIMP(statut='f',typ='R' ),
           b_pas           =BLOC(condition = "PAS != None",
               INST_INIT       =SIMP(statut='f',typ='R' ),
               INST_FIN        =SIMP(statut='o',typ='R' ),
           ),
           VERI_PAS        =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),
           VITE_MIN        =SIMP(statut='f',typ='TXM',defaut="NORM",into=("MAXI","NORM") ),
           COEF_MULT_PAS   =SIMP(statut='f',typ='R',defaut= 1.1 ),
           COEF_DIVI_PAS   =SIMP(statut='f',typ='R',defaut= 1.3333334 ),
           PAS_LIMI_RELA   =SIMP(statut='f',typ='R',defaut= 1.0E-6 ),
           NB_POIN_PERIODE =SIMP(statut='f',typ='I',defaut= 50 ),
           NMAX_ITER_PAS   =SIMP(statut='f',typ='I',defaut= 16 ),
           PAS_MAXI         =SIMP(statut='f',typ='R' ),
           PAS_MINI         =SIMP(statut='f',typ='R' ),
         ),
         ARCHIVAGE       =FACT(statut='f',max=1,
           regles         = (EXCLUS('PAS_ARCH','LIST_INST','INST'),),
           LIST_INST      = SIMP(statut='f',typ=(listr8_sdaster) ),
           INST           = SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' ),
           PAS_ARCH       = SIMP(statut='f',typ='I' ),
           CRITERE        = SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU") ),
               b_prec_rela=BLOC(condition="(CRITERE=='RELATIF')",
                    PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
               b_prec_abso=BLOC(condition="(CRITERE=='ABSOLU')",
                    PRECISION       =SIMP(statut='o',typ='R',),),
         ),
         EXCIT           =FACT(statut='f',max='**',
           regles=(UN_PARMI('FONC_MULT','COEF_MULT','ACCE'),
                   UN_PARMI('VECT_ASSE_GENE','NUME_ORDRE',),
                   PRESENT_PRESENT('ACCE','VITE','DEPL'),
#                   PRESENT_ABSENT('NUME_ORDRE','VECT_ASSE_GENE','COEF_MULT'),
                   EXCLUS('MULT_APPUI','CORR_STAT'),
                   PRESENT_PRESENT('MULT_APPUI','ACCE'),),
           VECT_ASSE_GENE  =SIMP(statut='f',typ=vect_asse_gene ),
           NUME_ORDRE      =SIMP(statut='f',typ='I' ),
           FONC_MULT       =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
           COEF_MULT       =SIMP(statut='f',typ='R' ),
           ACCE            =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
           VITE            =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
           DEPL            =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
           MULT_APPUI      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           b_mult_appui     =BLOC(condition = "MULT_APPUI == 'OUI'",
           DIRECTION       =SIMP(statut='f',typ='R',max='**'),
             regles=(EXCLUS('NOEUD','GROUP_NO'),),
             NOEUD           =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
             GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           ),
           CORR_STAT       =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           b_corr_stat     =BLOC(condition = "CORR_STAT == 'OUI'",
           D_FONC_DT       =SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster,formule) ),
           D_FONC_DT2      =SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster,formule) ),
         ),),

         MODE_STAT       =SIMP(statut='f',typ=mode_meca ),
         MODE_CORR       =SIMP(statut='f',typ=(mult_elas,mode_meca),),

         EXCIT_RESU      =FACT(statut='f',max='**',
           RESULTAT        =SIMP(statut='o',typ=tran_gene ),
           COEF_MULT       =SIMP(statut='f',typ='R',defaut=1.0 ),
         ),

         CHOC            =FACT(statut='f',max='**',
           regles=(UN_PARMI('MAILLE','GROUP_MA','NOEUD_1','GROUP_NO_1' ),
                   EXCLUS('NOEUD_2','GROUP_NO_2'),
                   PRESENT_ABSENT('GROUP_MA','NOEUD_2','GROUP_NO_2'),
                   PRESENT_ABSENT('MAILLE','NOEUD_2','GROUP_NO_2'),),
           INTITULE        =SIMP(statut='f',typ='TXM' ),
           GROUP_MA        =SIMP(statut='f',typ=grma,max='**'),
           MAILLE          =SIMP(statut='f',typ=ma,max='**'),
           NOEUD_1         =SIMP(statut='f',typ=no),
           NOEUD_2         =SIMP(statut='f',typ=no),
           GROUP_NO_1      =SIMP(statut='f',typ=grno),
           GROUP_NO_2      =SIMP(statut='f',typ=grno),
           OBSTACLE        =SIMP(statut='o',typ=table_fonction),
           ORIG_OBST       =SIMP(statut='f',typ='R',min=3,max=3),
           NORM_OBST       =SIMP(statut='o',typ='R',min=3,max=3),
           ANGL_VRIL       =SIMP(statut='f',typ='R' ),
           JEU             =SIMP(statut='f',typ='R',defaut= 1. ),
           DIST_1          =SIMP(statut='f',typ='R',val_min=0.E+0 ),
           DIST_2          =SIMP(statut='f',typ='R',val_min=0.E+0 ),
           SOUS_STRUC_1    =SIMP(statut='f',typ='TXM' ),
           SOUS_STRUC_2    =SIMP(statut='f',typ='TXM' ),
           REPERE          =SIMP(statut='f',typ='TXM',defaut="GLOBAL"),
           RIGI_NOR        =SIMP(statut='f',typ='R' ),
           AMOR_NOR        =SIMP(statut='f',typ='R',defaut= 0.E+0 ),
           RIGI_TAN        =SIMP(statut='f',typ='R',defaut= 0.E+0 ),
           AMOR_TAN        =SIMP(statut='f',typ='R' ),
           FROTTEMENT      =SIMP(statut='f',typ='TXM',defaut="NON",into=("NON","COULOMB","COULOMB_STAT_DYNA") ),
           b_coulomb       =BLOC(condition="FROTTEMENT=='COULOMB'",
               COULOMB         =SIMP(statut='o',typ='R' ),),
           b_coulomb_stat_dyna  =BLOC(condition="FROTTEMENT=='COULOMB_STAT_DYNA'",
               COULOMB_STAT    =SIMP(statut='o',typ='R' ),
               COULOMB_DYNA    =SIMP(statut='o',typ='R' ),),
         ),
         VERI_CHOC       =FACT(statut='f',
           STOP_CRITERE    =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),
           SEUIL           =SIMP(statut='f',typ='R',defaut= 0.5 ),
         ),
         FLAMBAGE        =FACT(statut='f',max='**',
           regles=(UN_PARMI('NOEUD_1','GROUP_NO_1'),
                   EXCLUS('NOEUD_2','GROUP_NO_2'),),
           NOEUD_1         =SIMP(statut='f',typ=no),
           NOEUD_2         =SIMP(statut='f',typ=no),
           GROUP_NO_1      =SIMP(statut='f',typ=grno),
           GROUP_NO_2      =SIMP(statut='f',typ=grno),
           OBSTACLE        =SIMP(statut='o',typ=table_fonction),
           ORIG_OBST       =SIMP(statut='f',typ='R',max='**'),
           NORM_OBST       =SIMP(statut='o',typ='R',max='**'),
           ANGL_VRIL       =SIMP(statut='f',typ='R' ),
           JEU             =SIMP(statut='f',typ='R',defaut= 1. ),
           DIST_1          =SIMP(statut='f',typ='R' ),
           DIST_2          =SIMP(statut='f',typ='R' ),
           REPERE          =SIMP(statut='f',typ='TXM',defaut="GLOBAL"),
           RIGI_NOR        =SIMP(statut='f',typ='R' ),
           FNOR_CRIT       =SIMP(statut='f',typ='R' ),
           FNOR_POST_FL    =SIMP(statut='f',typ='R' ),
           RIGI_NOR_POST_FL=SIMP(statut='f',typ='R' ),
         ),
         ANTI_SISM       =FACT(statut='f',max='**',
           regles=(UN_PARMI('NOEUD_1','GROUP_NO_1'),
                   UN_PARMI('NOEUD_2','GROUP_NO_2'),),
           NOEUD_1         =SIMP(statut='f',typ=no),
           NOEUD_2         =SIMP(statut='f',typ=no),
           GROUP_NO_1      =SIMP(statut='f',typ=grno),
           GROUP_NO_2      =SIMP(statut='f',typ=grno),
           RIGI_K1         =SIMP(statut='f',typ='R',defaut= 0.E+0 ),
           RIGI_K2         =SIMP(statut='f',typ='R',defaut= 0.E+0 ),
           SEUIL_FX        =SIMP(statut='f',typ='R',defaut= 0.E+0 ),
           C               =SIMP(statut='f',typ='R',defaut= 0.E+0 ),
           PUIS_ALPHA      =SIMP(statut='f',typ='R',defaut= 0.E+0 ),
           DX_MAX          =SIMP(statut='f',typ='R',defaut= 1. ),
         ),
         DIS_VISC =FACT(statut='f',max='**',
            fr=tr("Loi pour un discret de type visqueux : Zener Généralisé."),
            regles=(UN_PARMI('NOEUD_1','GROUP_NO_1'),UN_PARMI('NOEUD_2','GROUP_NO_2'),
                    UN_PARMI('K1','UNSUR_K1'), UN_PARMI('K2','UNSUR_K2'), UN_PARMI('K3','UNSUR_K3'),),
            NOEUD_1     =SIMP(statut='f',typ=no),
            NOEUD_2     =SIMP(statut='f',typ=no),
            GROUP_NO_1  =SIMP(statut='f',typ=grno),
            GROUP_NO_2  =SIMP(statut='f',typ=grno),
            K1          =SIMP(statut='f',typ='R',val_min = 1.0E-08, fr=tr("Raideur en série avec les 2 autres branches.")),
            K2          =SIMP(statut='f',typ='R',val_min = 0.0,     fr=tr("Raideur en parallèle de la branche visqueuse.")),
            K3          =SIMP(statut='f',typ='R',val_min = 1.0E-08, fr=tr("Raideur dans la branche visqueuse.")),
            UNSUR_K1    =SIMP(statut='f',typ='R',val_min = 0.0,     fr=tr("Souplesse en série avec les 2 autres branches.")),
            UNSUR_K2    =SIMP(statut='f',typ='R',val_min = 1.0E-08, fr=tr("Souplesse en parallèle de la branche visqueuse.")),
            UNSUR_K3    =SIMP(statut='f',typ='R',val_min = 0.0,     fr=tr("Souplesse dans la branche visqueuse.")),
            C           =SIMP(statut='o',typ='R',val_min = 1.0E-08, fr=tr("'Raideur' de la partie visqueuse.")),
            PUIS_ALPHA  =SIMP(statut='o',typ='R',val_min = 1.0E-08, fr=tr("Puissance de la loi visqueuse ]0.0, 1.0]."),
                              val_max=1.0, defaut=0.5, ),
            ITER_INTE_MAXI =SIMP(statut='f',typ='I',defaut= 20 ),
            RESI_INTE_RELA =SIMP(statut='f',typ='R',defaut= 1.0E-6),
         ),
         RELA_EFFO_DEPL  =FACT(statut='f',max='**',
           NOEUD           =SIMP(statut='o',typ=no),
           SOUS_STRUC      =SIMP(statut='f',typ='TXM' ),
           NOM_CMP         =SIMP(statut='f',typ='TXM' ),
           RELATION        =SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster,formule) ),
         ),
         RELA_EFFO_VITE  =FACT(statut='f',max='**',
           NOEUD           =SIMP(statut='o',typ=no),
           SOUS_STRUC      =SIMP(statut='f',typ='TXM' ),
           NOM_CMP         =SIMP(statut='f',typ='TXM' ),
           RELATION        =SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster,formule) ),
         ),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
         IMPRESSION      =FACT(statut='f',
           regles=(EXCLUS('TOUT','NIVEAU','UNITE_DIS_VISC'),
                   PRESENT_ABSENT('UNITE_DIS_VISC','INST_FIN','INST_INIT',),),
           TOUT           =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           NIVEAU         =SIMP(statut='f',typ='TXM',into=("DEPL_LOC","VITE_LOC","FORC_LOC","TAUX_CHOC") ),
           INST_INIT      =SIMP(statut='f',typ='R' ),
           INST_FIN       =SIMP(statut='f',typ='R' ),
           UNITE_DIS_VISC =SIMP(statut='f',typ='I', fr=tr("Unité de sortie des variables internes pour les DIS_VISC")),
         ),


#-------------------------------------------------------------------
#        Catalogue commun SOLVEUR
         SOLVEUR         =C_SOLVEUR('DYNA_TRAN_MODAL'),
#-------------------------------------------------------------------

         TITRE           =SIMP(statut='f',typ='TXM',max='**'),
 )  ;
