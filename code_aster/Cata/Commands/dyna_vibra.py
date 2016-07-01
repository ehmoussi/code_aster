# coding=utf-8

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2016  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: hassan.berro at edf.fr

# The product concept (data-structure) depends on the calculation type and basis
def dyna_vibra_sdprod(BASE_CALCUL, TYPE_CALCUL, MATR_RIGI,**args):
    if BASE_CALCUL == 'PHYS':
        if TYPE_CALCUL == 'TRAN'                   : return dyna_trans
        if (AsType(MATR_RIGI) == matr_asse_pres_c) : return acou_harmo
        return dyna_harmo
    else :
        if TYPE_CALCUL == 'TRAN': return tran_gene
        return harm_gene

DYNA_VIBRA = OPER (nom      = "DYNA_VIBRA",
                   op       = 29,
                   sd_prod  = dyna_vibra_sdprod,
                   reentrant='f',
                   fr       = tr("Calcul dynamique transitoire ou harminque, sur base physique ou généralisée"),
                   UIinfo   = {"groupes":("Résolution","Dynamique",)},

        # Calculation type and basis
        BASE_CALCUL     = SIMP(statut='o',typ='TXM',position='global',into=("PHYS","GENE"),),
        TYPE_CALCUL     = SIMP(statut='o',typ='TXM',position='global',into=("HARM","TRAN"),),

        # Physical model information
        b_phys_model    = BLOC(condition = "BASE_CALCUL=='PHYS'",
        MODELE          =     SIMP(statut='f',typ=modele_sdaster),
        CHAM_MATER      =     SIMP(statut='f',typ=cham_mater),
        CARA_ELEM       =     SIMP(statut='f',typ=cara_elem),),

        # Dynamic matrices (mass, stiffness, and damping)
        # Physical basis, transient calculation
        b_matr_tran_phys= BLOC(condition = "TYPE_CALCUL=='TRAN' and BASE_CALCUL=='PHYS'",
        MATR_MASS       =     SIMP(statut='o',typ=(matr_asse_depl_r),),
        MATR_RIGI       =     SIMP(statut='o',typ=(matr_asse_depl_r),),
        MATR_AMOR       =     SIMP(statut='f',typ=(matr_asse_depl_r),),),

        # Reduced (generalized) basis, transient calculation
        b_matr_tran_gene= BLOC(condition = "TYPE_CALCUL=='TRAN' and BASE_CALCUL=='GENE'",
        MATR_MASS       =     SIMP(statut='o',typ=(matr_asse_gene_r),),
        MATR_RIGI       =     SIMP(statut='o',typ=(matr_asse_gene_r),),
        MATR_AMOR       =     SIMP(statut='f',typ=(matr_asse_gene_r),),

        VITESSE_VARIABLE= SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON"),),

        b_variable      = BLOC(condition="VITESSE_VARIABLE=='OUI'",
        MATR_GYRO       =     SIMP(statut='o',typ=(matr_asse_gene_r),),
        VITE_ROTA       =     SIMP(statut='o',typ=(fonction_sdaster,formule),),
        MATR_RIGY       =     SIMP(statut='f',typ=(matr_asse_gene_r),),
        ACCE_ROTA       =     SIMP(statut='f',typ=(fonction_sdaster,formule),),),

        b_constante     = BLOC(condition="VITESSE_VARIABLE=='NON'",
        VITE_ROTA       =     SIMP(statut='o',typ='R',defaut=0.E0),),
        COUPLAGE_EDYOS  =     FACT(statut='f',max=1,
            PAS_TPS_EDYOS=        SIMP(statut='o',typ='R' ),),),

        # Physical basis, harmonic (spectral) calculation
        b_matr_harm_phys= BLOC(condition="TYPE_CALCUL == 'HARM' and BASE_CALCUL=='PHYS'",
        MATR_MASS       =     SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_pres_c),),
        MATR_RIGI       =     SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_depl_c,matr_asse_pres_c),),
        MATR_AMOR       =     SIMP(statut='f',typ=(matr_asse_depl_r,matr_asse_pres_c),),
        MATR_IMPE_PHI   =     SIMP(statut='f',typ=(matr_asse_depl_r),),),

        # Reduced basis, harmonic calculation
        b_matr_harm_gene= BLOC(condition="TYPE_CALCUL == 'HARM' and BASE_CALCUL=='GENE'",
        MATR_MASS       =     SIMP(statut='o',typ=(matr_asse_gene_r),),
        MATR_RIGI       =     SIMP(statut='o',typ=(matr_asse_gene_r,matr_asse_gene_c),),
        MATR_AMOR       =     SIMP(statut='f',typ=(matr_asse_gene_r),),
        MATR_IMPE_PHI   =     SIMP(statut='f',typ=(matr_asse_gene_r),),),

        # Calculation in continue-mode, obligatory keyword reuse with RESULTAT
        b_reuse_harm    = BLOC(condition = "reuse and TYPE_CALCUL == 'HARM'",
                               fr        = tr("en mode concept reentrant : RESULTAT obligatoire"),
        RESULTAT        =     SIMP(statut='o',typ=(dyna_harmo,harm_gene),),),

        # Modal damping
        AMOR_MODAL      = FACT(statut='f',
            AMOR_REDUIT =     SIMP(statut='f',typ='R',max='**'),
            LIST_AMOR   =     SIMP(statut='f',typ=listr8_sdaster),
            b_mode      =     BLOC(condition = "BASE_CALCUL == 'PHYS' and TYPE_CALCUL == 'TRAN'",
            MODE_MECA   =         SIMP(statut='o',typ=mode_meca),
            NB_MODE     =         SIMP(statut='f',typ='I'),),),

        # Harmonic calculation parameters
        b_param_harm    = BLOC(condition= "TYPE_CALCUL == 'HARM'",
                               regles   = (UN_PARMI('FREQ','LIST_FREQ'),
                                           EXCLUS('NOM_CHAM','TOUT_CHAM'),),
        FREQ            =     SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
        LIST_FREQ       =     SIMP(statut='f',typ=listr8_sdaster),
        NOM_CHAM        =     SIMP(statut='f',typ='TXM',validators=NoRepeat(),max=3,into=("DEPL","VITE","ACCE"),),
        TOUT_CHAM       =     SIMP(statut='f',typ='TXM',into=("OUI",),),),

        # Transient calculation parameters
        b_param_tran    = BLOC(condition = "TYPE_CALCUL == 'TRAN'",

        # 1. Integration schemes
        SCHEMA_TEMPS    =     FACT(statut='d',
            SCHEMA      =         SIMP(statut='o', typ='TXM', defaut="DIFF_CENTRE",
                                       into=("NEWMARK", "WILSON", "DIFF_CENTRE",
                                             "DEVOGE", "ADAPT_ORDRE1", "ADAPT_ORDRE2",
                                             "RUNGE_KUTTA_32", "RUNGE_KUTTA_54", "ITMI"),),
            b_newmark   =         BLOC(condition = "SCHEMA == 'NEWMARK'",
            BETA        =             SIMP(statut='f',typ='R',defaut= 0.25),
            GAMMA       =             SIMP(statut='f',typ='R',defaut= 0.5),),

            b_wilson    =         BLOC(condition = "SCHEMA == 'WILSON'",
            THETA       =             SIMP(statut='f',typ='R',defaut= 1.4),),

            b_rk_devo   =         BLOC(condition="SCHEMA=='RUNGE_KUTTA_54' or SCHEMA=='RUNGE_KUTTA_32' or SCHEMA=='DEVOGE'",
            TOLERANCE   =             SIMP(statut='f',typ='R',defaut= 1.E-5),
            ALPHA       =             SIMP(statut='f',typ='R',defaut= 0.),),

            b_adapt_ord =         BLOC(condition = "SCHEMA=='ADAPT_ORDRE1' or  SCHEMA=='ADAPT_ORDRE2'",
            VITE_MIN    =             SIMP(statut='f',typ='TXM',defaut="NORM",into=("MAXI","NORM"),),
            COEF_MULT_PAS=            SIMP(statut='f',typ='R',defaut= 1.1),
            COEF_DIVI_PAS=            SIMP(statut='f',typ='R',defaut= 1.3333334),
            PAS_LIMI_RELA=            SIMP(statut='f',typ='R',defaut= 1.E-6),
            NB_POIN_PERIODE=          SIMP(statut='f',typ='I',defaut= 50),),

            b_alladapt  =         BLOC(condition = "SCHEMA=='RUNGE_KUTTA_54' or SCHEMA=='RUNGE_KUTTA_32' or SCHEMA=='DEVOGE' \
                                                   or SCHEMA=='ADAPT_ORDRE1' or  SCHEMA=='ADAPT_ORDRE2'",
            PAS_MINI    =             SIMP(statut='f',typ='R'),
            PAS_MAXI    =             SIMP(statut='f',typ='R'),
            NMAX_ITER_PAS=            SIMP(statut='f',typ='I',defaut= 16),),           ),

        # 2. Time discretisation
        INCREMENT       =     FACT(statut='o', regles=(UN_PARMI('LIST_INST','PAS'),),
            LIST_INST   =         SIMP(statut='f',typ=listr8_sdaster),
            b_list      =         BLOC(condition = "LIST_INST != None", regles=(EXCLUS('INST_FIN','NUME_FIN'),),
            NUME_FIN    =             SIMP(statut='f',typ='I'),
            INST_FIN    =             SIMP(statut='f',typ='R'),),

            PAS         =         SIMP(statut='f',typ='R'),
            b_pas       =         BLOC(condition = "PAS != None",
            INST_INIT   =             SIMP(statut='f',typ='R'),
            INST_FIN    =             SIMP(statut='o',typ='R'),),

            VERI_PAS    =         SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON"),),),

       # 3. Initial state

        b_init_gene     = BLOC(condition="BASE_CALCUL == 'GENE'",
        ETAT_INIT       =     FACT(statut='f', max = 1,
                                               regles=(EXCLUS('RESULTAT','DEPL'), EXCLUS('RESULTAT','VITE'),),

            RESULTAT    =         SIMP(statut='f',typ=tran_gene),

            b_resu      =         BLOC(condition = "RESULTAT != NONE", regles = (EXCLUS('NUME_ORDRE','INST_INIT'),),
            NUME_ORDRE  =             SIMP(statut='f',typ='I'),
            INST_INIT   =             SIMP(statut='f',typ='R'),
            b_inst_init =             BLOC(condition = "INST_INIT != None",
            CRITERE     =                 SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU"),),
            b_prec_rela =                 BLOC(condition="(CRITERE=='RELATIF')",
            PRECISION   =                     SIMP(statut='f',typ='R',defaut= 1.E-6,),),
            b_prec_abso =                 BLOC(condition="(CRITERE=='ABSOLU')",
            PRECISION   =                     SIMP(statut='o',typ='R',),),),),

            DEPL        =         SIMP(statut='f',typ=vect_asse_gene),
            VITE        =         SIMP(statut='f',typ=vect_asse_gene),),),

        b_init_phys     = BLOC(condition="BASE_CALCUL == 'PHYS'",
        ETAT_INIT       =     FACT(statut='f', max = 1,
                                               regles=(AU_MOINS_UN('RESULTAT', 'DEPL', 'VITE', 'ACCE'),
                                                       PRESENT_ABSENT('RESULTAT', 'DEPL', 'VITE', 'ACCE'),),
            RESULTAT    =         SIMP(statut='f',typ=dyna_trans),

            b_resu      =         BLOC(condition = "RESULTAT != NONE", regles=( EXCLUS('NUME_ORDRE','INST_INIT'),),
            NUME_ORDRE  =             SIMP(statut='f',typ='I'),
            INST_INIT   =             SIMP(statut='f',typ='R'),
            b_inst_init =             BLOC(condition = "INST_INIT != None",
            CRITERE     =                 SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU"),),
            b_prec_rela =                 BLOC(condition="(CRITERE=='RELATIF')",
            PRECISION   =                     SIMP(statut='f',typ='R',defaut= 1.E-6,),),
            b_prec_abso =                 BLOC(condition="(CRITERE=='ABSOLU')",
            PRECISION   =                     SIMP(statut='o',typ='R',),),),),

            DEPL        =         SIMP(statut='f',typ=cham_no_sdaster),
            VITE        =         SIMP(statut='f',typ=cham_no_sdaster),
            ACCE        =         SIMP(statut='f',typ=cham_no_sdaster),),),

       # 4. Archiving parameters
        ARCHIVAGE       = FACT(statut='f', max=1, regles=(EXCLUS('LIST_INST','INST'), AU_MOINS_UN('LIST_INST','INST','PAS_ARCH')),
            PAS_ARCH    =     SIMP(statut='f',typ='I', defaut=1),

            LIST_INST   =     SIMP(statut='f',typ=(listr8_sdaster),),
            INST        =     SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),

            b_dlt_prec  =     BLOC(condition="BASE_CALCUL == 'PHYS' and (LIST_INST != None or INST != None)",
            CRITERE     =         SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU"),),
            b_prec_rela =         BLOC(condition="(CRITERE=='RELATIF')",
            PRECISION   =             SIMP(statut='f',typ='R',defaut= 1.E-6,),),
            b_prec_abso =         BLOC(condition="(CRITERE=='ABSOLU')",
            PRECISION   =             SIMP(statut='o',typ='R',),),),
            b_cham_exclu=     BLOC(condition="BASE_CALCUL == 'PHYS'",
            CHAM_EXCLU  =         SIMP(statut='f',typ='TXM',validators=NoRepeat(),max=2,into=("DEPL","VITE","ACCE"),),),),

        # 5. Energy calculation
        bloc_ener       = BLOC(condition="BASE_CALCUL == 'PHYS'",
        ENERGIE         =     FACT(statut='f',max=1,
        CALCUL          =         SIMP(statut='f',typ='TXM',into=("OUI",),defaut="OUI",),),),

        ),

