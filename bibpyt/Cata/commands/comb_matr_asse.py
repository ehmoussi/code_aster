# coding=utf-8

from Cata.Descriptor import *
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
# person_in_charge: nicolas.sellenet at edf.fr
def comb_matr_asse_prod(COMB_R,COMB_C,CALC_AMOR_GENE,**args):
  if COMB_C != None:
    type_mat = AsType(COMB_C[0]['MATR_ASSE'])
    if type_mat in  (matr_asse_depl_c,matr_asse_depl_r) : return matr_asse_depl_c
    if type_mat in  (matr_asse_gene_c,matr_asse_gene_r) : return matr_asse_gene_c
    if type_mat in  (matr_asse_temp_c,matr_asse_temp_r) : return matr_asse_temp_c
    if type_mat in  (matr_asse_pres_c,matr_asse_pres_r) : return matr_asse_pres_c
  elif COMB_R != None:
    type_mat = AsType(COMB_R[0]['MATR_ASSE'])
    if type_mat in  (matr_asse_depl_c,matr_asse_depl_r) : return matr_asse_depl_r
    if type_mat in  (matr_asse_temp_c,matr_asse_temp_r) : return matr_asse_temp_r
    if type_mat in  (matr_asse_pres_c,matr_asse_pres_r) : return matr_asse_pres_r
    if type_mat in  (matr_asse_gene_c,matr_asse_gene_r) : return matr_asse_gene_r
  elif CALC_AMOR_GENE != None: return matr_asse_gene_r
  raise AsException("type de concept resultat non prevu")

COMB_MATR_ASSE=OPER(nom="COMB_MATR_ASSE",op=  31,sd_prod=comb_matr_asse_prod,
                    fr=tr("Effectuer la combinaison linéaire de matrices assemblées"),
                    reentrant='f',
            UIinfo={"groupes":("Matrices et vecteurs",)},
         regles=(UN_PARMI('COMB_R','COMB_C','CALC_AMOR_GENE' ),),
         COMB_R          =FACT(statut='f',max='**',
           PARTIE          =SIMP(statut='f',typ='TXM',into=("REEL","IMAG") ),
           MATR_ASSE       =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_depl_c,matr_asse_temp_r,matr_asse_temp_c
                                                ,matr_asse_pres_r,matr_asse_pres_c,matr_asse_gene_r,matr_asse_gene_c ) ),
           COEF_R          =SIMP(statut='o',typ='R' ),
         ),
         COMB_C          =FACT(statut='f',max='**',
           regles=(UN_PARMI('COEF_R','COEF_C' ),),
           MATR_ASSE       =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_depl_c,matr_asse_temp_r,matr_asse_temp_c
                                                ,matr_asse_pres_r,matr_asse_pres_c,matr_asse_gene_r,matr_asse_gene_c ) ),
           COEF_R          =SIMP(statut='f',typ='R' ),
           COEF_C          =SIMP(statut='f',typ='C' ),
         ),
         CALC_AMOR_GENE   =FACT(statut='f',
           RIGI_GENE    = SIMP(statut='o', typ=matr_asse_gene_r),
           MASS_GENE    = SIMP(statut='o', typ=matr_asse_gene_r),
           regles=(UN_PARMI('AMOR_REDUIT','LIST_AMOR' ),),
           AMOR_REDUIT  = SIMP(statut='f',typ='R',max='**'),
           LIST_AMOR    = SIMP(statut='f',typ=listr8_sdaster ),
         ),
         SANS_CMP        =SIMP(statut='f',typ='TXM',into=("LAGR",) ),
)  ;
