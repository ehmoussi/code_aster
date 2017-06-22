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


CCACOQU  = LocatedComponents(phys=PHY.CACOQU, type='ELEM',
    components=('EP','ALPHA','BETA','CTOR',))


DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
    components=('DX','DY','DZ','DRX','DRY',
          'DRZ',))


MFORCEF  = LocatedComponents(phys=PHY.FORC_F, type='ELEM',
    components=('FX','FY','FZ','MX','MY',
          'MZ',))


MFORCER  = LocatedComponents(phys=PHY.FORC_R, type='ELEM',
    components=('FX','FY','FZ','MX','MY',
          'MZ',))




MGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))


EGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
    components=('X','Y','Z',))


ECASECT  = LocatedComponents(phys=PHY.NEUT_R, type='ELEM',
    components=('X[10]',))


MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class MEBOCQ3(Element):
    """Please document this element"""
    meshType = MT.SEG3
    elrefe =(
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4',),),
        )
    calculs = (

        OP.CARA_SECT_POUT3(te=570,
            para_in=((SP.PCACOQU, CCACOQU), (OP.CARA_SECT_POUT3.PCAORIE, LC.CGEOM3D),
                     (SP.PGEOMER, MGEOMER), ),
            para_out=((SP.PCASECT, ECASECT), ),
        ),

        OP.CARA_SECT_POUT4(te=570,
            para_in=((SP.PCACOQU, CCACOQU), (OP.CARA_SECT_POUT4.PCAORIE, LC.CGEOM3D),
                     (SP.PGEOMER, MGEOMER), (SP.PORIGIN, LC.CGEOM3D),
                     ),
            para_out=((SP.PVECTU1, MVECTUR), (SP.PVECTU2, MVECTUR),
                     ),
        ),

        OP.CARA_SECT_POUT5(te=570,
            para_in=((SP.PCACOQU, CCACOQU), (OP.CARA_SECT_POUT5.PCAORIE, LC.CGEOM3D),
                     (SP.PGEOMER, MGEOMER), (SP.PNUMMOD, LC.CNUMMOD),
                     (SP.PORIGFI, LC.CGEOM3D), (SP.PORIGIN, LC.CGEOM3D),
                     ),
            para_out=((SP.PVECTU1, MVECTUR), (SP.PVECTU2, MVECTUR),
                     (SP.PVECTU3, MVECTUR), ),
        ),

        OP.CHAR_MECA_FF1D3D(te=418,
            para_in=((SP.PFF1D3D, MFORCEF), (SP.PGEOMER, MGEOMER),
                     (SP.PTEMPSR, LC.MTEMPSR), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_FR1D3D(te=418,
            para_in=((SP.PFR1D3D, MFORCER), (SP.PGEOMER, MGEOMER),
                     ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM3D), ),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out=((OP.TOU_INI_ELGA.PGEOM_R, EGEOMER), ),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PGEOM_R, MGEOMER), ),
        ),

    )
