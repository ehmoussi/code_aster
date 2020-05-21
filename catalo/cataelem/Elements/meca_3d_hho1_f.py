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
import cataelem.Commons.attributes as AT

#----------------
# Modes locaux :
#----------------



DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO', diff=True,
    components=(
    ('EN1',('HHO_U[3]','HHO_V[3]','HHO_W[3]')),
    ('EN2', ()),
    )
)


EDEPLPG  = LocatedComponents(phys=PHY.DEPL_R, type='ELGA', location='RIGI',
    components=('DX','DY','DZ',))


CEPSINF  = LocatedComponents(phys=PHY.EPSI_F, type='ELEM',
    components=('EPXX','EPYY','EPZZ','EPXY','EPXZ',
          'EPYZ',))


CEPSINR  = LocatedComponents(phys=PHY.EPSI_R, type='ELEM',
    components=('EPXX','EPYY','EPZZ','EPXY','EPXZ',
          'EPYZ',))


CFORCEF  = LocatedComponents(phys=PHY.FORC_F, type='ELEM',
    components=('FX','FY','FZ',))


CFORCER  = LocatedComponents(phys=PHY.FORC_R, type='ELEM',
    components=('FX','FY','FZ',))


NFORCER  = LocatedComponents(phys=PHY.FORC_R, type='ELNO',
    components=('FX','FY','FZ',))


EKTHETA  = LocatedComponents(phys=PHY.G, type='ELEM',
    components=('GTHETA','FIC[3]','K[3]','BETA',))


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))


EGGEOP_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
    components=('X','Y','Z','W',))


EGGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
    components=('X','Y','Z',))


CTEMPSR  = LocatedComponents(phys=PHY.INST_R, type='ELEM',
    components=('INST',))


EGNEUT_F = LocatedComponents(phys=PHY.NEUT_F, type='ELGA', location='RIGI',
    components=('X[30]',))


ERAYONM  = LocatedComponents(phys=PHY.NEUT_R, type='ELEM',
    components=('X1',))


CEFOND   = LocatedComponents(phys=PHY.NEUT_R, type='ELEM',
    components=('X1',))


ECASECT  = LocatedComponents(phys=PHY.NEUT_R, type='ELEM',
    components=('X[10]',))


EMNEUT_R = LocatedComponents(phys=PHY.NEUT_R, type='ELEM',
    components=('X[30]',))


EGNEUT_R = LocatedComponents(phys=PHY.NEUT_R, type='ELGA', location='RIGI',
    components=('X[30]',))


CPRESSF  = LocatedComponents(phys=PHY.PRES_F, type='ELEM',
    components=('PRES',))


CPRES_R  = LocatedComponents(phys=PHY.PRES_R, type='ELEM',
    components=('PRES',))


EPRESNO  = LocatedComponents(phys=PHY.PRES_R, type='ELNO',
    components=('PRES',))


ECONTNO  = LocatedComponents(phys=PHY.SIEF_R, type='ELNO',
    components=('SIXX','SIYY','SIZZ','SIXY','SIXZ',
          'SIYZ',))


MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

MMATUNS  = ArrayOfComponents(phys=PHY.MDNS_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class MECA3DQU9_HHO1_F(Element):
    """Please document this element"""
    meshType = MT.QUAD9
    nodes = (
            SetOfNodes('EN1', (9,)),
            SetOfNodes('EN2', (1,2,3,4,5,6,7,8,)),
        )
    attrs = ((AT.BORD_ISO,'OUI'),)
    elrefe =(
            ElrefeLoc(MT.QU9, gauss = ('RIGI=FPG4',), mater=('RIGI',),),
        )
    calculs = (

        OP.CHAR_MECA_PRES_F(te=459,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PPRESSF, CPRESSF),
                     (SP.PTEMPSR, CTEMPSR), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_PRES_R(te=459,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PPRESSR, EPRESNO),),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_FF2D3D(te=459,
            para_in=((SP.PFF2D3D, CFORCEF), (SP.PGEOMER, NGEOMER),
                     (SP.PTEMPSR, CTEMPSR), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_FR2D3D(te=459,
            para_in=((SP.PFR2D3D, NFORCER), (SP.PGEOMER, NGEOMER),),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.NSPG_NBVA(te=496,
            para_in=((OP.NSPG_NBVA.PCOMPOR, LC.CCOMPO2), ),
            para_out=((SP.PDCEL_I, LC.EDCEL_I), ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((SP.PFORC_R, CFORCER), (OP.TOU_INI_ELEM.PPRES_R, CPRES_R),
                     ),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out=((OP.TOU_INI_ELGA.PDEPL_R, EDEPLPG), (OP.TOU_INI_ELGA.PGEOM_R, EGGEOM_R),
                     (OP.TOU_INI_ELGA.PNEUT_F, EGNEUT_F), (OP.TOU_INI_ELGA.PNEUT_R, EGNEUT_R),
                     (OP.TOU_INI_ELGA.PPRES_R, LC.EPRESGA), ),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), (OP.TOU_INI_ELNO.PNEUT_F, LC.ENNEUT_F),
                     (OP.TOU_INI_ELNO.PNEUT_R, LC.ENNEUT_R), (OP.TOU_INI_ELNO.PPRES_R, EPRESNO),
                     (OP.TOU_INI_ELNO.PSIEF_R, ECONTNO), ),
        ),
    )
#------------------------------------------------------------
class MECA3DTR4_HHO1_F(MECA3DQU9_HHO1_F):
   """Please document this element"""
   meshType = MT.TRIA4
   nodes = (
           SetOfNodes('EN1', (4,)),
           SetOfNodes('EN2', (1,2,3,)),
       )
   attrs = ((AT.BORD_ISO,'OUI'),)
   elrefe =(
           ElrefeLoc(MT.TR4, gauss = ('RIGI=FPG3',), mater=('RIGI',),),
       )
