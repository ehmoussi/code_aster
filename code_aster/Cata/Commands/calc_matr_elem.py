# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: jacques.pellet at edf.fr
from ..Language.Syntax import *
from ..Language.DataStructure import *
from ..Commons import *


def calc_matr_elem_prod(OPTION,**args):
  if args.get('__all__'):
      return (matr_elem_depl_r, matr_elem_depl_c, matr_elem_temp_r,
              matr_elem_pres_c)

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
  if OPTION == "MASS_THER"        : return matr_elem_temp_r
  if OPTION == "MASS_MECA_DIAG"   : return matr_elem_depl_r
  if OPTION == "RIGI_ACOU"        : return matr_elem_pres_c
  if OPTION == "MASS_ACOU"        : return matr_elem_pres_c
  if OPTION == "AMOR_ACOU"        : return matr_elem_pres_c
  raise AsException("type de concept resultat non prevu")

CALC_MATR_ELEM=OPER(nom="CALC_MATR_ELEM",op=   9,sd_prod=calc_matr_elem_prod
                    ,fr=tr("Calcul des matrices élémentaires"),reentrant='n',

         OPTION          =SIMP(statut='o',typ='TXM',
                               into=("RIGI_MECA","MASS_MECA","RIGI_GEOM","MASS_THER",
                                     "AMOR_MECA","RIGI_THER","IMPE_MECA",
                                     "ONDE_FLUI","AMOR_MECA_ABSO","MASS_FLUI_STRU","RIGI_FLUI_STRU",
                                     "RIGI_ROTA","MECA_GYRO","RIGI_GYRO","MASS_MECA_DIAG","RIGI_ACOU",
                                     "MASS_ACOU","AMOR_ACOU","RIGI_MECA_HYST") ),
         MODELE            =SIMP(statut='o',typ=modele_sdaster ),

         # mots clés facultatifs que l'on a du mal à mettre dans les blocs
         # sans gener la commande ASSEMBLAGE
         #------------------------------------------------------------------
         INST=SIMP(statut='f',typ='R',defaut= 0.E+0 ),
         INCR_INST=SIMP(statut='f', typ='R', validators=NotEqualTo(0.)),

         b_rigi_meca = BLOC( condition = """equal_to("OPTION", 'RIGI_MECA')""",
           CHAM_MATER      =SIMP(statut='f',typ=cham_mater ),
           CARA_ELEM       =SIMP(statut='f',typ=cara_elem ),
           MODE_FOURIER    =SIMP(statut='f',typ='I',defaut= 0 ),
           CHARGE          =SIMP(statut='f',typ=char_meca,validators=NoRepeat(),max='**' ),
           CALC_ELEM_MODELE=SIMP(statut='f',typ='TXM', into=('OUI','NON',), defaut='OUI',
                                 fr=tr("Calcul de la matrice de rigidité hors modèle")),
         ),

         b_mass_meca   =BLOC(condition = """(equal_to("OPTION", 'MASS_MECA')) or (equal_to("OPTION", 'MASS_MECA_DIAG'))""",
           CHAM_MATER      =SIMP(statut='f',typ=cham_mater ),
           CARA_ELEM       =SIMP(statut='f',typ=cara_elem ),
           CHARGE          =SIMP(statut='f',typ=char_meca,validators=NoRepeat(),max='**'),
         ),

        b_rigi_geom       =BLOC(condition = """equal_to("OPTION", 'RIGI_GEOM')""",
            SIEF_ELGA         =SIMP(statut='o',typ=cham_elem ),
            CARA_ELEM         =SIMP(statut='f',typ=cara_elem ),
            STRX_ELGA         =SIMP(statut='f',typ=cham_elem ),
            DEPL              =SIMP(statut='f',typ=cham_no_sdaster),
            CHAM_MATER        =SIMP(statut='f',typ=cham_mater ),
            MODE_FOURIER      =SIMP(statut='f',typ='I',defaut= 0 ),
        ),

         b_rigi_rota       =BLOC(condition = """equal_to("OPTION", 'RIGI_ROTA')""",
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CARA_ELEM         =SIMP(statut='f',typ=cara_elem ),
           CHARGE            =SIMP(statut='o',typ=char_meca,validators=NoRepeat(),max='**' ),
         ),

         b_meca_gyro = BLOC( condition = """equal_to("OPTION", 'MECA_GYRO')""",
           CHAM_MATER      =SIMP(statut='o',typ=cham_mater ),
           CARA_ELEM       =SIMP(statut='f',typ=cara_elem ),
           CHARGE          =SIMP(statut='f',typ=char_meca,validators=NoRepeat(),max='**' ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='c',typ=ma,validators=NoRepeat(),max='**'),
         ),

         b_rigi_gyro = BLOC( condition = """equal_to("OPTION", 'RIGI_GYRO')""",
           CHAM_MATER      =SIMP(statut='o',typ=cham_mater ),
           CARA_ELEM       =SIMP(statut='f',typ=cara_elem ),
           CHARGE          =SIMP(statut='f',typ=char_meca,validators=NoRepeat(),max='**' ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='c',typ=ma,validators=NoRepeat(),max='**'),
         ),

         b_amor_meca       =BLOC(condition = """equal_to("OPTION", 'AMOR_MECA')""",
           regles=(AU_MOINS_UN('CARA_ELEM','RIGI_MECA'),
                   ENSEMBLE('RIGI_MECA','CHAM_MATER'), ),
           CARA_ELEM         =SIMP(statut='f',typ=cara_elem ),
           CHAM_MATER        =SIMP(statut='f',typ=cham_mater ),
           RIGI_MECA         =SIMP(statut='f',typ=matr_elem_depl_r ),
           MASS_MECA         =SIMP(statut='f',typ=matr_elem_depl_r ),
           CHARGE            =SIMP(statut='f',typ=char_meca,validators=NoRepeat(),max='**'),
         ),

         b_rigi_meca_hyst  =BLOC( condition = """equal_to("OPTION", 'RIGI_MECA_HYST')""",
           CHARGE            =SIMP(statut='f',typ=char_meca ,validators=NoRepeat(),max='**' ),
           CHAM_MATER        =SIMP(statut='f',typ=cham_mater ),
           CARA_ELEM         =SIMP(statut='f',typ=cara_elem ),
           RIGI_MECA         =SIMP(statut='o',typ=matr_elem_depl_r ),
         ),

         b_rigi_ther       =BLOC(condition = """equal_to("OPTION", 'RIGI_THER')""",
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CARA_ELEM         =SIMP(statut='f',typ=cara_elem ),
           MODE_FOURIER      =SIMP(statut='f',typ='I',defaut= 0 ),
           CHARGE            =SIMP(statut='f',typ=char_ther,validators=NoRepeat(),max='**' ),
         ),

         b_mass_ther       =BLOC(condition = """equal_to("OPTION", 'MASS_THER')""",
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CARA_ELEM         =SIMP(statut='f',typ=cara_elem ),
           MODE_FOURIER      =SIMP(statut='f',typ='I',defaut= 0 ),
         ),

         b_rigi_acou       =BLOC(condition = """equal_to("OPTION", 'RIGI_ACOU')""",
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CHARGE            =SIMP(statut='f',typ=char_acou ,validators=NoRepeat(),max='**' ),
         ),

         b_mass_acou       =BLOC(condition = """(equal_to("OPTION", 'MASS_ACOU')) or (equal_to("OPTION", 'AMOR_ACOU'))""",
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CHARGE            =SIMP(statut='f',typ=char_acou ,validators=NoRepeat(),max='**' ),
         ),

         b_rigi_flui       =BLOC(condition = """equal_to("OPTION", 'RIGI_FLUI_STRU')""",
           CARA_ELEM         =SIMP(statut='o',typ=cara_elem ),
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CHARGE            =SIMP(statut='o',typ=char_meca ,validators=NoRepeat(),max='**' ),
         ),

         b_mass_flui       =BLOC(condition = """equal_to("OPTION", 'MASS_FLUI_STRU')""",
           CARA_ELEM         =SIMP(statut='o',typ=cara_elem ),
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CHARGE            =SIMP(statut='o',typ=char_meca ,validators=NoRepeat(),max='**'),
         ),

         b_impe_meca       =BLOC(condition = """(equal_to("OPTION", 'IMPE_MECA')) or (equal_to("OPTION", 'ONDE_FLUI'))""",
           CHAM_MATER        =SIMP(statut='o',typ=cham_mater ),
           CHARGE            =SIMP(statut='o',typ=char_meca,validators=NoRepeat(),max='**' ),
         ),
)  ;
