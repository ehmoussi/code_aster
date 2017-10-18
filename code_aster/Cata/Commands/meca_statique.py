# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


MECA_STATIQUE=OPER(nom="MECA_STATIQUE",op=46,sd_prod=evol_elas,
                   fr=tr("Résoudre un problème de mécanique statique linéaire"),reentrant='f',
         regles=(EXCLUS("INST","LIST_INST"),
                 AU_MOINS_UN('CHAM_MATER','CARA_ELEM',),),
         reuse=SIMP(statut='c', typ=CO),
         RESULTAT        =SIMP(statut='f',typ=evol_elas,fr=tr("Résultat utilisé en cas de réécriture"),
         ),
         MODELE          =SIMP(statut='o',typ=modele_sdaster),
         CHAM_MATER      =SIMP(statut='f',typ=cham_mater,
         fr=tr("le CHAM_MATER est nécessaire, sauf si le modèle ne contient que des éléments discrets (modélisations DIS_XXX)"),
         ),
         CARA_ELEM       =SIMP(statut='f',typ=cara_elem,
         fr=tr("le CARA_ELEM est nécessaire dès que le modèle contient des éléments de structure : coques, poutres, ..."),
         ),
         TITRE           =SIMP(statut='f',typ='TXM'),
         EXCIT           =FACT(statut='o',max='**',
           CHARGE          =SIMP(statut='o',typ=(char_meca,char_cine_meca)),
           FONC_MULT       =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule)),
           TYPE_CHARGE     =SIMP(statut='f',typ='TXM',defaut="FIXE_CSTE",into=("FIXE_CSTE",) ),
         ),
         INST            =SIMP(statut='f',typ='R'),
         LIST_INST       =SIMP(statut='f',typ=listr8_sdaster),
         INST_FIN        =SIMP(statut='f',typ='R'),
         OPTION          =SIMP(statut='f',typ='TXM',into=("SIEF_ELGA","SANS"),defaut="SIEF_ELGA",max=1,
             fr=tr("Seule option : contraintes aux points de Gauss. Utilisez CALC_CHAMP pour les autres options."),
                          ),

#-------------------------------------------------------------------
#        Catalogue commun SOLVEUR
         SOLVEUR         =C_SOLVEUR('MECA_STATIQUE'),
#-------------------------------------------------------------------
         INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2) ),
         translation={
            "MECA_STATIQUE": "Static mechanical analysis",
         }
)  ;
