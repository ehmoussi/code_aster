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


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))



#------------------------------------------------------------
class PR_G_HEXA20(Element):
    """Please document this element"""
    meshType = MT.HEXA20
    elrefe =(
            ElrefeLoc(MT.H20, gauss = ('NOEU=NOEU','RIGI=FPG27',),),
        )
    calculs = (

        OP.GRAD_NEUT_R(te=24,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PNEUTER, LC.N1NEUT_R),
                     ),
            para_out=((OP.GRAD_NEUT_R.PGNEUTR, LC.E3NEUT_R), ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM3D), ),
        ),


        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), ),
        ),

    )


#------------------------------------------------------------
class PR_G_HEXA8(PR_G_HEXA20):
    """Please document this element"""
    meshType = MT.HEXA8
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU','RIGI=FPG8',),),
        )


#------------------------------------------------------------
class PR_G_PENTA15(PR_G_HEXA20):
    """Please document this element"""
    meshType = MT.PENTA15
    elrefe =(
            ElrefeLoc(MT.P15, gauss = ('NOEU=NOEU','RIGI=FPG21',),),
        )


#------------------------------------------------------------
class PR_G_PENTA6(PR_G_HEXA20):
    """Please document this element"""
    meshType = MT.PENTA6
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU','RIGI=FPG6',),),
        )


#------------------------------------------------------------
class PR_G_TETRA10(PR_G_HEXA20):
    """Please document this element"""
    meshType = MT.TETRA10
    elrefe =(
            ElrefeLoc(MT.T10, gauss = ('NOEU=NOEU','RIGI=FPG5',),),
        )


#------------------------------------------------------------
class PR_G_TETRA4(PR_G_HEXA20):
    """Please document this element"""
    meshType = MT.TETRA4
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU','RIGI=FPG1',),),
        )


#------------------------------------------------------------
class PR_G_PYRAM13(PR_G_HEXA20):
    """Please document this element"""
    meshType = MT.PYRAM13
    elrefe =(
            ElrefeLoc(MT.P13, gauss = ('NOEU=NOEU','RIGI=FPG27',),),
        )


#------------------------------------------------------------
class PR_G_PYRAM5(PR_G_HEXA20):
    """Please document this element"""
    meshType = MT.PYRAM5
    elrefe =(
            ElrefeLoc(MT.PY5, gauss = ('NOEU=NOEU','RIGI=FPG5',),),
        )