##########################################################################################

#       Definition of the external excitation
#       A. Harmonic case
        b_excit_harm    = BLOC(condition="TYPE_CALCUL == 'HARM'",
        EXCIT           = FACT(statut='o',max='**',regles=(UN_PARMI('VECT_ASSE','VECT_ASSE_GENE','CHARGE'),
                                                           UN_PARMI('FONC_MULT','FONC_MULT_C','COEF_MULT','COEF_MULT_C'),),
            VECT_ASSE   =     SIMP(statut='f',typ=cham_no_sdaster),
            VECT_ASSE_GENE=   SIMP(statut='f',typ=vect_asse_gene),
            CHARGE      =     SIMP(statut='f',typ=char_meca),
            FONC_MULT_C =     SIMP(statut='f',typ=(fonction_c,formule_c),),
            COEF_MULT_C =     SIMP(statut='f',typ='C'),
            FONC_MULT   =     SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),),
            COEF_MULT   =     SIMP(statut='f',typ='R'),
            PHAS_DEG    =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            PUIS_PULS   =     SIMP(statut='f',typ='I',defaut= 0),),
        EXCIT_RESU      = FACT(statut='f',max='**',
            RESULTAT    =     SIMP(statut='o',typ=(dyna_harmo,harm_gene),),
            COEF_MULT_C =     SIMP(statut='o',typ='C'),),),

