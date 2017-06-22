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

#----------------
# Modes locaux :
#----------------


MDDLMUC = LocatedComponents(phys=PHY.DDLM_C, type='ELEM',
                            components=('A1',))


MGEOMER = LocatedComponents(phys=PHY.GEOM_R, type='ELNO', diff=True,
                            components=(
                            ('EN1', ()),
                            ('EN2', ('X', 'Y', 'Z',)),))


DDL_ACOU = LocatedComponents(phys=PHY.PRES_C, type='ELNO', diff=True,
                             components=(
                             ('EN1', ('LAGR',)),
                             ('EN2', ('PRES',)),))


MVECTTC = ArrayOfComponents(phys=PHY.VPRE_C, locatedComponents=DDL_ACOU)

MMATTTC = ArrayOfComponents(
    phys=PHY.MPRE_C, locatedComponents=DDL_ACOU)

#------------------------------------------------------------


class D_PRES_C_PRES(Element):

    """Please document this element"""
    meshType = MT.SEG3
    nodes = (
        SetOfNodes('EN1', (2, 3,)),
        SetOfNodes('EN2', (1,)),
    )
    attrs = ((AT.CL_DUAL, 'OUI'),)

    calculs = (
        OP.ACOU_DDLI_C(te=2,
                       para_in=((SP.PDDLIMC, LC.MDDLIMC), ),
                       para_out=((SP.PVECTTC, MVECTTC), ),
                       ),

        OP.ACOU_DDLI_F(te=2,
                       para_in=(
                           (SP.PDDLIMF, LC.MDDLIMF), (SP.PGEOMER, MGEOMER),
                       (SP.PTEMPSR, LC.MTEMPSR), ),
                       para_out=((SP.PVECTTC, MVECTTC), ),
                       ),

        OP.ACOU_DDLM_C(te=2,
                       para_in=((SP.PDDLMUC, MDDLMUC), ),
                       para_out=((SP.PMATTTC, MMATTTC), ),
                       ),
    )
