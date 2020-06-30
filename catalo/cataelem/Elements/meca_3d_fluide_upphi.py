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

# Ce catalogue correspondant aux elements fluides lineaires massifs en 3D
# pour le couplage fluide-structure n'ont que des DDL de :
#  pression PRES et potentiel de deplacement PHI.
# La contrainte n'existe pas, ni la deformation.
# Les options FULL_MECA et RAPH_MECA sont disponibles mais correspondent
# a un probleme lineaire : le CODRET sera toujours OK sur ces elements.
# On le garde neanmoins pour des raisons de compatibilite.


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
                             components=('PRES','PHI',))

NDEPLAC  = LocatedComponents(phys=PHY.DEPL_C, type='ELNO',
                             components=('PRES','PHI',))

MMATUUC  = ArrayOfComponents(phys=PHY.MDEP_C, locatedComponents=NDEPLAC)

MMATUUR  = ArrayOfComponents(phys=PHY.MDEP_R, locatedComponents=DDL_MECA)

MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

#----------------------------------------------------------------------------------------------
class MEFL_HEXA20(Element):
    """Element for fluid (U,P,PHI) - 3D - On H20"""
    meshType = MT.HEXA20
    elrefe =(
            ElrefeLoc(MT.H20, gauss = ('RIGI=FPG27','FPG1=FPG1',), mater=('FPG1',),),
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9',),),
    )
    calculs = (
        OP.COOR_ELGA(te=488,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D),),
            para_out = ((OP.COOR_ELGA.PCOORPG, LC.EGGAU3D),),
        ),

        OP.FORC_NODA(te=170,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.FULL_MECA(te=170,
            para_in  = ((SP.PCOMPOR, LC.CCOMPOR), (SP.PDEPLMR, DDL_MECA),
                        (SP.PDEPLPR, DDL_MECA), (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PCODRET, LC.ECODRET), (SP.PMATUUR, MMATUUR),
                        (SP.PVECTUR, MVECTUR),),
        ),

        OP.MASS_INER(te=152,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PMASSINE, LC.EMASSINE),),
        ),

        OP.MASS_MECA(te=171,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PMATUUR, MMATUUR),),
        ),

        OP.NSPG_NBVA(te=496,
            para_in  = ((OP.NSPG_NBVA.PCOMPOR, LC.CCOMPO2),),
            para_out = ((SP.PDCEL_I, LC.EDCEL_I),),
        ),

        OP.PAS_COURANT(te=405,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PCOURAN, LC.ECOURAN),),
        ),

        OP.PRME_ELNO(te=420,
            para_in  = ((SP.PDEPLAC, NDEPLAC),),
            para_out = ((SP.PPRME_R, LC.EPRMENO),),
        ),

        OP.RAPH_MECA(te=170,
            para_in  = ((SP.PCOMPOR, LC.CCOMPOR), (SP.PDEPLMR, DDL_MECA),
                        (SP.PDEPLPR, DDL_MECA), (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PCODRET, LC.ECODRET), (SP.PVECTUR, MVECTUR),),
        ),

        OP.RIGI_MECA(te=170,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PMATUUR, MMATUUR),),
        ),


        OP.RIGI_MECA_HYST(te=170,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PMATUUC, MMATUUC),),
        ),

        OP.RIGI_MECA_TANG(te=170,
            para_in  = ((SP.PCOMPOR, LC.CCOMPOR), (SP.PDEPLMR, DDL_MECA),
                        (SP.PDEPLPR, DDL_MECA), (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PMATUUR, MMATUUR), 
                        (SP.PVECTUR, MVECTUR), 
                        (SP.PCOPRED, LC.ECODRET), (SP.PCODRET, LC.ECODRET),
                       ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out = ((SP.PGEOM_R, LC.CGEOM3D),),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out = ((SP.PGEOM_R, LC.EGGEO3D),),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out = ((SP.PGEOM_R, LC.EGEOM3D),),
        ),

        OP.VERI_JACOBIEN(te=328,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D),),
            para_out = ((SP.PCODRET, LC.ECODRET),),
        ),
    )

#----------------------------------------------------------------------------------------------
class MEFL_HEXA27(MEFL_HEXA20):
    """Element for fluid (U,P,PHI) - 3D - On H27"""
    meshType = MT.HEXA27
    elrefe =(
            ElrefeLoc(MT.H27, gauss = ('RIGI=FPG27','FPG1=FPG1',), mater=('FPG1',),),
            ElrefeLoc(MT.QU9, gauss = ('RIGI=FPG9',),),
    )

#----------------------------------------------------------------------------------------------
class MEFL_HEXA8(MEFL_HEXA20):
    """Element for fluid (U,P,PHI) - 3D - On HE8"""
    meshType = MT.HEXA8
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('RIGI=FPG8','FPG1=FPG1',), mater=('FPG1',),),
            ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG4',),),
    )

#----------------------------------------------------------------------------------------------
class MEFL_PENTA15(MEFL_HEXA20):
    """Element for fluid (U,P,PHI) - 3D - On P15"""
    meshType = MT.PENTA15
    elrefe =(
            ElrefeLoc(MT.P15, gauss = ('RIGI=FPG21','FPG1=FPG1',), mater=('FPG1',),),
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9',),),
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6',),),
    )