##########################################################################################

#       B. Transient case, physical basis
        b_excit_line_tran= BLOC(condition="TYPE_CALCUL == 'TRAN' and BASE_CALCUL == 'PHYS'",
        EXCIT            = FACT(statut='f',max='**',
                                regles=(UN_PARMI('CHARGE','VECT_ASSE'),
                                        EXCLUS('CHARGE','COEF_MULT'), EXCLUS('FONC_MULT','COEF_MULT'), EXCLUS('ACCE','COEF_MULT'),
                                        PRESENT_ABSENT('ACCE','FONC_MULT'), PRESENT_PRESENT('ACCE','VITE','DEPL'),),
            VECT_ASSE    =     SIMP(statut='f',typ=cham_no_sdaster),
            CHARGE       =     SIMP(statut='f',typ=char_meca),
            FONC_MULT    =     SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),),
            COEF_MULT    =     SIMP(statut='f',typ='R'),
            ACCE         =     SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),),
            VITE         =     SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),),
            DEPL         =     SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),),
            MULT_APPUI   =     SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON"),),
            b_mult_appui =     BLOC(condition = "MULT_APPUI == 'OUI'", regles=(EXCLUS('NOEUD','GROUP_NO'),),
            DIRECTION    =         SIMP(statut='f',typ='R',max='**'),
            NOEUD        =         SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
            GROUP_NO     =         SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),),),
        MODE_STAT        = SIMP(statut='f',typ=mode_meca),
        EXCIT_RESU       = FACT(statut='f',
            RESULTAT     =     SIMP(statut='o',typ=dyna_trans),
            COEF_MULT    =     SIMP(statut='o',typ='R'),),),

