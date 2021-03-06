# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# CATALOGUES DES ELEMENTS TARDIF DP X-FEM GRAND GLISSEMENT (HEAVISIDE ET CRACK TIP)


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
                             ('EN1', ('DX', 'DY', 'H1X', 'H1Y', 'LAGS_C',
                                      'LAGS_F1',)),
                             ('EN2', ('DX', 'DY', 'H1X', 'H1Y',)),
                                 ('EN3', ('DX', 'DY', 'H1X', 'H1Y', 'K1',
                                          'K2', 'LAGS_C', 'LAGS_F1',)),
                                 ('EN4', ('DX', 'DY', 'H1X', 'H1Y', 'K1',
                                          'K2',)),
                                 ('EN5', ('K1', 'K2', 'LAGS_C', 'LAGS_F1',)),))


NGEOMER = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
                            components=('X', 'Y',))


CCONCF = LocatedComponents(phys=PHY.N120_I, type='ELEM',
                           components=('X[9]',))


STANO_I = LocatedComponents(phys=PHY.N120_I, type='ELEM',
                            components=('X[16]',))


CCONPI = LocatedComponents(phys=PHY.N120_R, type='ELEM',
                           components=('X[14]',))


CCONAI = LocatedComponents(phys=PHY.N480_R, type='ELEM',
                           components=('X[35]',))

BASLO_R  = LocatedComponents(phys=PHY.N480_R, type='ELEM',
    components=('X[96]',))

LSN_R  = LocatedComponents(phys=PHY.NEUT_R, type='ELEM',
    components=('X[16]',))

MVECTUR = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

MMATUUR = ArrayOfComponents(
    phys=PHY.MDEP_R, locatedComponents=DDL_MECA)

MMATUNS = ArrayOfComponents(
    phys=PHY.MDNS_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class MEDPQ4HQ4H_XH(Element):

    """Please document this element"""
    meshType = MT.QU4QU4
    nodes = (
        SetOfNodes('EN2', (5, 6, 7, 8,)),
        SetOfNodes('EN1', (1, 2, 3, 4,)),
    )
    elrefe = (
        ElrefeLoc(MT.QU4, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE2, gauss=('NOEU=NOEU',),),
    )
    calculs = (

        OP.CHAR_MECA_CONT(te=367,
                          para_in=((SP.PCAR_AI, CCONAI), (SP.PCAR_CF, CCONCF),
                                   (SP.PCAR_PI, CCONPI), (SP.PCAR_PT, LC.CCONPT),
                                   (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA),
                                   (SP.PGEOMER, NGEOMER), (OP.CHAR_MECA_CONT.PHEA_NO, LC.N40NEUI),
                                   (OP.CHAR_MECA_CONT.PSTANO, STANO_I), (SP.PMATERC, LC.CMATERC),
                                   (OP.CHAR_MECA_CONT.PLSNGG, LSN_R),(OP.CHAR_MECA_CONT.PBASLOC, BASLO_R),),
                          para_out=((SP.PVECTCR, MVECTUR), (SP.PVECTFR, MVECTUR),),
                          ),

        OP.RIGI_CONT(te=366,
                     para_in=((SP.PCAR_AI, CCONAI), (SP.PCAR_CF, CCONCF),
                              (SP.PCAR_PI, CCONPI), (SP.PCAR_PT, LC.CCONPT),
                         (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA),
                         (SP.PGEOMER, NGEOMER), (OP.RIGI_CONT.PHEA_NO, LC.N40NEUI),
                         (OP.RIGI_CONT.PSTANO, STANO_I), (OP.RIGI_CONT.PLSNGG, LSN_R),
                     (SP.PMATERC, LC.CMATERC), (OP.RIGI_CONT.PBASLOC, BASLO_R),
                     ),
                     para_out=((SP.PMATUNS, MMATUNS), (SP.PMATUUR, MMATUUR),
                               ),
                     ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM2D), ),
        ),


        OP.TOU_INI_ELNO(te=99,
                        para_out=((OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), ),
                        ),

        OP.XCVBCA(te=363,
                  para_in=((SP.PCAR_AI, CCONAI), (SP.PCAR_PT, LC.CCONPT),
                           (SP.PDEPL_P, DDL_MECA), (SP.PGEOMER, NGEOMER),
                           (OP.XCVBCA.PHEA_NO, LC.N40NEUI),
                     (OP.XCVBCA.PSTANO, STANO_I),
                     (SP.PMATERC, LC.CMATERC), (OP.XCVBCA.PLSNGG, LSN_R),
                     (OP.XCVBCA.PBASLOC, BASLO_R),),
                  para_out=((SP.PINDCOO, LC.I3NEUT_I), ),
                  ),

    )


