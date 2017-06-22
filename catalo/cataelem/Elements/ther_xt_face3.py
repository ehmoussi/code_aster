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

# CATALOGUE DES ELEMENTS THERMIQUES 3D DE BORD X-FEM CRACKTIP LINEAIRES


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


STANO_I  = LocatedComponents(phys=PHY.N120_I, type='ELNO',
    components=('X1',))


E6NEUTI  = LocatedComponents(phys=PHY.N512_I, type='ELEM',
    components=('X[6]',))


E33NEUTR = LocatedComponents(phys=PHY.N792_R, type='ELEM',
    components=('X[33]',))


DDL_THER = LocatedComponents(phys=PHY.TEMP_R, type='ELNO',
    components=('TEMP','E1',))



#------------------------------------------------------------
class THER_XT_FACE3(Element):
    """Please document this element"""
    meshType = MT.TRIA3
    elrefe =(
            ElrefeLoc(MT.TR3, gauss = ('RIGI=COT3','FPG3=FPG3',),),
        )
    calculs = (

        OP.INI_XFEM_ELNO(te=99,
            para_out=((OP.INI_XFEM_ELNO.PLSN, LC.N1NEUT_R), (OP.INI_XFEM_ELNO.PLST, LC.N1NEUT_R),
                     (OP.INI_XFEM_ELNO.PSTANO, STANO_I), (OP.INI_XFEM_ELNO.PBASLOR, LC.N9NEUT_R),),
        ),

        OP.TOPONO(te=120,
            para_in=((OP.TOPONO.PCNSETO, LC.E36NEUI), (OP.TOPONO.PHEAVTO, E6NEUTI),
                     (SP.PLEVSET, LC.N1NEUT_R), (OP.TOPONO.PLONCHA, LC.E10NEUTI),
                     ),
            para_out=((OP.TOPONO.PHEA_NO, LC.N5NEUTI), (OP.TOPONO.PHEA_SE, E6NEUTI),
                     ),
        ),

        OP.TOPOSE(te=514,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PLEVSET, LC.N1NEUT_R),
                     ),
            para_out=((OP.TOPOSE.PCNSETO, LC.E36NEUI), (OP.TOPOSE.PHEAVTO, E6NEUTI),
                     (OP.TOPOSE.PLONCHA, LC.E10NEUTI), (OP.TOPOSE.PPINTTO, LC.E12NEUTR),
                     (OP.TOPOSE.PPMILTO, E33NEUTR), ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM3D), ),
        ),


        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), ),
        ),

    )


#------------------------------------------------------------
class THER_XT_FACE4(THER_XT_FACE3):
    """Please document this element"""
    meshType = MT.QUAD4
    elrefe =(
            ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG4',),),
            ElrefeLoc(MT.TR3, gauss = ('RIGI=COT3','FPG3=FPG3',),),
        )