##########################################################################################

#       C. Transient case, reduced basis
#       C.1 Regular excitation (linear)
        b_excit_tran_mod = BLOC(condition="TYPE_CALCUL == 'TRAN' and BASE_CALCUL == 'GENE'",
                                regles=(PRESENT_ABSENT ('MODE_STAT'     ,'MODE_CORR'),
                                        PRESENT_PRESENT('BASE_ELAS_FLUI','NUME_VITE_FLUI'),),
        EXCIT            = FACT(statut='f',max='**',
                                regles=(UN_PARMI('FONC_MULT','COEF_MULT','ACCE'), UN_PARMI('VECT_ASSE_GENE','NUME_ORDRE',),
                                        PRESENT_PRESENT('ACCE','VITE','DEPL'), EXCLUS('MULT_APPUI','CORR_STAT'),
                                        PRESENT_PRESENT('MULT_APPUI','ACCE'),),
            VECT_ASSE_GENE=    SIMP(statut='f',typ=vect_asse_gene),
            NUME_ORDRE   =     SIMP(statut='f',typ='I'),
            FONC_MULT    =     SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),),
            COEF_MULT    =     SIMP(statut='f',typ='R'),
            ACCE         =     SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),),
            VITE         =     SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),),
            DEPL         =     SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),),

            MULT_APPUI   =     SIMP(statut='f',typ='TXM',into=("OUI",),),
            b_mult_appui =     BLOC(condition="MULT_APPUI == 'OUI'", regles=(EXCLUS('NOEUD','GROUP_NO'),),
            DIRECTION    =         SIMP(statut='f',typ='R',max='**'),
            NOEUD        =         SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
            GROUP_NO     =         SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),),

            CORR_STAT    =     SIMP(statut='f',typ='TXM',into=("OUI",),),
            b_corr_stat  =     BLOC(condition = "CORR_STAT == 'OUI'",
            D_FONC_DT    =         SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster,formule),),
            D_FONC_DT2   =         SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster,formule),),),),

        MODE_STAT        = SIMP(statut='f',typ=mode_meca),
        MODE_CORR        = SIMP(statut='f',typ=(mult_elas,mode_meca),),

        EXCIT_RESU       = FACT(statut='f',max='**',
            RESULTAT     =     SIMP(statut='o',typ=tran_gene),
            COEF_MULT    =     SIMP(statut='f',typ='R',defaut=1.0),),

