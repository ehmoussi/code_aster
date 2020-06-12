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


DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO', diff=True,
                             components=(
                                ('EN1', ()),
                                ('EN2', ('PRE[2]',)),))


NGEOMER = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
                            components=('X', 'Y',))


EGGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
                             components=('X', 'Y',))


ENGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
                             components=('X', 'Y',))


CTEMPSR = LocatedComponents(phys=PHY.INST_R, type='ELEM',
                            components=('INST',))


EGNEUT_F = LocatedComponents(phys=PHY.NEUT_F, type='ELGA', location='RIGI',
                             components=('X[8]',))


EGNEUT_R = LocatedComponents(phys=PHY.NEUT_R, type='ELGA', location='RIGI',
                             components=('X[8]',))


ECONTPG = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='FPGCONT',
                            components=('M11', 'FH11', 'M12', 'FH12', 'M21',
                                        'FH21', 'M22', 'FH22',))


ZVARIPG = LocatedComponents(phys=PHY.VARI_R, type='ELGA', location='FPGVARI',
                            components=('VARI',))


MVECTUR = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

MMATUNS = ArrayOfComponents(
    phys=PHY.MDNS_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class DHH2Q9_SUDA(Element):

    """Please document this element"""
    meshType = MT.QUAD9
    nodes = (
        SetOfNodes('EN1', (1, 2, 3, 4,)),
        SetOfNodes('EN2', (5, 6, 7, 8, 9,)),
    )
    elrefe = (
        ElrefeLoc(
            MT.QU9, gauss=(
                'RIGI=NOEU_S', 'FPGVARI=FPG5', 'FPGCONT=FPG5', 'FPG1=FPG1',), mater=('FPG1',),),
        ElrefeLoc(MT.QU4, gauss = ('RIGI=NOEU_S',),),
    )
    calculs = (

        OP.ADD_SIGM(te=581,
                    para_in=((SP.PEPCON1, ECONTPG), (SP.PEPCON2, ECONTPG),
                             ),
                    para_out=((SP.PEPCON3, ECONTPG), ),
                    ),

        OP.FORC_NODA(te=515,
                     para_in=((OP.FORC_NODA.PCONTMR, ECONTPG), ),
                     para_out=((SP.PVECTUR, MVECTUR), ),
                     ),

        OP.FULL_MECA(te=515,
                     para_in=(
                         (SP.PCARCRI, LC.CCARCRI), (
                             OP.FULL_MECA.PCOMPOR, LC.CCOMPOR),
                     (OP.FULL_MECA.PCONTMR, ECONTPG), (SP.PDEPLMR, DDL_MECA),
                     (SP.PDEPLPR, DDL_MECA), (SP.PGEOMER, NGEOMER),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                     (SP.PMATERC, LC.CMATERC), (OP.FULL_MECA.PVARIMR, ZVARIPG),
                     ),
                     para_out=(
                     (SP.PCODRET, LC.ECODRET), (OP.FULL_MECA.PCONTPR, ECONTPG),
                     (SP.PMATUNS, MMATUNS), (OP.FULL_MECA.PVARIPR, ZVARIPG),
                     (SP.PVECTUR, MVECTUR), ),
                     ),

        OP.NSPG_NBVA(te=496,
                     para_in=((OP.NSPG_NBVA.PCOMPOR, LC.CCOMPO2), ),
                     para_out=((SP.PDCEL_I, LC.EDCEL_I), ),
                     ),

        OP.RAPH_MECA(te=515,
                     para_in=(
                         (SP.PCARCRI, LC.CCARCRI), (
                             OP.RAPH_MECA.PCOMPOR, LC.CCOMPOR),
                     (OP.RAPH_MECA.PCONTMR, ECONTPG), (SP.PDEPLMR, DDL_MECA),
                     (SP.PDEPLPR, DDL_MECA), (SP.PGEOMER, NGEOMER),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                     (SP.PMATERC, LC.CMATERC), (OP.RAPH_MECA.PVARIMR, ZVARIPG),
                     ),
                     para_out=(
                     (SP.PCODRET, LC.ECODRET), (OP.RAPH_MECA.PCONTPR, ECONTPG),
                     (OP.RAPH_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTUR),
                     ),
                     ),

        OP.RIGI_MECA_TANG(te=515,
                          para_in=(
                          (SP.PCARCRI, LC.CCARCRI), (
                              OP.RIGI_MECA_TANG.PCOMPOR, LC.CCOMPOR),
                          (OP.RIGI_MECA_TANG.PCONTMR, ECONTPG), (
                          SP.PDEPLMR, DDL_MECA),
                          (SP.PDEPLPR, DDL_MECA), (SP.PGEOMER, NGEOMER),
                          (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                          (SP.PMATERC, LC.CMATERC), (
                          OP.RIGI_MECA_TANG.PVARIMR, ZVARIPG),
                          ),
                          para_out=((SP.PMATUNS, MMATUNS), ),
                          ),

        OP.TOU_INI_ELGA(te=99,
                        para_out=(
                        (OP.TOU_INI_ELGA.PGEOM_R, EGGEOM_R), (
                        OP.TOU_INI_ELGA.PINST_R, LC.EGINST_R),
                        (OP.TOU_INI_ELGA.PNEUT_F, EGNEUT_F), (
                        OP.TOU_INI_ELGA.PNEUT_R, EGNEUT_R),
                        (OP.TOU_INI_ELGA.PSIEF_R, ECONTPG), (
                        OP.TOU_INI_ELGA.PVARI_R, ZVARIPG),
                        ),
                        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM2D), ),
        ),


        OP.TOU_INI_ELNO(te=99,
                        para_out=(
                        (OP.TOU_INI_ELNO.PGEOM_R, ENGEOM_R), (
                        OP.TOU_INI_ELNO.PINST_R, LC.ENINST_R),
                        (OP.TOU_INI_ELNO.PNEUT_F, LC.ENNEUT_F), (
                        OP.TOU_INI_ELNO.PNEUT_R, LC.ENNEUT_R),
                        ),
                        ),

    )


#------------------------------------------------------------
class DHH2T7_SUDA(DHH2Q9_SUDA):

    """Please document this element"""
    meshType = MT.TRIA7
    nodes = (
        SetOfNodes('EN1', (1, 2, 3,)),
        SetOfNodes('EN2', (4, 5, 6, 7,)),
    )
    elrefe = (
        ElrefeLoc(
            MT.TR7, gauss=(
                'RIGI=NOEU_S', 'FPGVARI=FPG4', 'FPGCONT=FPG4', 'FPG1=FPG1',), mater=('FPG1',),),
        ElrefeLoc(MT.TR3, gauss = ('RIGI=NOEU_S',),),
    )
