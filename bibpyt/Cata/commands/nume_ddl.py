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
# person_in_charge: jacques.pellet at edf.fr
NUME_DDL=OPER(nom="NUME_DDL",op=11,sd_prod=nume_ddl_sdaster,reentrant='n',
            UIinfo={"groupes":("Matrices et vecteurs",)},
              fr=tr("Etablissement de la numérotation des ddl avec ou sans renumérotation et du stockage de la matrice"),
                  regles=(UN_PARMI('MATR_RIGI','MODELE'),),
         MATR_RIGI       =SIMP(statut='f',validators=NoRepeat(),max=100,
                               typ=(matr_elem_depl_r ,matr_elem_depl_c,matr_elem_temp_r ,matr_elem_pres_c) ),
         MODELE          =SIMP(statut='f',typ=modele_sdaster ),
         b_modele        =BLOC(condition = "MODELE != None",
           CHARGE     =SIMP(statut='f',validators=NoRepeat(),max='**',typ=(char_meca,char_ther,char_acou, ),),
         ),
         METHODE         =SIMP(statut='f',typ='TXM',defaut="MULT_FRONT",into=("MULT_FRONT","LDLT","GCPC","PETSC","MUMPS") ),
         b_mult_front    =BLOC(condition="METHODE=='MULT_FRONT'",fr=tr("paramètres associés à la méthode multifrontale"),
           RENUM           =SIMP(statut='f',typ='TXM',into=("MD","MDA","METIS"),defaut="METIS" ),
         ),
         b_ldlt          =BLOC(condition="METHODE=='LDLT'",fr=tr("paramètres associés à la méthode LDLT"),
           RENUM           =SIMP(statut='f',typ='TXM',into=("RCMK","SANS"),defaut="RCMK"  ),
         ),
         b_mumps        =BLOC(condition = "METHODE == 'MUMPS' ",fr=tr("Paramètres de la méthode MUMPS"),
           RENUM        =SIMP(statut='f',typ='TXM',defaut="AUTO",into=("AMD","AMF","PORD","METIS","QAMD","SCOTCH","AUTO")),
         ),
         b_gcpc          =BLOC(condition="METHODE=='GCPC' or METHODE=='PETSC'",fr=tr("paramètres associés à la GCPC ou PETSc"),
           RENUM           =SIMP(statut='f',typ='TXM',into=("RCMK","SANS"),defaut="RCMK"  ),
         ),
         INFO            =SIMP(statut='f',typ='I',into=(1,2)),
)  ;