#       C.2   Non-linear excitations
#       C.2.1 Chocs
        CHOC            = FACT(statut='f',max='**', regles=(UN_PARMI('MAILLE','GROUP_MA','NOEUD_1','GROUP_NO_1'),
                                                            EXCLUS('NOEUD_2','GROUP_NO_2'),
                                                            PRESENT_ABSENT('GROUP_MA','NOEUD_2','GROUP_NO_2'),
                                                            PRESENT_ABSENT('MAILLE','NOEUD_2','GROUP_NO_2'),
                                                            ),
            INTITULE    =     SIMP(statut='f',typ='TXM'),
            GROUP_MA    =     SIMP(statut='f',typ=grma,max='**'),
            MAILLE      =     SIMP(statut='f',typ=ma,max='**'),
            NOEUD_1     =     SIMP(statut='f',typ=no),
            NOEUD_2     =     SIMP(statut='f',typ=no),
            GROUP_NO_1  =     SIMP(statut='f',typ=grno),
            GROUP_NO_2  =     SIMP(statut='f',typ=grno),
            OBSTACLE    =     SIMP(statut='o',typ=table_fonction),
            ORIG_OBST   =     SIMP(statut='f',typ='R',min=3,max=3),
            NORM_OBST   =     SIMP(statut='o',typ='R',min=3,max=3),
            ANGL_VRIL   =     SIMP(statut='f',typ='R'),
            JEU         =     SIMP(statut='f',typ='R',defaut= 1.),
            DIST_1      =     SIMP(statut='f',typ='R',val_min=0.E+0),
            DIST_2      =     SIMP(statut='f',typ='R',val_min=0.E+0),
            SOUS_STRUC_1=     SIMP(statut='f',typ='TXM'),
            SOUS_STRUC_2=     SIMP(statut='f',typ='TXM'),
            REPERE      =     SIMP(statut='f',typ='TXM',defaut="GLOBAL"),
            RIGI_NOR    =     SIMP(statut='f',typ='R'),
            AMOR_NOR    =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            RIGI_TAN    =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            AMOR_TAN    =     SIMP(statut='f',typ='R'),
            FROTTEMENT  =     SIMP(statut='f',typ='TXM',defaut="NON",into=("NON","COULOMB","COULOMB_STAT_DYNA"),),
            b_coulomb   =     BLOC(condition="FROTTEMENT=='COULOMB'",
            COULOMB     =         SIMP(statut='o',typ='R'),),
            b_c_st_dyna =     BLOC(condition="FROTTEMENT=='COULOMB_STAT_DYNA'",
            COULOMB_STAT=         SIMP(statut='o',typ='R'),
            COULOMB_DYNA=         SIMP(statut='o',typ='R'),),),

        BASE_ELAS_FLUI  =     SIMP(statut='f',typ=melasflu_sdaster, max=1),
        NUME_VITE_FLUI  =     SIMP(statut='f',typ='I', max=1),

        b_choc          = BLOC(condition="CHOC!=None",
        VERI_CHOC       =     FACT(statut='f',
            STOP_CRITERE=         SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON"),),
            SEUIL       =         SIMP(statut='f',typ='R',defaut= 0.5),),),

