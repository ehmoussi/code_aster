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
                             components=('DX', 'DY', 'DZ',))

MMATUNS  = ArrayOfComponents(phys=PHY.MDNS_R, locatedComponents=DDL_MECA)

MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

#---------------------------------------------------------------------------------------------------
class MECA_FACE3(Element):
    """Skin element for 3D isoparametric elements - On TR3"""
    meshType = MT.TRIA3
    attrs = ((AT.BORD_ISO,'OUI'),)
    elrefe = (
        ElrefeLoc(MT.TR3, gauss=('RIGI=FPG3',), mater=('RIGI',),),
    )
    calculs = (
        OP.CALC_G(te=280,
            para_in  = ((SP.PACCELE, DDL_MECA), (SP.PDEPLAR, DDL_MECA),
                        (SP.PFR2D3D, LC.NFOR3DR), (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PPRESSR, LC.EPRE3DR), (SP.PSIGINR, LC.ESIG3DR),
                        (SP.PTHETAR, DDL_MECA), (OP.CALC_G.PVARCPR, LC.ZVARCPG),
                        (SP.PVITESS, DDL_MECA),),
            para_out = ((SP.PGTHETA, LC.EGTHETA),),
        ),

        OP.CALC_G_F(te=280,
            para_in  = ((SP.PACCELE, DDL_MECA), (SP.PDEPLAR, DDL_MECA),
                        (SP.PFF2D3D, LC.CFOR3DF), (SP.PPRESSF, LC.CPRE3DF),
                        (SP.PSIGINR, LC.ESIG3DR),
                        (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PTEMPSR, LC.MTEMPSR), (SP.PTHETAR, DDL_MECA),
                        (OP.CALC_G_F.PVARCPR, LC.ZVARCPG), (SP.PVITESS, DDL_MECA),),
            para_out = ((SP.PGTHETA, LC.EGTHETA),),
        ),

        OP.CALC_K_G(te=311,
            para_in  = ((OP.CALC_K_G.PBASLOR, LC.N9NEUT_R), (OP.CALC_K_G.PCOMPOR, LC.CCOMPOR),
                        (SP.PCOURB, LC.G27NEUTR), (SP.PDEPLAR, DDL_MECA),
                        (SP.PEPSINR, LC.CEPS3DR), (SP.PFR2D3D, LC.NFOR3DR),
                        (SP.PFRVOLU, LC.NFOR3DR), (SP.PGEOMER, LC.EGEOM3D),
                        (OP.CALC_K_G.PLSN, LC.N1NEUT_R), (OP.CALC_K_G.PLST, LC.N1NEUT_R),
                        (SP.PPESANR, LC.CPESANR), (SP.PPRESSR, LC.EPRE3DR), 
                        (SP.PROTATR, LC.CROTATR), (SP.PSIGINR, LC.ESIG3DR),
                        (SP.PMATERC, LC.CMATERC), (SP.PPULPRO, LC.CFREQR),
                        (SP.PTHETAR, DDL_MECA), (OP.CALC_K_G.PVARCPR, LC.ZVARCPG),
                        (SP.PVARCRR, LC.ZVARCPG),),
            para_out = ((SP.PGTHETA, LC.CTHET3D),),
        ),

        OP.CALC_K_G_F(te=311,
            para_in  = ((OP.CALC_K_G_F.PBASLOR, LC.N9NEUT_R), (OP.CALC_K_G_F.PCOMPOR, LC.CCOMPOR),
                        (SP.PCOURB, LC.G27NEUTR), (SP.PDEPLAR, DDL_MECA),
                        (SP.PEPSINF, LC.CEPS3DF), (SP.PFF2D3D, LC.CFOR3DF),
                        (SP.PFFVOLU, LC.CFOR3DF), (SP.PGEOMER, LC.EGEOM3D),
                        (OP.CALC_K_G_F.PLSN, LC.N1NEUT_R), (OP.CALC_K_G_F.PLST, LC.N1NEUT_R),
                        (SP.PMATERC, LC.CMATERC), (SP.PPESANR, LC.CPESANR),
                        (SP.PPRESSF, LC.CPRE3DF), (SP.PPULPRO, LC.CFREQR),
                        (SP.PROTATR, LC.CROTATR), (SP.PSIGINR, LC.ESIG3DR),
                        (SP.PTEMPSR, LC.MTEMPSR), (SP.PTHETAR, DDL_MECA),
                        (OP.CALC_K_G_F.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),),
            para_out = ((SP.PGTHETA, LC.CTHET3D),),
        ),

        OP.CARA_SECT_POU3R(te=337,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PORIGIN, LC.CGEOM3D),),
            para_out = ((SP.PRAYONM, LC.CRADIUS),),
        ),

        OP.CARA_SECT_POUT3(te=337,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D),),
            para_out = ((SP.PCASECT, LC.CSECT3D),),
        ),

        OP.CARA_SECT_POUT4(te=337,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PORIGIN, LC.CGEOM3D),),
            para_out = ((SP.PVECTU1, MVECTUR), (SP.PVECTU2, MVECTUR),),
        ),

        OP.CARA_SECT_POUT5(te=337,
            para_in  = ((OP.CARA_SECT_POUT5.PCAORIE, LC.CGEOM3D), (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PNUMMOD, LC.CNUMMOD), (SP.PORIGFI, LC.CGEOM3D),
                        (SP.PORIGIN, LC.CGEOM3D),),
            para_out = ((SP.PVECTU1, MVECTUR), (SP.PVECTU2, MVECTUR),
                        (SP.PVECTU3, MVECTUR), (SP.PVECTU4, MVECTUR),
                        (SP.PVECTU5, MVECTUR), (SP.PVECTU6, MVECTUR),),
        ),

        OP.CHAR_MECA_EFON_F(te=18,
            para_in  = ((SP.PEFOND, LC.CEFOND), (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PPREFFF, LC.CPRE3DF), (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_EFON_R(te=18,
            para_in  = ((SP.PEFOND, LC.CEFOND), (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PPREFFR, LC.EPRE3DR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_EFSU_F(te=424,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PEFOND, LC.CEFOND), (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PPREFFF, LC.CPRE3DF), (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_EFSU_R(te=424,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PEFOND, LC.CEFOND), (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PPREFFR, LC.EPRE3DR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_FF2D3D(te=29,
            para_in  = ((SP.PFF2D3D, LC.CFOR3DF), (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_FR2D3D(te=28,
            para_in  = ((SP.PFR2D3D, LC.NFOR3DR), (SP.PGEOMER, LC.EGEOM3D),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_PRES_F(te=18,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PPRESSF, LC.CPRE3DF),
                        (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_PRES_R(te=18,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PPRESSR, LC.EPRE3DR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_PRSU_F(te=424,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PGEOMER, LC.EGEOM3D), (SP.PPRESSF, LC.CPRE3DF),
                        (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_PRSU_R(te=424,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PGEOMER, LC.EGEOM3D), (SP.PPRESSR, LC.EPRE3DR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.COOR_ELGA(te=488,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D),),
            para_out = ((OP.COOR_ELGA.PCOORPG, LC.EGGAU3D),),
        ),

        OP.INIT_VARC(te=99,
            para_out = ((OP.INIT_VARC.PVARCPR, LC.ZVARCPG),),
        ),

        OP.NORME_L2(te=563,
            para_in  = ((SP.PCALCI, LC.EMNEUT_I), (SP.PCHAMPG, LC.EGTINIR),
                        (SP.PCOEFR, LC.CNORML2), (OP.NORME_L2.PCOORPG, LC.EGGAU3D),),
            para_out = ((SP.PNORME, LC.ENORME),),
        ),

        OP.NSPG_NBVA(te=496,
            para_in  = ((OP.NSPG_NBVA.PCOMPOR, LC.CCOMPO2),),
            para_out = ((SP.PDCEL_I, LC.EDCEL_I),),
        ),

        OP.RIGI_MECA_EFSU_F(te=424,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PEFOND, LC.CEFOND),
                        (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PPREFFF, LC.CPRE3DF), (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PMATUNS, MMATUNS),),
        ),

        OP.RIGI_MECA_EFSU_R(te=424,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PEFOND, LC.CEFOND), (SP.PGEOMER, LC.EGEOM3D),
                        (SP.PPREFFR, LC.EPRE3DR),),
            para_out = ((SP.PMATUNS, MMATUNS),),
        ),

        OP.RIGI_MECA_PRSU_F(te=424,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PGEOMER, LC.EGEOM3D), (SP.PPRESSF, LC.CPRE3DF),
                        (SP.PTEMPSR, LC.MTEMPSR),),
            para_out = ((SP.PMATUNS, MMATUNS),),
        ),

        OP.RIGI_MECA_PRSU_R(te=424,
            para_in  = ((SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                        (SP.PGEOMER, LC.EGEOM3D), (SP.PPRESSR, LC.EPRE3DR),),
            para_out = ((SP.PMATUNS, MMATUNS),),
        ),

        OP.SIRO_ELEM(te=411,
            para_in  = ((SP.PGEOMER, LC.EGEOM3D), (SP.PSIG3D, LC.ESIG3DR),),
            para_out = ((SP.PPJSIGM, LC.EPJSIGM),),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out = ((SP.PFORC_R, LC.CFOR3DR), (OP.TOU_INI_ELEM.PPRES_R, LC.CPRE3DR),),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out = ((OP.TOU_INI_ELGA.PDEPL_R, LC.EGDEP3D), (OP.TOU_INI_ELGA.PGEOM_R, LC.EGGEO3D),
                        (OP.TOU_INI_ELGA.PNEUT_F, LC.EGTINIF), (OP.TOU_INI_ELGA.PNEUT_R, LC.EGTINIR),
                        (OP.TOU_INI_ELGA.PPRES_R, LC.EPRESGA),),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out = ((OP.TOU_INI_ELNO.PGEOM_R, LC.EGEOM3D), (OP.TOU_INI_ELNO.PNEUT_F, LC.ENNEUT_F),
                        (OP.TOU_INI_ELNO.PNEUT_R, LC.ENNEUT_R), (OP.TOU_INI_ELNO.PPRES_R, LC.EPRE3DR),
                        (OP.TOU_INI_ELNO.PSIEF_R, LC.ESIG3DR),),
        ),
    )

#---------------------------------------------------------------------------------------------------
class MECA_FACE4(MECA_FACE3):
    """Skin element for 3D isoparametric elements - On QU4"""
    meshType = MT.QUAD4
    attrs = ((AT.BORD_ISO,'OUI'),)
    elrefe = (
        ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG4',), mater=('RIGI',),),
    )

#---------------------------------------------------------------------------------------------------
class MECA_FACE6(MECA_FACE3):
    """Skin element for 3D isoparametric elements - On TR6"""
    meshType = MT.TRIA6
    attrs = ((AT.BORD_ISO,'OUI'),)
    elrefe = (
        ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6',), mater=('RIGI',),),
    )

#---------------------------------------------------------------------------------------------------
class MECA_FACE8(MECA_FACE3):
    """Skin element for 3D isoparametric elements - On QU8"""
    meshType = MT.QUAD8
    attrs = ((AT.BORD_ISO,'OUI'),)
    elrefe = (
        ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9',), mater=('RIGI',),),
    )

#---------------------------------------------------------------------------------------------------
class MECA_FACE9(MECA_FACE3):
    """Skin element for 3D isoparametric elements - On QU9"""
    meshType = MT.QUAD9
    attrs = ((AT.BORD_ISO,'OUI'),)
    elrefe = (
        ElrefeLoc(MT.QU9, gauss = ('RIGI=FPG9',), mater=('RIGI',),),
    )
