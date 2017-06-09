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


ENEU1_R  = LocatedComponents(phys=PHY.NEUT_R, type='ELEM',
    components=('X1',))



#------------------------------------------------------------
class PR_HEXA27(Element):
    """Please document this element"""
    meshType = MT.HEXA27
    elrefe =(
            ElrefeLoc(MT.H27,),
        )
    calculs = (

        OP.TOU_INI_ELEM(te=99,
            para_out=((SP.PNEU1_R, ENEU1_R), ),
        ),

    )


#------------------------------------------------------------
class PR_HEXA20(PR_HEXA27):
    """Please document this element"""
    meshType = MT.HEXA20
    elrefe =(
            ElrefeLoc(MT.H20,),
        )


#------------------------------------------------------------
class PR_HEXA8(PR_HEXA27):
    """Please document this element"""
    meshType = MT.HEXA8
    elrefe =(
            ElrefeLoc(MT.HE8,),
        )


#------------------------------------------------------------
class PR_PENTA18(PR_HEXA27):
    """Please document this element"""
    meshType = MT.PENTA18
    elrefe =(
            ElrefeLoc(MT.P18,),
        )


#------------------------------------------------------------
class PR_PENTA15(PR_HEXA27):
    """Please document this element"""
    meshType = MT.PENTA15
    elrefe =(
            ElrefeLoc(MT.P15,),
        )


#------------------------------------------------------------
class PR_PENTA6(PR_HEXA27):
    """Please document this element"""
    meshType = MT.PENTA6
    elrefe =(
            ElrefeLoc(MT.PE6,),
        )


#------------------------------------------------------------
class PR_TETRA10(PR_HEXA27):
    """Please document this element"""
    meshType = MT.TETRA10
    elrefe =(
            ElrefeLoc(MT.T10,),
        )


#------------------------------------------------------------
class PR_TETRA4(PR_HEXA27):
    """Please document this element"""
    meshType = MT.TETRA4
    elrefe =(
            ElrefeLoc(MT.TE4,),
        )


#------------------------------------------------------------
class PR_PYRAM13(PR_HEXA27):
    """Please document this element"""
    meshType = MT.PYRAM13
    elrefe =(
            ElrefeLoc(MT.P13,),
        )


#------------------------------------------------------------
class PR_PYRAM5(PR_HEXA27):
    """Please document this element"""
    meshType = MT.PYRAM5
    elrefe =(
            ElrefeLoc(MT.PY5,),
        )


#------------------------------------------------------------
class PR_QUAD9(PR_HEXA27):
    """Please document this element"""
    meshType = MT.QUAD9
    elrefe =(
            ElrefeLoc(MT.QU9,),
        )


#------------------------------------------------------------
class PR_QUAD8(PR_HEXA27):
    """Please document this element"""
    meshType = MT.QUAD8
    elrefe =(
            ElrefeLoc(MT.QU8,),
        )


#------------------------------------------------------------
class PR_QUAD4(PR_HEXA27):
    """Please document this element"""
    meshType = MT.QUAD4
    elrefe =(
            ElrefeLoc(MT.QU4,),
        )


#------------------------------------------------------------
class PR_TRIA7(PR_HEXA27):
    """Please document this element"""
    meshType = MT.TRIA7
    elrefe =(
            ElrefeLoc(MT.TR7,),
        )


#------------------------------------------------------------
class PR_TRIA6(PR_HEXA27):
    """Please document this element"""
    meshType = MT.TRIA6
    elrefe =(
            ElrefeLoc(MT.TR6,),
        )


#------------------------------------------------------------
class PR_TRIA3(PR_HEXA27):
    """Please document this element"""
    meshType = MT.TRIA3
    elrefe =(
            ElrefeLoc(MT.TR3,),
        )


#------------------------------------------------------------
class PR_SEG4(PR_HEXA27):
    """Please document this element"""
    meshType = MT.SEG4
    elrefe =(
            ElrefeLoc(MT.SE4,),
        )


#------------------------------------------------------------
class PR_SEG3(PR_HEXA27):
    """Please document this element"""
    meshType = MT.SEG3
    elrefe =(
            ElrefeLoc(MT.SE3,),
        )


#------------------------------------------------------------
class PR_SEG2(PR_HEXA27):
    """Please document this element"""
    meshType = MT.SEG2
    elrefe =(
            ElrefeLoc(MT.SE2,),
        )


#------------------------------------------------------------
class PR_POI1(PR_HEXA27):
    """Please document this element"""
    meshType = MT.POI1
    elrefe =(
            ElrefeLoc(MT.PO1,),
        )
