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

# person_in_charge: harinaivo.andriambololona at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def rest_gene_phys_prod(RESU_GENE,**args ):
  if AsType(RESU_GENE) == tran_gene : return dyna_trans
  if AsType(RESU_GENE) == mode_gene : return mode_meca
  if AsType(RESU_GENE) == harm_gene : return dyna_harmo

  raise AsException("type de concept resultat non prevu")

REST_GENE_PHYS=OPER(nom="REST_GENE_PHYS",op=  75,sd_prod=rest_gene_phys_prod,
                    fr=tr("Restituer dans la base physique des résultats en coordonnées généralisées"),
                    reentrant='n',
        regles=(
                EXCLUS('INST','LIST_INST','TOUT_INST',
                       'TOUT_ORDRE','NUME_ORDRE','NUME_MODE',),
                EXCLUS('FREQ','LIST_FREQ'),
                EXCLUS('MULT_APPUI','CORR_STAT'),
                EXCLUS('MULT_APPUI','NOEUD','GROUP_NO'),
                EXCLUS('CORR_STAT','NOEUD','GROUP_NO'),
                EXCLUS('NOEUD','GROUP_NO'),
                EXCLUS('MAILLE','GROUP_MA'),
                PRESENT_PRESENT('ACCE_MONO_APPUI','DIRECTION'),),
         RESU_GENE       =SIMP(statut='o',typ=(tran_gene,mode_gene,harm_gene) ),
         MODE_MECA       =SIMP(statut='f',typ=mode_meca ),
         NUME_DDL        =SIMP(statut='f',typ=nume_ddl_sdaster ),
         TOUT_INST       =SIMP(statut='f',typ='TXM',into=("OUI",) ),
         INST            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' ),
         LIST_INST       =SIMP(statut='f',typ=listr8_sdaster ),
         TOUT_ORDRE      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
         NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**' ),
         NUME_MODE       =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**' ),
         FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' ),
         LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster ),
         CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("ABSOLU","RELATIF") ),
         b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
             PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
         b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
             PRECISION       =SIMP(statut='o',typ='R',),),
         INTERPOL        =SIMP(statut='f',typ='TXM',defaut="NON",into=("NON","LIN") ),
         MULT_APPUI      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
         CORR_STAT       =SIMP(statut='f',typ='TXM',into=("OUI",) ),
         TOUT_CHAM       =SIMP(statut='f',typ='TXM',into=("OUI",) ),
         b_nom_cham=BLOC(condition="""not exists("TOUT_CHAM")""",
             NOM_CHAM        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max=8,defaut="ACCE",into=("DEPL",
                                   "VITE","ACCE","ACCE_ABSOLU","EFGE_ELNO","SIPO_ELNO","SIGM_ELNO","FORC_NODA",),),),
         GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
         NOEUD           =SIMP(statut='c',typ=no  ,validators=NoRepeat(),max='**'),
         GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
         MAILLE          =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
         ACCE_MONO_APPUI =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule)),
         DIRECTION       =SIMP(statut='f',typ='R',min=3,max=3 ),
         TITRE           =SIMP(statut='f',typ='TXM' ),
)  ;
