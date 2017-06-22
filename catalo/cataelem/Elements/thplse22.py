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


NDEPLAR  = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
    components=('DX','DY',))


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y',))


CTEMPSR  = LocatedComponents(phys=PHY.INST_R, type='ELEM',
    components=('INST','DELTAT','THETA',))


DDL_THER = LocatedComponents(phys=PHY.TEMP_R, type='ELNO',
    components=('TEMP',))


MVECTTR  = ArrayOfComponents(phys=PHY.VTEM_R, locatedComponents=DDL_THER)

MMATTTR  = ArrayOfComponents(phys=PHY.MTEM_R, locatedComponents=DDL_THER)


#------------------------------------------------------------
class THPLSE22(Element):
    """Please document this element"""
    meshType = MT.SEG22
    elrefe =(
            ElrefeLoc(MT.SE2, gauss = ('RIGI=FPG2',),),
        )
    calculs = (

        OP.CHAR_THER_PARO_F(te=210,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PHECHPF, LC.CHECHPF),
                     (SP.PTEMPER, DDL_THER), (SP.PTEMPSR, CTEMPSR),
                     ),
            para_out=((SP.PVECTTR, MVECTTR), ),
        ),

        OP.CHAR_THER_PARO_R(te=209,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PHECHPR, LC.EHECHPR),
                     (SP.PTEMPER, DDL_THER), (SP.PTEMPSR, CTEMPSR),
                     ),
            para_out=((SP.PVECTTR, MVECTTR), ),
        ),

        OP.MTAN_THER_PARO_F(te=387,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PHECHPF, LC.CHECHPF),
                     (SP.PTEMPSR, CTEMPSR), ),
            para_out=((OP.MTAN_THER_PARO_F.PMATTTR, MMATTTR), ),
        ),

        OP.MTAN_THER_PARO_R(te=386,
            para_in=((SP.PDEPLAR, NDEPLAR), (SP.PGEOMER, NGEOMER),
                     (SP.PHECHPR, LC.EHECHPR), (SP.PTEMPER, DDL_THER),
                     (SP.PTEMPSR, CTEMPSR), ),
            para_out=((OP.MTAN_THER_PARO_R.PMATTTR, MMATTTR), ),
        ),

        OP.RESI_THER_PARO_F(te=277,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PHECHPF, LC.CHECHPF),
                     (SP.PTEMPEI, DDL_THER), (SP.PTEMPSR, CTEMPSR),
                     ),
            para_out=((SP.PRESIDU, MVECTTR), ),
        ),

        OP.RESI_THER_PARO_R(te=275,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PHECHPR, LC.EHECHPR),
                     (SP.PTEMPEI, DDL_THER), (SP.PTEMPSR, CTEMPSR),
                     ),
            para_out=((SP.PRESIDU, MVECTTR), ),
        ),

        OP.RIGI_THER_PARO_F(te=212,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PHECHPF, LC.CHECHPF),
                     (SP.PTEMPSR, CTEMPSR), ),
            para_out=((OP.RIGI_THER_PARO_F.PMATTTR, MMATTTR), ),
        ),

        OP.RIGI_THER_PARO_R(te=211,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PHECHPR, LC.EHECHPR),
                     (SP.PTEMPER, DDL_THER), (SP.PTEMPSR, CTEMPSR),
                     ),
            para_out=((OP.RIGI_THER_PARO_R.PMATTTR, MMATTTR), ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM2D), ),
        ),


        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), ),
        ),

    )


#------------------------------------------------------------
class THPLSE33(THPLSE22):
    """Please document this element"""
    meshType = MT.SEG33
    elrefe =(
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4',),),
        )


#------------------------------------------------------------
class THAXSE22(THPLSE22):
    """Please document this element"""
    meshType = MT.SEG22
    elrefe =(
            ElrefeLoc(MT.SE2, gauss = ('RIGI=FPG2',),),
        )


#------------------------------------------------------------
class THAXSE33(THPLSE22):
    """Please document this element"""
    meshType = MT.SEG33
    elrefe =(
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4',),),
        )
