# coding=utf-8

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2015  EDF R&D                  WWW.CODE-ASTER.ORG
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

def dyna_iss_vari_prod(self, FONC_SIGNAL,**args):
   if FONC_SIGNAL !=None :
       return tran_gene
   else:
      return  interspectre
   raise AsException("type de concept resultat non prevu")

DYNA_ISS_VARI=MACRO(nom="DYNA_ISS_VARI",
                    op=OPS('Macro.dyna_iss_vari_ops.dyna_iss_vari_ops'),
                    sd_prod=dyna_iss_vari_prod,
                    fr=tr("Calcul du spectre de réponse ou de la reponse temporelle "
                         "sismique incoherente par decomposition spectrale"),
                    reentrant='n',
                    UIinfo={"groupes":("Outils-métier",)},
         regles=(UN_PARMI('FONC_SIGNAL','NB_FREQ'),),
         FONC_SIGNAL     =SIMP(statut='f',typ=(fonction_sdaster) ),
         NB_FREQ       =SIMP(statut='f',typ='I' ),
         NOM_CMP       =SIMP(statut='o',typ='TXM',into=("DX","DY","DZ") ),
         PRECISION     =SIMP(statut='f',typ='R',defaut=0.999 ),
         ISSF          =SIMP(statut='f',typ='TXM',into=("OUI","NON",),defaut="NON"),
         INTERF           =FACT(statut='o',
              GROUP_NO_INTERF =SIMP(statut='o',typ=grno,),
              MODE_INTERF  =SIMP(statut='o',typ='TXM',into=("CORP_RIGI","TOUT","QUELCONQUE")),
         ),
         MATR_COHE       =FACT(statut='o',
              TYPE = SIMP(statut='o',typ='TXM' , into=("MITA_LUCO","ABRAHAMSON")   ),            
              b_type_coh = BLOC(condition="TYPE=='MITA_LUCO' ",
                 VITE_ONDE       =SIMP(statut='o',typ='R', val_min=0.0 ),
                 PARA_ALPHA     =SIMP(statut='f',typ='R',defaut=0.1),),
         ),
#        LIST_FREQ        =SIMP(statut='o',typ='liste' ),
         UNITE_RESU_FORC = SIMP(statut='f',typ='I',defaut=33),
         UNITE_RESU_IMPE  = SIMP(statut='f',typ='I',defaut=32),
         TYPE             = SIMP(statut='f',typ='TXM', into=("BINAIRE","ASCII"), defaut="ASCII"),
#         NOM_CHAM        =SIMP(statut='f',typ='TXM',into=("DEPL","VITE","ACCE") , validators=NoRepeat(),max=3,defaut="DEPL" ),
#
         MATR_GENE         = FACT(statut='o',
            MATR_MASS     = SIMP(statut='o',typ=(matr_asse_gene_r ) ),
            MATR_RIGI     = SIMP(statut='o',typ=(matr_asse_gene_r,matr_asse_gene_c ) ),
            MATR_AMOR     = SIMP(statut='f',typ=(matr_asse_gene_r,matr_asse_gene_c ) ),
         ),
#
        INFO           =SIMP(statut='f',typ='I' ,defaut=1,into=( 1 , 2)),
#
         b_type_trans = BLOC(condition="FONC_SIGNAL !=None",
                        FREQ_MAX       =SIMP(statut='f',typ='R' ),
                        FREQ_PAS       =SIMP(statut='f',typ='R' ),
                        regles=( ENSEMBLE('FREQ_MAX','FREQ_PAS'),  )

                        ),

        b_type_spec = BLOC(condition="NB_FREQ != None",
                       FREQ_INIT       =SIMP(statut='o',typ='R' ),
                       FREQ_PAS     =SIMP(statut='o',typ='R' ),
                       OPTION        = SIMP(statut='f',typ='TXM',into=("TOUT","DIAG"),defaut="TOUT"),
                       ),


         )  ;
