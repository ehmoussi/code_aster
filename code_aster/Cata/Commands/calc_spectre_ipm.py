# coding=utf-8

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *

# ======================================================================
# ======================================================================
# COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
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


CALC_SPECTRE_IPM=MACRO(nom="CALC_SPECTRE_IPM",
                    op=OPS('Macro.calc_spectre_ipm_ops.calc_spectre_ipm_ops'),
                    sd_prod=table_sdaster,
                    reentrant='n', 
                    UIinfo={"groupes":("Post-traitements","Outils-métier",)},
                    fr="Calcul de spectre, post-traitement de séisme",
            MAILLAGE=SIMP(statut='f',typ=maillage_sdaster),  
            
            b_maillage=BLOC( condition = """exists("MAILLAGE")""",    
            EQUIPEMENT      =FACT(statut='o',max='**',
                NOM           =SIMP(statut='o',typ='TXM',),
                regles=(AU_MOINS_UN('GROUP_NO','NOEUD'),),
                GROUP_NO      =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
                NOEUD         =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
               
                RAPPORT_MASSE_TOTALE           = SIMP(statut='o',typ='R',max=1),
                COEF_MASS_EQUIP     = SIMP(statut='o', typ='R', max='**'),
                FREQ_SUPPORT        = SIMP(statut='o',typ='R', max=1),
                AMOR_SUPPORT        = SIMP(statut='o',typ='R',max=1),
                AMOR_EQUIP          = SIMP(statut='o',typ='R',max='**'),
                FREQ_EQUIP          = SIMP(statut='o', typ='R', max='**'),     
            ),),
            
            b_no_maillage=BLOC( condition = """not exists("MAILLAGE")""",    
            EQUIPEMENT      =FACT(statut='o',max='**',
                NOM           =SIMP(statut='o',typ='TXM',),
                NOEUD         =SIMP(statut='o',typ=no  ,validators=NoRepeat(),max='**'),   
                
                RAPPORT_MASSE_TOTALE           = SIMP(statut='o',typ='R',max=1),
                COEF_MASS_EQUIP     = SIMP(statut='o', typ='R', max='**'),
                FREQ_SUPPORT        = SIMP(statut='o',typ='R', max=1),
                AMOR_SUPPORT        = SIMP(statut='o',typ='R',max=1),
                AMOR_EQUIP          = SIMP(statut='o',typ='R',max='**'),
                FREQ_EQUIP          = SIMP(statut='o', typ='R', max='**'),     
            ),),

            CALCUL        =SIMP(statut='o',typ='TXM' ,into=('ABSOLU','RELATIF')),
            AMOR_SPEC     =SIMP(statut='o',typ='R',max='**'),
            LIST_INST     =SIMP(statut='f',typ=listr8_sdaster ),
            LIST_FREQ     =SIMP(statut='f',typ=listr8_sdaster ),
            FREQ          =SIMP(statut='f',typ='R',max='**'),
            NORME         =SIMP(statut='o',typ='R'),
            
            b_rela  =BLOC( condition = """equal_to("CALCUL", 'RELATIF')""",
            RESU          =FACT(statut='o',max=1,
                TABLE         =SIMP(statut='o',typ=table_sdaster),
                ACCE_Z        =SIMP(statut='o',typ=fonction_sdaster),
                ), 
            ),    
            b_abso  =BLOC( condition = """equal_to("CALCUL", 'ABSOLU')""",
            RESU          =FACT(statut='o',max=1,
                TABLE         =SIMP(statut='o',typ=table_sdaster),
                ),
            ),  
              
            TOLE_INIT = SIMP(statut='f',typ='R', max = 1, defaut= 1e-3),
            CORR_INIT = SIMP(statut='f',typ='TXM', defaut= "NON",into=("OUI","NON")),
)
