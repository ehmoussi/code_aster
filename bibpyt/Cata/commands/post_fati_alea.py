# coding=utf-8

from Cata.Syntax import *
from Cata.DataStructure import *
from Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
POST_FATI_ALEA=OPER(nom="POST_FATI_ALEA",op=170,sd_prod=table_sdaster,reentrant='n',
            UIinfo={"groupes":("Post-traitements","Rupture",)},
                    fr=tr("Calculer le dommage de fatigue subi par une structure soumise à une sollicitation de type aléatoire"),
         regles=(ENSEMBLE('MOMENT_SPEC_0','MOMENT_SPEC_2'),
                 PRESENT_PRESENT( 'MOMENT_SPEC_4','MOMENT_SPEC_0'),
                 UN_PARMI('TABL_POST_ALEA','MOMENT_SPEC_0'), ),
         MOMENT_SPEC_0   =SIMP(statut='f',typ='R'),  
         MOMENT_SPEC_2   =SIMP(statut='f',typ='R'),  
         MOMENT_SPEC_4   =SIMP(statut='f',typ='R'),  
         TABL_POST_ALEA  =SIMP(statut='f',typ=table_sdaster),
         COMPTAGE        =SIMP(statut='o',typ='TXM',into=("PIC","NIVEAU")),
         DUREE           =SIMP(statut='f',typ='R',defaut= 1.),  
         CORR_KE         =SIMP(statut='f',typ='TXM',into=("RCCM",)),
         DOMMAGE         =SIMP(statut='o',typ='TXM',into=("WOHLER",)),
         MATER           =SIMP(statut='o',typ=mater_sdaster),
         TITRE           =SIMP(statut='f',typ='TXM',max='**'),  
)  ;
