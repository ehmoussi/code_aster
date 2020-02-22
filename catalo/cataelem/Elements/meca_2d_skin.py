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

#----------------------------------------------------------------------------------------------
# Located components
#----------------------------------------------------------------------------------------------

DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
                             components=('DX', 'DY', ))

MMATUNS  = ArrayOfComponents(phys=PHY.MDNS_R, locatedComponents=DDL_MECA)

MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

#---------------------------------------------------------------------------------------------------
class MEPLSE2(Element):
    """Skin element for 2D isoparametric elements - On SE2"""
    meshType = MT.SEG2
    attrs = ((AT.BORD_ISO,'OUI'),)
    elrefe = (
        ElrefeLoc(MT.SE2, gauss = ('RIGI=FPG2',), mater=('RIGI',),),
    )
    calculs = (
        OP.CALC_G(te=282,
            para_in  = ((SP.PACCELE, DDL_MECA), (SP.PDEPLAR, DDL_MECA),
                        (SP.PFR1D2D, LC.NFOR2DR), (SP.PGEOMER, LC.EGEOM2D),
                        (SP.PPRESSR, LC.EPRE2DR), 
                        (SP.PTHETAR, DDL_MECA), (OP.CALC_G.PVARCPR, LC.ZVARCPG),
                        (SP.PVITESS, DDL_MECA),),
            para_out = ((SP.PGTHETA, LC.EGTHETA),),
        ),

        OP.CALC_G_F(te=282,
            para_in  = ((SP.PACCELE, DDL_MECA), (SP.PDEPLAR, DDL_MECA),
                        (SP.PFF1D2D, LC.CFOR2DF),  (SP.PPRESSF, LC.CPRE2DF),
                        (SP.PGEOMER, LC.EGEOM2D),
                        (SP.PTEMPSR, LC.MTEMPSR), (SP.PTHETAR, DDL_MECA),
                        (OP.CALC_G_F.PVARCPR, LC.ZVARCPG), (SP.PVITESS, DDL_MECA),),
            para_out = ((SP.PGTHETA, LC.EGTHETA),),
        ),

        OP.CALC_K_G(te=300,
            para_in  = ((SP.PDEPLAR, DDL_MECA), (SP.PFISSR, LC.CFISSR),
                        (SP.PFR1D2D, LC.NFOR2DR), (SP.PGEOMER, LC.EGEOM2D),
                        (SP.PPRESSR, LC.EPRE2DR),
                        (SP.PMATERC, LC.CMATERC), (SP.PPULPRO, LC.CFREQR),
                        (SP.PTHETAR, DDL_MECA), (OP.CALC_K_G.PVARCPR, LC.ZVARCPG),
                        (SP.PVARCRR, LC.ZVARCPG),),
            para_out = ((SP.PGTHETA, LC.CTHET2D),),
        ),

        OP.CALC_K_G_F(te=300,
            para_in  = ((SP.PDEPLAR, DDL_MECA), (SP.PFF1D2D, LC.CFOR2DF),
                        (SP.PFISSR, LC.CFISSR), (SP.PGEOMER, LC.EGEOM2D),
                        (SP.PMATERC, LC.CMATERC), (SP.PPRESSF, LC.CPRE2DF),
                        (SP.PPULPRO, LC.CFREQR),
                        (SP.PTEMPSR, LC.MTEMPSR), (SP.PTHETAR, DDL_MECA),
                        (OP.CALC_K_G_F.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),),
            para_out = ((SP.PGTHETA, LC.CTHET2D),),
        ),

        OP.CARA_SECT_POUT3(te=564,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D),),
            para_out = ((SP.PCASECT, LC.CSECT2D),),
        ),

        OP.CARA_SECT_POUT4(te=564,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D), (SP.PORIGIN, LC.CGEOM2D),),
            para_out = ((SP.PVECTU1, MVECTUR), (SP.PVECTU2, MVECTUR),),
        ),

        OP.CHAR_MECA_FF1D2D(te=91,
            para_in  = ((SP.PFF1D2D, LC.CFOR2DF), (SP.PGEOMER, LC.EGEOM2D),
                        (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_FR1D2D(te=90,
            para_in  = ((SP.PFR1D2D, LC.NFOR2DR), (SP.PGEOMER, LC.EGEOM2D),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_PRES_F(te=88,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D), (SP.PPRESSF, LC.CPRE2DF),
                        (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_PRES_R(te=88,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D), (SP.PPRESSR, LC.EPRE2DR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_PRSU_F(te=573,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PGEOMER, LC.EGEOM2D), (SP.PPRESSF, LC.CPRE2DF),
                        (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_PRSU_R(te=573,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PGEOMER, LC.EGEOM2D), (SP.PPRESSR, LC.EPRE2DR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.COOR_ELGA(te=479,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D),),
            para_out = ((OP.COOR_ELGA.PCOORPG, LC.EGGAU2D),),
        ),

        OP.INIT_VARC(te=99,
            para_out = ((OP.INIT_VARC.PVARCPR, LC.ZVARCPG),),
        ),

        OP.NORME_L2(te=563,
            para_in  = ((SP.PCALCI, LC.EMNEUT_I), (SP.PCHAMPG, LC.EGTINIR),
                        (SP.PCOEFR, LC.CNORML2), (OP.NORME_L2.PCOORPG, LC.EGGAU2D),),
            para_out = ((SP.PNORME, LC.ENORME),),
        ),

        OP.NSPG_NBVA(te=496,
            para_in  = ((OP.NSPG_NBVA.PCOMPOR, LC.CCOMPO2),),
            para_out = ((SP.PDCEL_I, LC.EDCEL_I),),
        ),

        OP.RIGI_MECA_PRSU_F(te=573,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PGEOMER, LC.EGEOM2D),
                        (SP.PPRESSF, LC.CPRE2DF), (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PMATUNS, MMATUNS),),
        ),

        OP.RIGI_MECA_PRSU_R(te=573,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PGEOMER, LC.EGEOM2D),
                        (SP.PPRESSR, LC.EPRE2DR),),
            para_out = ((SP.PMATUNS, MMATUNS),),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out = ((OP.TOU_INI_ELEM.PERREUR, LC.CERROR),),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out = ((OP.TOU_INI_ELGA.PDEPL_R, LC.EGDEP3D), (OP.TOU_INI_ELGA.PGEOM_R, LC.EGGEO2D),
                        (OP.TOU_INI_ELGA.PNEUT_F, LC.EGTINIF), (OP.TOU_INI_ELGA.PNEUT_R, LC.EGTINIR),
                        (OP.TOU_INI_ELGA.PPRES_R, LC.EPRESGA),),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out = ((OP.TOU_INI_ELNO.PGEOM_R, LC.EGEOM2D), (OP.TOU_INI_ELNO.PNEUT_F, LC.ENNEUT_F),
                        (OP.TOU_INI_ELNO.PNEUT_R, LC.ENNEUT_R), (OP.TOU_INI_ELNO.PPRES_R, LC.EPRE2DR),),
        ),
    )

#---------------------------------------------------------------------------------------------------
class MEPLSE3(MEPLSE2):
    """Skin element for 2D isoparametric elements - On SE3"""
    meshType = MT.SEG3
    attrs = ((AT.BORD_ISO,'OUI'),)
    elrefe = (
        ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4',), mater=('RIGI',),),
    )

#---------------------------------------------------------------------------------------------------
class MEAXSE2(MEPLSE2):
    """Skin element for 2D isoparametric elements/axi - On SE2"""
    meshType = MT.SEG2
    attrs = ((AT.BORD_ISO,'OUI'),)
    elrefe = (
        ElrefeLoc(MT.SE2, gauss = ('RIGI=FPG2',), mater=('RIGI',),),
    )

#---------------------------------------------------------------------------------------------------
class MEAXSE3(MEPLSE2):
    """Skin element for 2D isoparametric elements/axi - On SE3"""
    meshType = MT.SEG3
    attrs = ((AT.BORD_ISO,'OUI'),)
    elrefe = (
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4',), mater=('RIGI',),),
    )
