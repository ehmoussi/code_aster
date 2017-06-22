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

# person_in_charge: mickael.abbas at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


THER_NON_LINE=OPER(nom="THER_NON_LINE",op= 186,sd_prod=evol_ther,reentrant='f',
                   fr=tr("Résoudre un problème thermique non linéaire (conditions limites ou comportement matériau)"
                       " stationnaire ou transitoire"),
         reuse=SIMP(statut='c', typ=CO),
         MODELE          =SIMP(statut='o',typ=(modele_sdaster),),
         CHAM_MATER      =SIMP(statut='o',typ=(cham_mater) ),
         CARA_ELEM       =SIMP(statut='c',typ=(cara_elem) ),
         COMPORTEMENT    =FACT(statut='d',max='**',
           RELATION        =SIMP(statut='f',typ='TXM',defaut="THER_NL",
                                 into=("THER_NL",
                                       "THER_HYDR",
                                       "SECH_GRANGER",
                                       "SECH_MENSI",
                                       "SECH_BAZANT",
                                       "SECH_NAPPE"
                                       ) ),
         regles=(PRESENT_ABSENT('TOUT','GROUP_MA','MAILLE'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
         ),
         EVOL_THER_SECH  =SIMP(statut='f',typ=evol_ther),
         EXCIT           =FACT(statut='o',max='**',
           CHARGE          =SIMP(statut='o',typ=char_ther),
           FONC_MULT       =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule)),
         ),
         METHODE         =SIMP(statut='f',typ='TXM',defaut="NEWTON",into=("NEWTON","MODELE_REDUIT","NEWTON_KRYLOV")),
         b_meth_newton = BLOC(condition = """equal_to("METHODE", 'NEWTON') or equal_to("METHODE", 'NEWTON_KRYLOV')""",
                    NEWTON          =FACT(statut='d',
                        REAC_ITER       =SIMP(statut='f',typ='I',defaut= 0 ,val_min=0),
                        RESI_LINE_RELA  =SIMP(statut='f',typ='R',defaut= 1.0E-3 ),
                        ITER_LINE_MAXI  =SIMP(statut='f',typ='I',defaut= 0 ),
                    ),),
         b_meth_rom = BLOC(condition = """equal_to("METHODE", 'MODELE_REDUIT')""",
                    MODELE_REDUIT =FACT(statut='d',
                        REAC_ITER       =SIMP(statut='f',typ='I',defaut= 0 ,val_min=0),
                        BASE_PRIMAL     =SIMP(statut='o',typ=mode_empi,max=1),
                        DOMAINE_REDUIT  =SIMP(statut='f',typ='TXM',defaut='NON',into=('OUI','NON'),),
                        p_hr_cond   =BLOC(condition="""(equal_to("DOMAINE_REDUIT", 'OUI'))""",
                            GROUP_NO_INTERF=SIMP(statut='o',typ=grno,max=1),),
                    ),),
#-------------------------------------------------------------------
         INCREMENT       =C_INCREMENT('THERMIQUE'),
#-------------------------------------------------------------------
         ETAT_INIT       =FACT(statut='f',
           regles=(EXCLUS('EVOL_THER','CHAM_NO','VALE'),),
           STATIONNAIRE    =SIMP(statut='f',typ='TXM',into=("OUI",)),
           EVOL_THER       =SIMP(statut='f',typ=evol_ther),
           CHAM_NO         =SIMP(statut='f',typ=cham_no_sdaster),
           VALE            =SIMP(statut='f',typ='R'),
           NUME_ORDRE      =SIMP(statut='f',typ='I'),
           INST            =SIMP(statut='f',typ='R'),
           CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU") ),
           b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
              PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
           b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
              PRECISION       =SIMP(statut='o',typ='R',),),
           INST_ETAT_INIT  =SIMP(statut='f',typ='R'),
         ),
         CONVERGENCE     =FACT(statut='d',
           RESI_GLOB_MAXI  =SIMP(statut='f',typ='R'),
           RESI_GLOB_RELA  =SIMP(statut='f',typ='R'),
           ITER_GLOB_MAXI  =SIMP(statut='f',typ='I',defaut= 10 ),
         ),
#-------------------------------------------------------------------
#        Catalogue commun SOLVEUR
         SOLVEUR         =C_SOLVEUR('THER_NON_LINE'),
#-------------------------------------------------------------------
         PARM_THETA      =SIMP(statut='f',typ='R',defaut= 0.57 , val_min=0., val_max = 1.),
#-------------------------------------------------------------------
         ARCHIVAGE       =C_ARCHIVAGE(),
#-------------------------------------------------------------------
         OBSERVATION     =C_OBSERVATION('THERMIQUE'),
#-------------------------------------------------------------------
         TITRE           =SIMP(statut='f',typ='TXM'),
         INFO            =SIMP(statut='f',typ='I',into=(1,2) ),

)  ;
