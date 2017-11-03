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

# person_in_charge: mickael.abbas@edf.fr
#
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def post_champ_prod(RESULTAT_REDUIT,**args):
    if (AsType(RESULTAT_REDUIT) == evol_noli):
        return evol_noli
    if (AsType(RESULTAT_REDUIT) == evol_ther):
        return evol_ther

REST_REDUIT_COMPLET=OPER(nom="REST_REDUIT_COMPLET",op=54,
                         sd_prod=post_champ_prod,
                         reentrant='n',
    MODELE           = SIMP(statut='o',typ=modele_sdaster),
    RESULTAT_REDUIT  = SIMP(statut='o',typ=resultat_sdaster,max=1),
    BASE_PRIMAL      = SIMP(statut='o',typ=mode_empi,max=1),
    REST_DUAL        = SIMP(statut='f',typ='TXM',defaut='NON',into=('OUI','NON')),
    b_dual           = BLOC(condition="""(equal_to("REST_DUAL", 'OUI'))""",
                            GROUP_NO_INTERF = SIMP(statut='o',typ=grno,max=1),
                            BASE_DUAL= SIMP(statut='o',typ=mode_empi,max=1)),
    CORR_COMPLET     = SIMP(statut='f',typ='TXM',defaut='NON',into=('OUI','NON')),
    b_corr           = BLOC(condition="""(equal_to("CORR_COMPLET", 'OUI'))""",
                            BASE_DOMAINE = SIMP(statut='o',typ=mode_empi,max=1)),
    INFO             = SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
    TITRE            = SIMP(statut='f',typ='TXM'),
) ;
