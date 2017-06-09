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


def C_ETAT_INIT( COMMAND, statut ) :  #COMMUN#

    kwargs = {}

    kwargs['DEPL']           = SIMP(statut='f',typ=cham_no_sdaster)
    kwargs['SIGM']           = SIMP(statut='f',typ=(cham_elem,carte_sdaster))
    kwargs['VARI']           = SIMP(statut='f',typ=cham_elem)
    kwargs['STRX']           = SIMP(statut='f',typ=cham_elem)

    if COMMAND == 'STAT_NON_LINE':
        kwargs['COHE']      = SIMP(statut='f',typ=cham_elem)

    if COMMAND == 'DYNA_NON_LINE':
        kwargs['VITE']       = SIMP(statut='f',typ=cham_no_sdaster)
        kwargs['ACCE']       = SIMP(statut='f',typ=cham_no_sdaster)

    kwargs['EVOL_NOLI']      = SIMP(statut='f',typ=evol_noli)
    kwargs['NUME_ORDRE']     = SIMP(statut='f',typ='I')
    kwargs['INST']           = SIMP(statut='f',typ='R')
    kwargs['NUME_DIDI']      = SIMP(statut='f',typ='I')
    kwargs['INST_ETAT_INIT'] = SIMP(statut='f',typ='R')
    kwargs['CRITERE']        = SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU"))

    if COMMAND == 'DYNA_NON_LINE':
        mcfact = FACT(statut=statut,max='**',
                  regles=(AU_MOINS_UN('EVOL_NOLI','ACCE','VITE','DEPL','SIGM','VARI',),
                          EXCLUS('NUME_ORDRE','INST'), ),
                  b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
                                   PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
                  b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
                                   PRECISION       =SIMP(statut='o',typ='R',),),
                    **kwargs
                 )
    else:
        mcfact = FACT(statut=statut,max='**',
                  regles=(AU_MOINS_UN('EVOL_NOLI','DEPL','SIGM','VARI','COHE',),
                          EXCLUS('NUME_ORDRE','INST'), ),
                  b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
                                   PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
                  b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
                                   PRECISION       =SIMP(statut='o',typ='R',),),
                    **kwargs
                 )

    return mcfact
