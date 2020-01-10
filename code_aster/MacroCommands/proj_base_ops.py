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

from ..Commands import NUME_DDL_GENE, PROJ_MATR_BASE, PROJ_VECT_BASE
from ...Supervis import CO
from ..Objects import GeneralizedDOFNumbering
from Contrib.proj_resu_base import PROJ_RESU_BASE
from Utilitai.Utmess import UTMESS


def proj_base_ops(self, **args):
    """
     Ecriture de la macro PROJ_BASE
    """
    BASE = args.get("BASE")
    NB_VECT = args.get("NB_VECT")
    MATR_ASSE_GENE = args.get("MATR_ASSE_GENE")
    VECT_ASSE_GENE = args.get("VECT_ASSE_GENE")
    RESU_GENE = args.get("RESU_GENE")
    NUME_DDL_GENE = args.get("NUME_DDL_GENE")
    STOCKAGE = args.get("STOCKAGE")


    # On importe les definitions des commandes a utiliser dans la macro
    # et  creation du nume_ddl_gene
    numgen = NUME_DDL_GENE
    if numgen is None:
        _num = NUME_DDL_GENE(BASE=BASE, NB_VECT=NB_VECT, STOCKAGE=STOCKAGE)
    elif isinstance(numgen, GeneralizedDOFNumbering):
        _num = numgen
    elif isinstance(numgen, CO):
        _num = NUME_DDL_GENE(BASE=BASE, NB_VECT=NB_VECT, STOCKAGE=STOCKAGE)
        self.register_result(_num, numgen)
    else:
        assert( False )



    if MATR_ASSE_GENE:
        for m in MATR_ASSE_GENE:
            motscles = {}
            if m['MATR_ASSE']:
                motscles['MATR_ASSE'] = m['MATR_ASSE']
            elif m['MATR_ASSE_GENE']:
                motscles['MATR_ASSE_GENE'] = m['MATR_ASSE_GENE']
            else:
                UTMESS('F', 'MODAL0_1')
            mm = PROJ_MATR_BASE(BASE=BASE, NUME_DDL_GENE=_num, **motscles)
            mm.setGeneralizedDOFNumbering(_num)
            mm.setModalBasis(BASE)
            self.register_result(mm, m['MATRICE'])

    if VECT_ASSE_GENE:
        for v in VECT_ASSE_GENE:
            motscles = {}
            if v['VECT_ASSE']:
                motscles['VECT_ASSE'] = v['VECT_ASSE']
            elif v['VECT_ASSE_GENE']:
                motscles['VECT_ASSE_GENE'] = v['VECT_ASSE_GENE']
            else:
                UTMESS('F', 'MODAL0_1')
            motscles['TYPE_VECT'] = v['TYPE_VECT']
            vv = PROJ_VECT_BASE(BASE=BASE, NUME_DDL_GENE=_num, **motscles)
            self.register_result(vv, v['VECTEUR'])

    if RESU_GENE:
        for v in RESU_GENE:
            motscles = {}
            if v['RESU']:
                motscles['RESU'] = v['RESU']
            else:
                UTMESS('F', 'MODAL0_1')
            motscles['TYPE_VECT'] = v['TYPE_VECT']
            vv = PROJ_RESU_BASE(BASE=BASE, NUME_DDL_GENE=_num, **motscles)
            vv.setGeneralizedDOFNumbering(_num)
            self.register_result(vv, v['RESULTAT'])

    return
