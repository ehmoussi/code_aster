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
# person_in_charge: irmela.zentner at edf.fr

GENE_ACCE_SEISME=MACRO(nom = "GENE_ACCE_SEISME",
                     op = OPS('Macro.gene_acce_seisme_ops.gene_acce_seisme_ops'),
                     sd_prod = table_fonction,
                     fr = tr("Generation d'accelerogrammes sismiques "),
                     reentrant = 'n',
                     UIinfo = {"groupes":("Fonctions","Dynamique",)},

         regles=(UN_PARMI('DSP','SPEC_MEDIANE' ,'SPEC_MOYENNE','SPEC_UNIQUE','SPEC_FRACTILE'),
                 EXCLUS('MATR_COHE','COEF_CORR')),

         INIT_ALEA       =SIMP(statut='f',typ='I'),
         TITRE           =SIMP(statut='f',typ='TXM',max='**'),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
         PAS_INST        =SIMP(statut='o',typ='R' ),
         NB_POIN           =SIMP(statut='f',typ='I',fr=tr("nombre de points") ),
         PESANTEUR         =SIMP(statut='o', typ='R', fr=tr("constante de normalisation de ACCE_MAX, ECART_TYPE et INTE_ARIAS (g) ou le spectre") ),
         DUREE_PHASE_FORTE =SIMP(statut='o',typ='R',fr=tr("durée phase forte du signal") ),
         NB_TIRAGE         =SIMP(statut='f',typ='I',defaut= 1, val_min=1, fr=tr("nombre accelerogrammes") ),
         FREQ_CORNER       =SIMP(statut='f',typ='R', val_min=0.0, fr=tr("frequence du filtre frequentiel: corner frequency")),
         FREQ_FILTRE       =SIMP(statut='f',typ='R', defaut= 0.0, val_min=0.0, fr=tr("frequence du filtre temporel")),
         FREQ_PENTE        =SIMP(statut='f',typ='R',  fr=tr("pente pour l'evolution de la frequence centrale")),
         COEF_CORR         =SIMP(statut='f',typ='R',val_min=-1.0, val_max=1.0, fr=tr("Correlation coefficient for horizontal motion")),
              a_ratio   = BLOC(condition="COEF_CORR != None and SPEC_FRACTILE != None",
              RATIO_HV     = SIMP(statut='f',typ='R',  val_min=0.0,  fr=tr("Ratio H/V pour le spectre vertical")), ),
         MATR_COHE       = FACT(statut='f',
             MAILLAGE    = SIMP(statut='o',typ=maillage_sdaster),
             GROUP_NO_INTERF = SIMP(statut='o',typ=grno,),
             TYPE = SIMP(statut='o',typ='TXM' , into=("MITA_LUCO","ABRAHAMSON", "ABRA_ROCHER", "ABRA_SOLMOYEN")   ),            
             b_type_coh = BLOC(condition="TYPE=='MITA_LUCO' ",
                       VITE_ONDE       =SIMP(statut='o',typ='R',val_min=0.0 ),
                        PARA_ALPHA     =SIMP(statut='f',typ='R',defaut=0.1  ),  ),
        ),
         DSP        = FACT(statut='f',max=1,
            AMOR_REDUIT   =SIMP(statut='o',typ='R'),
            FREQ_FOND     =SIMP(statut='o',typ='R', fr=tr("frequence centrale")),
#           FREQ_PENTE    =SIMP(statut='f',typ='R',  fr=tr("pente pour l'evolution de la frequence centrale")),
        ),
         SPEC_MEDIANE    = FACT(statut='f',max=1,
            regles=(ENSEMBLE('ERRE_ZPA','ERRE_MAX','ERRE_RMS'),EXCLUS('FREQ_PAS','LIST_FREQ'),),
            SPEC_OSCI     =SIMP(statut='o',typ=(fonction_sdaster),),
            AMOR_REDUIT   =SIMP(statut='o', typ='R', val_min=0.00001, val_max=1.),
            FREQ_PAS      =SIMP(statut='f',typ='R' , fr=tr("pas")),
            LIST_FREQ     =SIMP(statut='f', typ=listr8_sdaster ),
            NB_ITER       =SIMP(statut='f',typ='I' ,val_min=0,fr=tr("nombre d'iterations pour fitter le spectre")  ,),
            ERRE_ZPA      =SIMP(statut='f',typ='R' ,defaut=(1.,0.2), min=1,max=2,  fr=tr("coef et erreur maxi ZPA"),),
            ERRE_MAX      =SIMP(statut='f',typ='R' ,defaut=(0.5,0.2), min=1,max=2,  fr=tr("coef et erreur maxi global"),),
            ERRE_RMS      =SIMP(statut='f',typ='R' ,defaut=(0.5,0.2), min=1,max=2,  fr=tr("coef et erreur maxi rms"),),
            METHODE       =SIMP(statut='f',typ='TXM',defaut="HARMO",into=("NIGAM","HARMO") ),
        ),
         SPEC_MOYENNE    = FACT(statut='f',max=1,
            regles=(ENSEMBLE('ERRE_ZPA','ERRE_MAX','ERRE_RMS'),EXCLUS('FREQ_PAS','LIST_FREQ'),),
            SPEC_OSCI     =SIMP(statut='o',typ=(fonction_sdaster),),
            AMOR_REDUIT   =SIMP(statut='o', typ='R', val_min=0.00001, val_max=1.),
            FREQ_PAS      =SIMP(statut='f',typ='R' , fr=tr("pas")),
            LIST_FREQ     =SIMP(statut='f', typ=listr8_sdaster ),
            NB_ITER       =SIMP(statut='f',typ='I' ,val_min=0,fr=tr("nombre d'iterations pour fitter le spectre")  ,),
            ERRE_ZPA      =SIMP(statut='f',typ='R' ,defaut=(1.,0.2), min=1,max=2,  fr=tr("coef et erreur maxi ZPA"),),
            ERRE_MAX      =SIMP(statut='f',typ='R' ,defaut=(0.5,0.2), min=1,max=2,  fr=tr("coef et erreur maxi global"),),
            ERRE_RMS      =SIMP(statut='f',typ='R' ,defaut=(0.5,0.2), min=1,max=2,  fr=tr("coef et erreur maxi rms"),),
            METHODE       =SIMP(statut='f',typ='TXM',defaut="HARMO",into=("NIGAM","HARMO") ),
        ),
         SPEC_UNIQUE    = FACT(statut='f',max=1,
            regles=(ENSEMBLE('ERRE_ZPA','ERRE_MAX','ERRE_RMS'),EXCLUS('FREQ_PAS','LIST_FREQ'),),
            ERRE_ZPA      =SIMP(statut='f',typ='R' ,defaut=(1.,0.2), min=1,max=2,  fr=tr("coef et erreur maxi ZPA"),),
            ERRE_MAX      =SIMP(statut='f',typ='R' ,defaut=(0.5,0.2), min=1,max=2,  fr=tr("coef et erreur maxi global"),),
            ERRE_RMS      =SIMP(statut='f',typ='R' ,defaut=(0.5,0.2), min=1,max=2,  fr=tr("coef et erreur maxi rms"),),
            SPEC_OSCI     =SIMP(statut='o',typ=(fonction_sdaster),),
            AMOR_REDUIT   =SIMP(statut='o', typ='R', val_min=0.00001, val_max=1.),
            FREQ_PAS      =SIMP(statut='f',typ='R' , fr=tr("pas")),
            LIST_FREQ     =SIMP(statut='f', typ=listr8_sdaster ),
            NB_ITER       =SIMP(statut='f',typ='I' , val_min=0,fr=tr("nombre d'iterations pour fitter le spectre") ,),
            METHODE       =SIMP(statut='f',typ='TXM',defaut="HARMO",into=("NIGAM","HARMO") ),
        ),
#
         SPEC_FRACTILE    = FACT(statut='f',max=1,
            regles=(EXCLUS('FREQ_PAS','LIST_FREQ'),),
            SPEC_OSCI       =SIMP(statut='o',typ=(fonction_sdaster),),
            SPEC_1_SIGMA    =SIMP(statut='o',typ=(fonction_sdaster),),
            AMOR_REDUIT     =SIMP(statut='o', typ='R', val_min=0.00001, val_max=1.),
            FREQ_PAS        =SIMP(statut='f',typ='R' , fr=tr("pas")),
            LIST_FREQ       =SIMP(statut='f', typ=listr8_sdaster ),
#            FREQ_PENTE      =SIMP(statut='f',typ='R',  fr=tr("pente pour l'evolution de la frequence centrale")),
        ),

         a_type_dsp   = BLOC(condition='DSP !=None' ,
         MODULATION      = FACT(statut='o',max=1,
            regles=(EXCLUS('ACCE_MAX','INTE_ARIAS','ECART_TYPE'),),
            TYPE         = SIMP(statut='o',typ='TXM' , into=("GAMMA","JENNINGS_HOUSNER","CONSTANT")),
            ACCE_MAX     = SIMP(statut='f',typ='R',fr=tr("PGA: acceleration max au sol (g)") ),
            ECART_TYPE   = SIMP(statut='f',typ='R',fr=tr("ecart-type") ),
            INTE_ARIAS   = SIMP(statut='f',typ='R',fr=tr("intensite d'Arias") ),
            a_type_mod   = BLOC(condition="TYPE=='GAMMA' ",
                           INST_INI     = SIMP(statut='o',typ='R',fr=tr("instant debut phase forte") ),
                            ),
            ),),

        b_type_spec   = BLOC(condition='DSP == None',
        MODULATION      = FACT(statut='o',max=1,
            TYPE        = SIMP(statut='o',typ='TXM' , into=("GAMMA","JENNINGS_HOUSNER","CONSTANT")),
            b_type_mod  = BLOC(condition="TYPE=='GAMMA' ",
                           INST_INI     = SIMP(statut='o',typ='R',fr=tr("instant debut phase forte") ),
                            ),
            ),),
)
