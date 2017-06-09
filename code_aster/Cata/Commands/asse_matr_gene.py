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

# person_in_charge: mathieu.corus at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def asse_matr_gene_prod(METHODE,**args):
    if   (METHODE=="INITIAL") : return matr_asse_gene_r
    elif (args['OPTION']=="RIGI_GENE_C") : return matr_asse_gene_c
    else : return matr_asse_gene_r

ASSE_MATR_GENE=OPER(nom="ASSE_MATR_GENE",op= 128,sd_prod=asse_matr_gene_prod,
                    fr=tr("Assemblage des matrices généralisées de macro éléments pour construction de la matrice globale généralisée"),
                    reentrant='n',
         NUME_DDL_GENE   =SIMP(statut='o',typ=nume_ddl_gene ),
         METHODE          =SIMP(statut='f',typ='TXM',defaut="CLASSIQUE",into=("CLASSIQUE","INITIAL") ),
         b_option     =BLOC(condition = """equal_to("METHODE", 'CLASSIQUE')""",
           OPTION          =SIMP(statut='o',typ='TXM',into=("RIGI_GENE","RIGI_GENE_C","MASS_GENE","AMOR_GENE") ),
           ),
)  ;