#            Implicit or explicit treatment of choc non-linearities in integration
        b_nl_wet        =     BLOC(condition="BASE_ELAS_FLUI!=None and CHOC!=None",
        TRAITEMENT_NONL =         SIMP(statut='o',typ='TXM', defaut='IMPLICITE', into=('IMPLICITE',),),),
        b_nl_dry        =     BLOC(condition="BASE_ELAS_FLUI==None and CHOC!=None",
        TRAITEMENT_NONL =         SIMP(statut='o',typ='TXM', defaut='EXPLICITE', into=('IMPLICITE','EXPLICITE'),),),

#       C.2.2 Cracked rotor
        ROTOR_FISS      = FACT(statut='f',max='**', regles=(UN_PARMI('NOEUD_D','GROUP_NO_D'), EXCLUS('NOEUD_G','GROUP_NO_G'),
                                                            PRESENT_PRESENT('NOEUD_D','NOEUD_G'), PRESENT_PRESENT('GROUP_NO_D','GROUP_NO_G',),),
            ANGL_INIT   =     SIMP(statut='o',typ='R',defaut=0.E0),
            ANGL_ROTA   =     SIMP(statut='f',typ=(fonction_sdaster,formule),),
            NOEUD_G     =     SIMP(statut='f',typ=no),
            NOEUD_D     =     SIMP(statut='f',typ=no),
            GROUP_NO_G  =     SIMP(statut='f',typ=grno),
            GROUP_NO_D  =     SIMP(statut='f',typ=grno),
            K_PHI       =     SIMP(statut='o',typ=(fonction_sdaster,formule),),
            DK_DPHI     =     SIMP(statut='o',typ=(fonction_sdaster,formule),),),

#       C.2.3 Code coupling with EDYOS
        PALIER_EDYOS    = FACT(statut='f',max='**', regles=(PRESENT_ABSENT('UNITE','GROUP_NO'), PRESENT_ABSENT('UNITE','TYPE_EDYOS'),
                                                             EXCLUS('GROUP_NO','NOEUD'),),
            UNITE       =     SIMP(statut='f',typ='I',),
            GROUP_NO    =     SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
            NOEUD       =     SIMP(statut='f',typ=no),
            TYPE_EDYOS  =     SIMP(statut='f',typ='TXM',into=("PAPANL","PAFINL","PACONL","PAHYNL",),),),

