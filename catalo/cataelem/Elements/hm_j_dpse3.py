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


DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO', diff=True,
                             components=(
                             ('EN1', ('DX', 'DY', 'PRE1',)),
                             ('EN2', ('PRE1',)),))


EFLUXE = LocatedComponents(phys=PHY.FTHM_R, type='ELGA', location='RIGI',
                           components=('PFLU1',))


NGEOMER = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
                            components=('X', 'Y',))




EGEOMER = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
                            components=('X', 'Y',))


CTEMPSR = LocatedComponents(phys=PHY.INST_R, type='ELEM',
                            components=('INST', 'DELTAT', 'THETA',))


CPRESSF = LocatedComponents(phys=PHY.PRES_F, type='ELEM',
                            components=('PRES', 'CISA',))


EPRESNO = LocatedComponents(phys=PHY.PRES_R, type='ELNO',
                            components=('PRES', 'CISA',))


MVECTUR = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class HM_J_DPSE3(Element):

    """Please document this element"""
    meshType = MT.SEG3
    nodes = (
        SetOfNodes('EN2', (3,)),
        SetOfNodes('EN1', (1, 2,)),
    )
    elrefe = (
        ElrefeLoc(MT.SE3, gauss=('RIGI=FPG1',),),
        ElrefeLoc(MT.SE2, gauss=('RIGI=FPG1',),),
    )
    calculs = (

        OP.CHAR_MECA_FLUX_R(te=314,
                            para_in=(
                                (SP.PFLUXR, EFLUXE), (SP.PGEOMER, NGEOMER),
                            (SP.PTEMPSR, CTEMPSR), ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.CHAR_MECA_PRES_F(te=580,
                            para_in=((SP.PPRESSF, CPRESSF), ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.CHAR_MECA_PRES_R(te=580,
                            para_in=((SP.PPRESSR, EPRESNO), ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.TOU_INI_ELEM(te=99,
                        para_out=((OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM2D), ),
                        ),

        OP.TOU_INI_ELGA(te=99,
                        para_out=((OP.TOU_INI_ELGA.PGEOM_R, EGEOMER), ),
                        ),

        OP.TOU_INI_ELNO(te=99,
                        para_out=((OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), ),
                        ),

    )
