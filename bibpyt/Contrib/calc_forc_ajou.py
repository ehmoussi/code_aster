# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# person_in_charge: nicolas.greffet at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


CALC_FORC_AJOU=OPER(nom="CALC_FORC_AJOU",op=199,sd_prod=vect_asse_gene,
                   fr=tr("Calculer l'effet de surpression hydrodynamique due au mouvement d'entrainement de la structure"
                         " en analyse sismique"),
                   reentrant ='n',

        regles=(EXCLUS('MODE_MECA','MODELE_GENE'),
                PRESENT_PRESENT( 'MODELE_GENE','NUME_DDL_GENE'),
                UN_PARMI('MONO_APPUI', 'NOEUD','GROUP_NO'),
                UN_PARMI('MONO_APPUI','MODE_STAT')),

         MODELE_FLUIDE   =SIMP(statut='o',typ=modele_sdaster ),
         MODELE_INTERFACE=SIMP(statut='o',typ=modele_sdaster ),
         CHAM_MATER      =SIMP(statut='o',typ=cham_mater ),
         CHARGE          =SIMP(statut='o',typ=char_ther, max=1 ),
         MODE_MECA       =SIMP(statut='f',typ=mode_meca ),
         MODELE_GENE     =SIMP(statut='f',typ=modele_gene ),
         NUME_DDL_GENE   =SIMP(statut='f',typ=nume_ddl_gene ),
         DIST_REFE       =SIMP(statut='f',typ='R',defaut= 1.E-2 ),
         AVEC_MODE_STAT  =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),
         NUME_MODE_MECA  =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
         POTENTIEL       =SIMP(statut='f',typ=evol_ther ),
         NOEUD_DOUBLE    =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),

         DIRECTION       =SIMP(statut='o',typ='R',max=3),
         MONO_APPUI      =SIMP(statut='f',typ='TXM',into=("OUI",),),
         NOEUD           =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
         GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
         MODE_STAT       =SIMP(statut='f',typ=mode_meca,),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2 ) ),
#-------------------------------------------------------------------
#        Catalogue commun SOLVEUR
         SOLVEUR         =C_SOLVEUR('CALC_FORC_AJOU'),
#-------------------------------------------------------------------
     ) ;