#       C.2.4 Buckling
        FLAMBAGE        = FACT(statut='f',max='**',
                               regles=(UN_PARMI('NOEUD_1','GROUP_NO_1'), EXCLUS('NOEUD_2','GROUP_NO_2'),),
            NOEUD_1     =     SIMP(statut='f',typ=no),
            NOEUD_2     =     SIMP(statut='f',typ=no),
            GROUP_NO_1  =     SIMP(statut='f',typ=grno),
            GROUP_NO_2  =     SIMP(statut='f',typ=grno),
            OBSTACLE    =     SIMP(statut='o',typ=table_fonction),
            ORIG_OBST   =     SIMP(statut='f',typ='R',max='**'),
            NORM_OBST   =     SIMP(statut='o',typ='R',max='**'),
            ANGL_VRIL   =     SIMP(statut='f',typ='R'),
            JEU         =     SIMP(statut='f',typ='R',defaut= 1.),
            DIST_1      =     SIMP(statut='f',typ='R'),
            DIST_2      =     SIMP(statut='f',typ='R'),
            REPERE      =     SIMP(statut='f',typ='TXM',defaut="GLOBAL"),
            RIGI_NOR    =     SIMP(statut='f',typ='R'),
            FNOR_CRIT   =     SIMP(statut='f',typ='R'),
            FNOR_POST_FL=     SIMP(statut='f',typ='R'),
            RIGI_NOR_POST_FL= SIMP(statut='f',typ='R'),),

#       C.2.5 Anti-sismic disposition non linearity
        ANTI_SISM       = FACT(statut='f',max='**',
            regles=(UN_PARMI('NOEUD_1','GROUP_NO_1'), UN_PARMI('NOEUD_2','GROUP_NO_2'),),
            NOEUD_1     =     SIMP(statut='f',typ=no),
            NOEUD_2     =     SIMP(statut='f',typ=no),
            GROUP_NO_1  =     SIMP(statut='f',typ=grno),
            GROUP_NO_2  =     SIMP(statut='f',typ=grno),
            RIGI_K1     =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            RIGI_K2     =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            SEUIL_FX    =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            C           =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            PUIS_ALPHA  =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            DX_MAX      =     SIMP(statut='f',typ='R',defaut= 1.),),

#       C.2.6.1 Discrete viscous coupling, generalized Zener
        DIS_VISC        = FACT(statut='f',max='**', fr=tr("Loi pour un discret de type visqueux : Zener Généralisé."),
            regles=(UN_PARMI('NOEUD_1','GROUP_NO_1'), UN_PARMI('NOEUD_2','GROUP_NO_2'),
                    UN_PARMI('K1','UNSUR_K1'), UN_PARMI('K2','UNSUR_K2'), UN_PARMI('K3','UNSUR_K3'),),
            NOEUD_1     =     SIMP(statut='f',typ=no),
            NOEUD_2     =     SIMP(statut='f',typ=no),
            GROUP_NO_1  =     SIMP(statut='f',typ=grno),
            GROUP_NO_2  =     SIMP(statut='f',typ=grno),
            K1          =     SIMP(statut='f',typ='R',val_min = 1.0E-08, fr=tr("Raideur en série avec les 2 autres branches."),),
            K2          =     SIMP(statut='f',typ='R',val_min = 0.0,     fr=tr("Raideur en parallèle de la branche visqueuse."),),
            K3          =     SIMP(statut='f',typ='R',val_min = 1.0E-08, fr=tr("Raideur dans la branche visqueuse."),),
            UNSUR_K1    =     SIMP(statut='f',typ='R',val_min = 0.0,     fr=tr("Souplesse en série avec les 2 autres branches."),),
            UNSUR_K2    =     SIMP(statut='f',typ='R',val_min = 1.0E-08, fr=tr("Souplesse en parallèle de la branche visqueuse."),),
            UNSUR_K3    =     SIMP(statut='f',typ='R',val_min = 0.0,     fr=tr("Souplesse dans la branche visqueuse."),),
            C           =     SIMP(statut='o',typ='R',val_min = 1.0E-08, fr=tr("'Raideur' de la partie visqueuse."),),
            PUIS_ALPHA  =     SIMP(statut='o',typ='R',val_min = 1.0E-08, fr=tr("Puissance de la loi visqueuse ]0.0, 1.0]."),
                                   val_max=1.0, defaut=0.5,),
            ITER_INTE_MAXI=   SIMP(statut='f',typ='I',defaut= 20),
            RESI_INTE_RELA=   SIMP(statut='f',typ='R',defaut= 1.0E-6),),
