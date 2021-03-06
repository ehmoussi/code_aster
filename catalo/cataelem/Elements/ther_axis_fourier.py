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

#----------------
# Modes locaux :
#----------------


# Reuse PHY.COMPOR from mechanical => names of components are strange
CCOMPOR  = LocatedComponents(phys=PHY.COMPOR, type='ELEM',
    components=('RELCOM','NBVARI','DEFORM','INCELA', 'C_PLAN'))


EFLUXPG  = LocatedComponents(phys=PHY.FLUX_R, type='ELGA', location='RIGI',
    components=('FLUX','FLUY','FLUZ',))


EFLUXNO  = LocatedComponents(phys=PHY.FLUX_R, type='ELNO',
    components=('FLUX','FLUY','FLUZ',))


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y',))


EGGEOP_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
    components=('X','Y','W',))


ENGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y',))


CTEMPSR  = LocatedComponents(phys=PHY.INST_R, type='ELEM',
    components=('INST','DELTAT','THETA',))


ESOURCR  = LocatedComponents(phys=PHY.SOUR_R, type='ELGA', location='RIGI',
    components=('SOUR',))


DDL_THER = LocatedComponents(phys=PHY.TEMP_R, type='ELNO',
    components=('TEMP',))


MVECTTR  = ArrayOfComponents(phys=PHY.VTEM_R, locatedComponents=DDL_THER)

MMATTTR  = ArrayOfComponents(phys=PHY.MTEM_R, locatedComponents=DDL_THER)


#------------------------------------------------------------
class THFOQU4(Element):
    """Please document this element"""
    meshType = MT.QUAD4
    elrefe =(
            ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG4','FPG1=FPG1','MASS=FPG4',), mater=('FPG1',),),
            ElrefeLoc(MT.SE2, gauss = ('RIGI=FPG2',),),
        )
    calculs = (

        OP.CHAR_THER_SOUR_F(te=264,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PSOURCF, LC.CSOURCF),
                     (SP.PTEMPSR, CTEMPSR), ),
            para_out=((SP.PVECTTR, MVECTTR), ),
        ),

        OP.CHAR_THER_SOUR_R(te=263,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PSOURCR, ESOURCR),
                     ),
            para_out=((SP.PVECTTR, MVECTTR), ),
        ),

        OP.COOR_ELGA(te=479,
            para_in=((SP.PGEOMER, NGEOMER), ),
            para_out=((OP.COOR_ELGA.PCOORPG, EGGEOP_R), ),
        ),

        OP.DURT_ELNO(te=551,
            para_in=((SP.PMATERC, LC.CMATERC), (OP.DURT_ELNO.PPHASIN, LC.EPHASNO_),
                     ),
            para_out=((SP.PDURT_R, LC.EDURTNO), ),
        ),

        OP.FLUX_ELGA(te=266,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PHARMON, LC.CHARMON),
                     (SP.PMATERC, LC.CMATERC), (SP.PTEMPER, DDL_THER),
                     (SP.PTEMPSR, CTEMPSR), ),
            para_out=((OP.FLUX_ELGA.PFLUXPG, EFLUXPG), ),
        ),

        OP.FLUX_ELNO(te=4,
            para_in=((OP.FLUX_ELNO.PFLUXPG, EFLUXPG), ),
            para_out=((SP.PFLUXNO, EFLUXNO), ),
        ),

        OP.META_ELNO(te=67,
            para_in=((OP.META_ELNO.PCOMPOR, CCOMPOR), (SP.PFTRC, LC.CFTRC),
                     (SP.PMATERC, LC.CMATERC), (OP.META_ELNO.PPHASIN, LC.EPHASNO_),
                     (SP.PTEMPAR, DDL_THER), (SP.PTEMPER, DDL_THER),
                     (SP.PTEMPIR, DDL_THER), (SP.PTEMPSR, CTEMPSR),
                     ),
            para_out=((SP.PPHASNOU, LC.EPHASNO_), ),
        ),

        OP.META_INIT_ELNO(te=320,
            para_in=((OP.META_INIT_ELNO.PCOMPOR, CCOMPOR), (SP.PMATERC, LC.CMATERC),
                     (OP.META_INIT_ELNO.PPHASIN, LC.CPHASIN_), (SP.PTEMPER, DDL_THER),
                     ),
            para_out=((SP.PPHASNOU, LC.EPHASNO_), ),
        ),

        OP.RIGI_THER(te=260,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PHARMON, LC.CHARMON),
                     (SP.PMATERC, LC.CMATERC), (SP.PTEMPSR, CTEMPSR),
                     ),
            para_out=((OP.RIGI_THER.PMATTTR, MMATTTR), ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PSOUR_R, LC.CSOURCR), ),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out=((OP.TOU_INI_ELGA.PGEOM_R, EGGEOP_R), ),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PGEOM_R, ENGEOM_R), (OP.TOU_INI_ELNO.PINST_R, LC.ENINST_R),
                     (OP.TOU_INI_ELNO.PNEUT_F, LC.ENNEUT_F), (OP.TOU_INI_ELNO.PNEUT_R, LC.ENNEUT_R),
                     (OP.TOU_INI_ELNO.PVARI_R, LC.EPHASNO_),
                     ),
        ),

        OP.VERI_JACOBIEN(te=328,
            para_in=((SP.PGEOMER, NGEOMER), ),
            para_out=((SP.PCODRET, LC.ECODRET), ),
        ),

    )


#------------------------------------------------------------
class THFOQU8(THFOQU4):
    """Please document this element"""
    meshType = MT.QUAD8
    elrefe =(
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9','FPG1=FPG1','MASS=FPG9',), mater=('FPG1',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4',),),
        )


#------------------------------------------------------------
class THFOQU9(THFOQU4):
    """Please document this element"""
    meshType = MT.QUAD9
    elrefe =(
            ElrefeLoc(MT.QU9, gauss = ('RIGI=FPG9','FPG1=FPG1','MASS=FPG9',), mater=('FPG1',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4',),),
        )


#------------------------------------------------------------
class THFOTR3(THFOQU4):
    """Please document this element"""
    meshType = MT.TRIA3
    elrefe =(
            ElrefeLoc(MT.TR3, gauss = ('RIGI=FPG1','FPG1=FPG1','MASS=FPG3',), mater=('FPG1',),),
            ElrefeLoc(MT.SE2, gauss = ('RIGI=FPG2',),),
        )


#------------------------------------------------------------
class THFOTR6(THFOQU4):
    """Please document this element"""
    meshType = MT.TRIA6
    elrefe =(
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG3','FPG1=FPG1','MASS=FPG6',), mater=('FPG1',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4',),),
        )
