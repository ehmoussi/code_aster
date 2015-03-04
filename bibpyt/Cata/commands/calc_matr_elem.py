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
def calc_matr_elem_prod(OPTION,**args):
  if OPTION == "RIGI_MECA"        : return matr_elem_depl_r
  if OPTION == "RIGI_FLUI_STRU"   : return matr_elem_depl_r
  if OPTION == "MASS_MECA"        : return matr_elem_depl_r
  if OPTION == "MASS_FLUI_STRU"   : return matr_elem_depl_r
  if OPTION == "RIGI_GEOM"        : return matr_elem_depl_r
  if OPTION == "RIGI_ROTA"        : return matr_elem_depl_r
  if OPTION == "MECA_GYRO"        : return matr_elem_depl_r
  if OPTION == "RIGI_GYRO"        : return matr_elem_depl_r
  if OPTION == "AMOR_MECA"        : return matr_elem_depl_r
  if OPTION == "IMPE_MECA"        : return matr_elem_depl_r
  if OPTION == "ONDE_FLUI"        : return matr_elem_depl_r
  if OPTION == "AMOR_MECA_ABSO"   : return matr_elem_depl_r
  if OPTION == "RIGI_MECA_HYST"   : return matr_elem_depl_c
  if OPTION == "RIGI_THER"        : return matr_elem_temp_r
  if OPTION == "MASS_MECA_DIAG"   : return matr_elem_depl_r
  if OPTION == "RIGI_ACOU"        : return matr_elem_pres_c
  if OPTION == "MASS_ACOU"        : return matr_elem_pres_c
  if OPTION == "AMOR_ACOU"        : return matr_elem_pres_c
  raise AsException("type de concept resultat non prevu")

