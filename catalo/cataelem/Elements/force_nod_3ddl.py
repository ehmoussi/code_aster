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

#----------------
# Modes locaux :
#----------------


DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
    components=('DX','DY','DZ',))


MFORCEF  = LocatedComponents(phys=PHY.FORC_F, type='ELEM',
    components=('FX','FY','FZ','REP','ALPHA',
          'BETA','GAMMA',))


MFORCER  = LocatedComponents(phys=PHY.FORC_R, type='ELEM',
    components=('FX','FY','FZ','REP','ALPHA',
          'BETA','GAMMA',))


MGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))


MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

#------------------------------------------------------------
class FORCE_NOD_3DDL(Element):
    """Please document this element"""
    meshType = MT.POI1

    calculs = (
        OP.CHAR_MECA_FORC_F(te=1,
        para_in=((SP.PFORNOF, MFORCEF), (SP.PGEOMER, MGEOMER),
                 (SP.PTEMPSR, LC.MTEMPSR), ),
        para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_FORC_R(te=1,
        para_in=((SP.PFORNOR, MFORCER), (SP.PGEOMER, MGEOMER),
                 ),
        para_out=((SP.PVECTUR, MVECTUR), ),
        ),
    )