#------------------------------------------------------------
class MEDPQ4HQ4C_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.QU4QU4
    nodes = (
        SetOfNodes('EN4', (5, 6, 7, 8,)),
        SetOfNodes('EN1', (1, 2, 3, 4,)),
    )
    elrefe = (
        ElrefeLoc(MT.QU4, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE2, gauss=('NOEU=NOEU',),),
    )


#------------------------------------------------------------
class MEDPQ4CQ4H_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.QU4QU4
    nodes = (
        SetOfNodes('EN2', (5, 6, 7, 8,)),
        SetOfNodes('EN3', (1, 2, 3, 4,)),
    )
    elrefe = (
        ElrefeLoc(MT.QU4, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE2, gauss=('NOEU=NOEU',),),
    )


#------------------------------------------------------------
class MEDPQ4CQ4C_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.QU4QU4
    nodes = (
        SetOfNodes('EN4', (5, 6, 7, 8,)),
        SetOfNodes('EN3', (1, 2, 3, 4,)),
    )
    elrefe = (
        ElrefeLoc(MT.QU4, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE2, gauss=('NOEU=NOEU',),),
    )


#------------------------------------------------------------
class MEDPQ4T_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.QUAD4
    nodes = (
        SetOfNodes('EN5', (1, 2, 3, 4,)),
    )
    elrefe = (
        ElrefeLoc(MT.QU4, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE2, gauss=('NOEU=NOEU',),),
    )


#------------------------------------------------------------
class MEDPT3HT3H_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.TR3TR3
    nodes = (
        SetOfNodes('EN2', (4, 5, 6,)),
        SetOfNodes('EN1', (1, 2, 3,)),
    )
    elrefe = (
        ElrefeLoc(MT.TR3, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE2, gauss=('NOEU=NOEU',),),
    )


#------------------------------------------------------------
class MEDPT3HT3C_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.TR3TR3
    nodes = (
        SetOfNodes('EN4', (4, 5, 6,)),
        SetOfNodes('EN1', (1, 2, 3,)),
    )
    elrefe = (
        ElrefeLoc(MT.TR3, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE2, gauss=('NOEU=NOEU',),),
    )


#------------------------------------------------------------
class MEDPT3CT3H_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.TR3TR3
    nodes = (
        SetOfNodes('EN2', (4, 5, 6,)),
        SetOfNodes('EN3', (1, 2, 3,)),
    )
    elrefe = (
        ElrefeLoc(MT.TR3, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE2, gauss=('NOEU=NOEU',),),
    )


#------------------------------------------------------------
class MEDPT3CT3C_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.TR3TR3
    nodes = (
        SetOfNodes('EN4', (4, 5, 6,)),
        SetOfNodes('EN3', (1, 2, 3,)),
    )
    elrefe = (
        ElrefeLoc(MT.TR3, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE2, gauss=('NOEU=NOEU',),),
    )


#------------------------------------------------------------
class MEDPT3T_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.TRIA3
    nodes = (
        SetOfNodes('EN5', (1, 2, 3,)),
    )
    elrefe = (
        ElrefeLoc(MT.TR3, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE2, gauss=('NOEU=NOEU',),),
    )


#------------------------------------------------------------
# appariement croises pour P1P1
class MEDPQ4HT3H_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.QU4TR3
    nodes = (
        SetOfNodes('EN2', (5, 6, 7,)),
        SetOfNodes('EN1', (1, 2, 3, 4,)),
    )
    elrefe = (
        ElrefeLoc(MT.QU4, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.TR3, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE2, gauss = ('NOEU=NOEU',),),
    )


#------------------------------------------------------------
class MEDPT3HQ4H_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.TR3QU4
    nodes = (
        SetOfNodes('EN2', (4, 5, 6, 7,)),
        SetOfNodes('EN1', (1, 2, 3,)),
    )
    elrefe = (
        ElrefeLoc(MT.TR3, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.QU4, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE2, gauss = ('NOEU=NOEU',),),
    )


#------------------------------------------------------------
class MEDPQ8HQ8H_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.QU8QU8
    nodes = (
        SetOfNodes('EN2', (5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,)),
        SetOfNodes('EN1', (1, 2, 3, 4,)),
    )
    elrefe = (
        ElrefeLoc(MT.QU8, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE3, gauss=('NOEU=NOEU',),),
    )


#------------------------------------------------------------
class MEDPT6HT6H_XH(MEDPQ4HQ4H_XH):

    """Please document this element"""
    meshType = MT.TR6TR6
    nodes = (
        SetOfNodes('EN2', (4, 5, 6, 7, 8, 9, 10, 11, 12,)),
        SetOfNodes('EN1', (1, 2, 3,)),
    )
    elrefe = (
        ElrefeLoc(MT.TR6, gauss=('NOEU=NOEU',),),
        ElrefeLoc(MT.SE3, gauss=('NOEU=NOEU',),),
    )
