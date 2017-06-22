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

from cataelem.Tools.base_objects import LocatedComponents, ArrayOfComponents, SetOfNodes, ElrefeLoc
from cataelem.Tools.base_objects import Calcul, Element
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.located_components as LC
import cataelem.Commons.parameters as SP
import cataelem.Commons.mesh_types as MT
from cataelem.Options.options import OP
import cataelem.Commons.attributes as AT


MGEOMER = LocatedComponents(phys=PHY.GEOM_R, type='ELNO', diff=True,
                            components=(
                            ('EN1', ()),
                            ('EN2', ('X', 'Y', 'Z',)),))


for cmp in ('TEMP', 'TEMP_INF', 'TEMP_MIL', 'TEMP_SUP', 'E1', 'H1',):

    #----------------
    # Modes locaux :
    #----------------
    DDL_THER = LocatedComponents(phys=PHY.TEMP_R, type='ELNO', diff=True,
                                 components=(
                                 ('EN1', ('LAGR',)),
                                 ('EN2', (cmp,)),))

    MVECTTR = ArrayOfComponents(
        phys=PHY.VTEM_R, locatedComponents=DDL_THER)

    MMATTTR = ArrayOfComponents(
        phys=PHY.MTEM_R, locatedComponents=DDL_THER)

#     Attention : il faut nommer explicitement TOUS les modes locaux crees dans la boucle
#     --------------------------------------------------------------------
    DDL_THER.setName('DDL_THER')
    MVECTTR.setName('MVECTTR')
    MMATTTR.setName('MMATTTR')

    name = ('D_TEMP_R_' + cmp)[:16]

    class TempClass(Element):

        """Please document this element"""
        _name = name

        meshType = MT.SEG3
        nodes = (
            SetOfNodes('EN1', (2, 3,)),
            SetOfNodes('EN2', (1,)),
        )
        attrs = ((AT.CL_DUAL, 'OUI'),)

        calculs = (
            OP.THER_BTLA_R(te=2,
                           para_in=(
                           (SP.PDDLMUR, LC.MDDLMUR), (
                           OP.THER_BTLA_R.PLAGRAR, DDL_THER),
                           ),
                           para_out=((SP.PVECTTR, MVECTTR), ),
                           ),

            OP.THER_BU_R(te=2,
                         para_in=(
                         (SP.PALPHAR, LC.MALPHAR), (
                             OP.THER_BU_R.PDDLIMR, DDL_THER),
                         (SP.PDDLMUR, LC.MDDLMUR), ),
                         para_out=((SP.PVECTTR, MVECTTR), ),
                         ),

            OP.THER_DDLI_F(te=2,
                           para_in=(
                               (SP.PDDLIMF, LC.MDDLIMF), (SP.PGEOMER, MGEOMER),
                           (SP.PTEMPSR, LC.MTEMPSR), ),
                           para_out=((SP.PVECTTR, MVECTTR), ),
                           ),

            OP.THER_DDLI_R(te=2,
                           para_in=((OP.THER_DDLI_R.PDDLIMR, LC.MDDLIMR), ),
                           para_out=((SP.PVECTTR, MVECTTR), ),
                           ),

            OP.THER_DDLM_R(te=2,
                           para_in=((SP.PDDLMUR, LC.MDDLMUR), ),
                           para_out=((OP.THER_DDLM_R.PMATTTR, MMATTTR), ),
                           ),
        )

    exec name + " = TempClass"
    del TempClass