#----------------------------------------------------------------------------------------------
class MEFL_PENTA6(MEFL_HEXA20):
    """Element for fluid (U,P,PHI) - 3D - On PE6"""
    meshType = MT.PENTA6
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('RIGI=FPG6','FPG1=FPG1',), mater=('FPG1',),),
            ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG4',),),
            ElrefeLoc(MT.TR3, gauss = ('RIGI=COT3',),),
    )

#------------------------------------------------------------
class MEFL_PYRAM5(MEFL_HEXA20):
    """Element for fluid (U,P,PHI) - 3D - On PY5"""
    meshType = MT.PYRAM5
    elrefe =(
            ElrefeLoc(MT.PY5, gauss = ('RIGI=FPG5','FPG1=FPG1',), mater=('FPG1',),),
            ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG4',),),
            ElrefeLoc(MT.TR3, gauss = ('RIGI=COT3',),),
    )

#----------------------------------------------------------------------------------------------
class MEFL_PYRAM13(MEFL_HEXA20):
    """Element for fluid (U,P,PHI) - 3D - On P13"""
    meshType = MT.PYRAM13
    elrefe =(
            ElrefeLoc(MT.P13, gauss = ('RIGI=FPG27','FPG1=FPG1',), mater=('FPG1',),),
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9',),),
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6',),),
    )

#----------------------------------------------------------------------------------------------
class MEFL_TETRA10(MEFL_HEXA20):
    """Element for fluid (U,P,PHI) - 3D - On T10"""
    meshType = MT.TETRA10
    elrefe =(
            ElrefeLoc(MT.T10, gauss = ('RIGI=FPG15','FPG1=FPG1',), mater=('FPG1',),),
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6',),),
    )

#----------------------------------------------------------------------------------------------
class MEFL_TETRA4(MEFL_HEXA20):
    """Element for fluid (U,P,PHI) - 3D - On TE4"""
    meshType = MT.TETRA4
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('RIGI=FPG4','FPG1=FPG1',), mater=('FPG1',),),
            ElrefeLoc(MT.TR3, gauss = ('RIGI=COT3',),),
    )

#----------------------------------------------------------------------------------------------
class MEFL_FACE3(Element):
    """Element for fluid (U,P,PHI) - 3D/Boundary - On TR3"""
    meshType = MT.TRIA3
    elrefe =(
            ElrefeLoc(MT.TR3, gauss = ('RIGI=COT3','FPG1=FPG1',), mater=('FPG1',),),
    )
    calculs = (
        OP.CHAR_MECA_ONDE(te=369,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),
                        (SP.PONDECR, LC.EONDEPR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_PRES_F(te=99,
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),
        
        OP.CHAR_MECA_PRES_R(te=99,
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_VNOR(te=173,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),
                        (SP.PVITENR, LC.EVITENR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_VNOR_F(te=173,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),
                        (SP.PVITENF, LC.EVITENF),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.COOR_ELGA(te=488,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D),),
            para_out = ((OP.COOR_ELGA.PCOORPG, LC.EGGAU3D),),
        ),

        OP.IMPE_MECA(te=10,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PIMPEDR, LC.EIMPEDR),
                        (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PMATUUR, MMATUUR),),
        ),

        OP.ONDE_FLUI(te=374,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PMATERC, LC.CMATERC),
                        (SP.PONDECR, LC.EONDEPR),),
            para_out = ((SP.PMATUUR, MMATUUR),),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out = ((SP.PGEOM_R, LC.CGEOM3D),),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out = ((SP.PGEOM_R, LC.EGGEO3D),),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out = ((SP.PGEOM_R, LC.EGEOM3D),),
        ),
    )

#----------------------------------------------------------------------------------------------
class MEFL_FACE4(MEFL_FACE3):
    """Element for fluid (U,P,PHI) - 3D/Boundary - On QU4"""
    meshType = MT.QUAD4
    elrefe =(
            ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG4','FPG1=FPG1',), mater=('FPG1',),),
    )

#----------------------------------------------------------------------------------------------
class MEFL_FACE6(MEFL_FACE3):
    """Element for fluid (U,P,PHI) - 3D/Boundary - On TR6"""
    meshType = MT.TRIA6
    elrefe =(
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG4','FPG1=FPG1',), mater=('FPG1',),),
    )

#----------------------------------------------------------------------------------------------
class MEFL_FACE8(MEFL_FACE3):
    """Element for fluid (U,P,PHI) - 3D/Boundary - On QU8"""
    meshType = MT.QUAD8
    elrefe =(
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9','FPG1=FPG1',), mater=('FPG1',),),
    )

#----------------------------------------------------------------------------------------------
class MEFL_FACE9(MEFL_FACE3):
    """Element for fluid (U,P,PHI) - 3D/Boundary - On QU9"""
    meshType = MT.QUAD9
    elrefe =(
            ElrefeLoc(MT.QU9, gauss = ('RIGI=FPG9','FPG1=FPG1',), mater=('FPG1',),),
    )
