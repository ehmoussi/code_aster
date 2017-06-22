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

# person_in_charge: sylvie.michel-ponnelle at edf.fr


from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


DEFI_CABLE_OP=OPER(nom="DEFI_CABLE_OP",op= 180,sd_prod=cabl_precont,reentrant='n',
            fr=tr("Définit les profils initiaux de tension d'une structure en béton le long des cables de précontrainte"
                " (utilisée par la macro DEFI_CABLE_BP)"),
         MODELE          =SIMP(statut='o',typ=modele_sdaster ),
         CHAM_MATER      =SIMP(statut='o',typ=cham_mater ),
         CARA_ELEM       =SIMP(statut='o',typ=cara_elem ),
         GROUP_MA_BETON  =SIMP(statut='o',typ=grma,max='**'),
         DEFI_CABLE      =FACT(statut='o',max='**',
           regles=(UN_PARMI('MAILLE','GROUP_MA'),
                   UN_PARMI('NOEUD_ANCRAGE','GROUP_NO_ANCRAGE'),),
           MAILLE          =SIMP(statut='f',typ=ma,min=2,validators=NoRepeat(),max='**'),
           GROUP_MA        =SIMP(statut='f',typ=grma),
           NOEUD_ANCRAGE   =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max=2),
           GROUP_NO_ANCRAGE=SIMP(statut='f',typ=grno,validators=NoRepeat(),max=2),
           GROUP_NO_FUT    =SIMP(statut='f',typ=grno,validators=NoRepeat(),max=2),
           TENSION_CT      =SIMP(statut='f',typ=table_sdaster),
         ),
         ADHERENT        =SIMP(statut='o',typ='TXM',defaut='OUI',into=("OUI","NON") ),
         TYPE_ANCRAGE    =SIMP(statut='o',typ='TXM',min=2,max=2,into=("ACTIF","PASSIF") ),
         TENSION_INIT    =SIMP(statut='o',typ='R',val_min=0.E+0 ),
         RECUL_ANCRAGE   =SIMP(statut='o',typ='R',val_min=0.E+0 ),
         TYPE_RELAX      =SIMP(statut='o',typ='TXM',into=("SANS","BPEL","ETCC_DIRECT","ETCC_REPRISE"),defaut="SANS",),
         R_J             =SIMP(statut='f',typ='R',val_min=0.E+0),
         NBH_RELAX       =SIMP(statut='f',typ='R',val_min=0.E+0),
#         PERT_ELAS       =SIMP(statut='o',typ='TXM',into=("OUI","NON"),defaut="NON"),
#         EP_BETON        =SIMP(statut='f',typ='R',val_min=0.E+0),
#         ESP_CABLE       =SIMP(statut='f',typ='R',val_min=0.E+0),
         TITRE           =SIMP(statut='f',typ='TXM',max='**' ),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
         CONE            =FACT(statut='f',min=0,
           RAYON             =SIMP(statut='o',typ='R',val_min=0.E+0 ),
           LONGUEUR          =SIMP(statut='o',typ='R',val_min=0.E+0, defaut=0.E+0 ),
           PRESENT           =SIMP(statut='o',typ='TXM',min=2,max=2,into=("OUI","NON") ),
         ),
)  ;