CALC_MATR_ELEM=OPER(nom="CALC_MATR_ELEM",op=   9,sd_prod=calc_matr_elem_prod
                    ,fr=tr("Calcul des matrices élémentaires"),reentrant='n',
            UIinfo={"groupes":("Matrices et vecteurs",)},

         OPTION          =SIMP(statut='o',typ='TXM',
                               into=("RIGI_MECA","MASS_MECA","RIGI_GEOM",
                                     "AMOR_MECA","RIGI_THER","IMPE_MECA",
                                     "ONDE_FLUI","AMOR_MECA_ABSO","MASS_FLUI_STRU","RIGI_FLUI_STRU",
                                     "RIGI_ROTA","MECA_GYRO","RIGI_GYRO","MASS_MECA_DIAG","RIGI_ACOU",
                                     "MASS_ACOU","AMOR_ACOU","RIGI_MECA_HYST") ),
         MODELE            =SIMP(statut='o',typ=modele_sdaster ),

         # mots clés facultatifs que l'on a du mal à mettre dans les blocs
         # sans gener MACRO_MATR_ASSE :
         #------------------------------------------------------------------
         INST=SIMP(statut='f',typ='R',defaut= 0.E+0 ),


         b_rigi_meca = BLOC( condition = "OPTION=='RIGI_MECA'",
           CHAM_MATER      =SIMP(statut='f',typ=cham_mater ),
           CARA_ELEM       =SIMP(statut='f',typ=cara_elem ),
           MODE_FOURIER    =SIMP(statut='f',typ='I',defaut= 0 ),
           CHARGE          =SIMP(statut='f',typ=char_meca,validators=NoRepeat(),max='**' ),
         ),

         b_mass_meca   =BLOC(condition = "(OPTION=='MASS_MECA') or (OPTION=='MASS_MECA_DIAG')",
           CHAM_MATER      =SIMP(statut='f',typ=cham_mater ),
           CARA_ELEM       =SIMP(statut='f',typ=cara_elem ),
           CHARGE          =SIMP(statut='f',typ=char_meca,validators=NoRepeat(),max='**'),
         ),

        b_rigi_geom       =BLOC(condition = "OPTION=='RIGI_GEOM'",
            SIEF_ELGA         =SIMP(statut='o',typ=cham_elem ),
            CARA_ELEM         =SIMP(statut='f',typ=cara_elem ),
            STRX_ELGA         =SIMP(statut='f',typ=cham_elem ),
            DEPL              =SIMP(statut='f',typ=cham_no_sdaster),
            CHAM_MATER        =SIMP(statut='f',typ=cham_mater ),
            MODE_FOURIER      =SIMP(statut='f',typ='I',defaut= 0 ),
        ),

         b_rigi_rota       =BLOC(condition = "OPTION=='RIGI_ROTA'",
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CARA_ELEM         =SIMP(statut='f',typ=cara_elem ),
           CHARGE            =SIMP(statut='o',typ=char_meca,validators=NoRepeat(),max='**' ),
         ),

         b_meca_gyro = BLOC( condition = "OPTION=='MECA_GYRO'",
           CHAM_MATER      =SIMP(statut='o',typ=cham_mater ),
           CARA_ELEM       =SIMP(statut='f',typ=cara_elem ),
           CHARGE          =SIMP(statut='f',typ=char_meca,validators=NoRepeat(),max='**' ),
         ),

         b_rigi_gyro = BLOC( condition = "OPTION=='RIGI_GYRO'",
           CHAM_MATER      =SIMP(statut='o',typ=cham_mater ),
           CARA_ELEM       =SIMP(statut='f',typ=cara_elem ),
           CHARGE          =SIMP(statut='f',typ=char_meca,validators=NoRepeat(),max='**' ),
         ),

         b_amor_meca       =BLOC(condition = "OPTION=='AMOR_MECA'",
           regles=(AU_MOINS_UN('CARA_ELEM','RIGI_MECA'),
                   ENSEMBLE('RIGI_MECA','MASS_MECA','CHAM_MATER'), ),
           CARA_ELEM         =SIMP(statut='f',typ=cara_elem ),
           CHAM_MATER        =SIMP(statut='f',typ=cham_mater ),
           RIGI_MECA         =SIMP(statut='f',typ=matr_elem_depl_r ),
           MASS_MECA         =SIMP(statut='f',typ=matr_elem_depl_r ),
           CHARGE            =SIMP(statut='f',typ=char_meca,validators=NoRepeat(),max='**'),
         ),

         b_amor_meca_abso  =BLOC(condition = "OPTION=='AMOR_MECA_ABSO'",
           regles=(AU_MOINS_UN('CARA_ELEM','RIGI_MECA'),
                   ENSEMBLE('RIGI_MECA','MASS_MECA','CHAM_MATER'), ),
           CARA_ELEM         =SIMP(statut='f',typ=cara_elem ),
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           RIGI_MECA         =SIMP(statut='f',typ=matr_elem_depl_r ),
           MASS_MECA         =SIMP(statut='f',typ=matr_elem_depl_r ),
           CHARGE            =SIMP(statut='f',typ=char_meca,validators=NoRepeat(),max='**'),
         ),

         b_rigi_meca_hyst  =BLOC( condition = "OPTION=='RIGI_MECA_HYST'",
           CHARGE            =SIMP(statut='f',typ=char_meca ,validators=NoRepeat(),max='**' ),
           CHAM_MATER        =SIMP(statut='f',typ=cham_mater ),
           CARA_ELEM         =SIMP(statut='f',typ=cara_elem ),
           RIGI_MECA         =SIMP(statut='o',typ=matr_elem_depl_r ),
         ),

         b_rigi_ther       =BLOC(condition = "OPTION=='RIGI_THER'",
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CARA_ELEM         =SIMP(statut='f',typ=cara_elem ),
           MODE_FOURIER      =SIMP(statut='f',typ='I',defaut= 0 ),
           CHARGE            =SIMP(statut='f',typ=char_ther,validators=NoRepeat(),max='**' ),
         ),

         b_rigi_acou       =BLOC(condition = "OPTION=='RIGI_ACOU'",
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CHARGE            =SIMP(statut='f',typ=char_acou ,validators=NoRepeat(),max='**' ),
         ),

         b_mass_acou       =BLOC(condition = "(OPTION=='MASS_ACOU') or (OPTION=='AMOR_ACOU')",
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CHARGE            =SIMP(statut='f',typ=char_acou ,validators=NoRepeat(),max='**' ),
         ),

         b_rigi_flui       =BLOC(condition = "OPTION=='RIGI_FLUI_STRU'",
           CARA_ELEM         =SIMP(statut='o',typ=cara_elem ),
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CHARGE            =SIMP(statut='o',typ=char_meca ,validators=NoRepeat(),max='**' ),
         ),

         b_mass_flui       =BLOC(condition = "OPTION=='MASS_FLUI_STRU'",
           CARA_ELEM         =SIMP(statut='o',typ=cara_elem ),
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CHARGE            =SIMP(statut='o',typ=char_meca ,validators=NoRepeat(),max='**'),
         ),

         b_impe_meca       =BLOC(condition = "(OPTION=='IMPE_MECA') or (OPTION=='ONDE_FLUI')",
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CHARGE            =SIMP(statut='o',typ=char_meca,validators=NoRepeat(),max='**' ),
         ),
)  ;