#       C.2.6.2 Discrete nonlinear behavior
        DIS_ECRO_TRAC        = FACT(statut='f',max='**',fr=tr("Loi pour un discret avec écrouissage isotrope ."),
            regles=(UN_PARMI('NOEUD_1','GROUP_NO_1'), UN_PARMI('NOEUD_2','GROUP_NO_2'),),
            NOEUD_1     =   SIMP(statut='f',typ=no),
            NOEUD_2     =   SIMP(statut='f',typ=no),
            GROUP_NO_1  =   SIMP(statut='f',typ=grno),
            GROUP_NO_2  =   SIMP(statut='f',typ=grno),
            FX          =   SIMP(statut='o',typ=(fonction_sdaster), fr=tr("Comportement en fonction du déplacement relatif."),),
            ITER_INTE_MAXI = SIMP(statut='f',typ='I',defaut= 20),
            RESI_INTE_RELA = SIMP(statut='f',typ='R',defaut= 1.0E-6),),

#       C.2.7 Force displacement relationship non linearity
        RELA_EFFO_DEPL  = FACT(statut='f',max='**',
            regles=(UN_PARMI('NOEUD','GROUP_NO'),),
            NOEUD       =     SIMP(statut='f',typ=no),
            GROUP_NO    =     SIMP(statut='f',typ=grno),
            SOUS_STRUC  =     SIMP(statut='f',typ='TXM'),
            NOM_CMP     =     SIMP(statut='f',typ='TXM'),
            RELATION    =     SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster,formule),),),

#       C.2.8 Force velocity relationship non linearity
        RELA_EFFO_VITE  = FACT(statut='f',max='**',
            regles=(UN_PARMI('NOEUD','GROUP_NO'),),
            NOEUD       =     SIMP(statut='f',typ=no),
            GROUP_NO    =     SIMP(statut='f',typ=grno),
            SOUS_STRUC  =     SIMP(statut='f',typ='TXM'),
            NOM_CMP     =     SIMP(statut='f',typ='TXM'),
            RELATION    =     SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster,formule),),),
       ),

##########################################################################################

#       Solver parameters (common catalogue)
        b_sol_harm_gene = BLOC(condition = "BASE_CALCUL=='GENE' and TYPE_CALCUL=='HARM'",
                               fr=tr("Methode de resolution matrice generalisee"),
        SOLVEUR         =     C_SOLVEUR('DYNA_LINE_HARM','GENE'),),
        b_sol_harm_phys = BLOC(condition = "BASE_CALCUL=='PHYS' and TYPE_CALCUL=='HARM'",
                               fr=tr("Methode de resolution matrice sur ddl physique"),
        SOLVEUR         =     C_SOLVEUR('DYNA_LINE_HARM','PHYS'),),
        b_sol_line_tran = BLOC(condition = "BASE_CALCUL=='PHYS' and TYPE_CALCUL=='TRAN'",
        SOLVEUR         =     C_SOLVEUR('DYNA_LINE_TRAN'),),
        b_sol_tran_gene = BLOC(condition = "BASE_CALCUL=='GENE' and TYPE_CALCUL=='TRAN'",
        SOLVEUR         =     C_SOLVEUR('DYNA_TRAN_MODAL'),),

##########################################################################################

#       Diverse
        TITRE           = SIMP(statut='f',typ='TXM',max='**'),
        INFO            = SIMP(statut='f',typ='I',into=(1,2),),
        b_impression    = BLOC(condition = "BASE_CALCUL=='GENE' and TYPE_CALCUL=='TRAN'",
            IMPRESSION      = FACT(statut='f',
                regles=(PRESENT_ABSENT('UNITE_DIS_VISC','INST_FIN','INST_INIT','TOUT','NIVEAU'),
                        PRESENT_ABSENT('UNITE_DIS_ECRO_TRAC','INST_FIN','INST_INIT','TOUT','NIVEAU'),),
                TOUT           = SIMP(statut='f',typ='TXM',into=("OUI",),),
                NIVEAU         = SIMP(statut='f',typ='TXM',into=("DEPL_LOC","VITE_LOC","FORC_LOC","TAUX_CHOC"),),
                INST_INIT      = SIMP(statut='f',typ='R'),
                INST_FIN       = SIMP(statut='f',typ='R'),
                UNITE_DIS_VISC = SIMP(statut='f',typ='I', fr=tr("Unité de sortie des variables internes pour les DIS_VISC"),),
                UNITE_DIS_ECRO_TRAC = SIMP(statut='f',typ='I', fr=tr("Unité de sortie des variables internes pour les DIS_ECRO_TRAC"),),
            ),
        ),
)
