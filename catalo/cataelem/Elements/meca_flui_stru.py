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

from cataelem.Tools.base_objects import LocatedComponents, ArrayOfComponents, SetOfNodes, ElrefeLoc
from cataelem.Tools.base_objects import Calcul, Element
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.located_components as LC
import cataelem.Commons.parameters as SP
import cataelem.Commons.mesh_types as MT
from cataelem.Options.options import OP

#----------------------------------------------------------------------------------------------
# Located components
#----------------------------------------------------------------------------------------------

DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
                             components=('DX', 'DY', 'DZ', 'PHI',))

MMATUUR  = ArrayOfComponents(phys=PHY.MDEP_R, locatedComponents=DDL_MECA)

MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

#----------------------------------------------------------------------------------------------
class MEFS_FACE3(Element):
    """Element for FSI interaction (U,P,PHI) - 3D - On TR3"""
    meshType = MT.TRIA3
    elrefe = (
        ElrefeLoc(MT.TR3, gauss=('RIGI=COT3', 'FPG1=FPG1',), mater=('FPG1',),),
    )
    calculs = (
        OP.CHAR_MECA_PRES_F(te=205,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PPRESSF, LC.CPRE3DF),
                        (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),
        
        OP.CHAR_MECA_PRES_R(te=205,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PPRESSR, LC.EPRE3DR),
                        (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_VNOR(te=213,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),
                        (SP.PVITENR, LC.EVITENR),),
            para_out = ((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_VNOR_F(te=213,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),
                        (SP.PVITENF, LC.EVITENF),),
            para_out = ((SP.PVECTUR, MVECTUR), ),
        ),

        OP.COOR_ELGA(te=488,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D),),
            para_out = ((OP.COOR_ELGA.PCOORPG, LC.EGGAU3D),),
        ),

        OP.MASS_MECA(te=172,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PMATUUR, MMATUUR),),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out = ((OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM3D),),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out = ((OP.TOU_INI_ELGA.PGEOM_R, LC.EGGAU3D),),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out = ((OP.TOU_INI_ELNO.PGEOM_R, LC.EGEOM3D),),
        ),
    )

#----------------------------------------------------------------------------------------------
class MEFS_FACE4(MEFS_FACE3):
    """Element for FSI interaction (U,P,PHI) - 3D - On QU4"""
    meshType = MT.QUAD4
    elrefe = (
        ElrefeLoc(MT.QU4, gauss=('RIGI=FPG4', 'FPG1=FPG1',), mater=('FPG1',),),
    )

#----------------------------------------------------------------------------------------------
class MEFS_FACE6(MEFS_FACE3):
    """Element for FSI interaction (U,P,PHI) - 3D - On TR6"""
    meshType = MT.TRIA6
    elrefe = (
        ElrefeLoc(MT.TR6, gauss=('RIGI=FPG4', 'FPG1=FPG1',), mater=('FPG1',),),
    )

#----------------------------------------------------------------------------------------------
class MEFS_FACE8(MEFS_FACE3):
    """Element for FSI interaction (U,P,PHI) - 3D - On QU8"""
    meshType = MT.QUAD8
    elrefe = (
        ElrefeLoc(MT.QU8, gauss=('RIGI=FPG9', 'FPG1=FPG1',), mater=('FPG1',),),
    )

#----------------------------------------------------------------------------------------------
class MEFS_FACE9(MEFS_FACE3):
    """Element for FSI interaction (U,P,PHI) - 3D - On QU9"""
    meshType = MT.QUAD9
    elrefe = (
        ElrefeLoc(MT.QU9, gauss=('RIGI=FPG9', 'FPG1=FPG1',), mater=('FPG1',),),
    )
