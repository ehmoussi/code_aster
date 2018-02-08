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

# person_in_charge: kyrylo.kazymyrenko at edf.fr


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
    ('EN1',('DX','DY','DZ','GLIS','SITY',)),
    ('EN2',('DX','DY','DZ','GLIS',)),))


EDEFONC  = LocatedComponents(phys=PHY.EPSI_C, type='ELNO',
    components=('EPXX',))


EDEFOPG  = LocatedComponents(phys=PHY.EPSI_R, type='ELGA', location='RIGI',
    components=('EPXX',))


EDEFONO  = LocatedComponents(phys=PHY.EPSI_R, type='ELNO',
    components=('EPXX',))




EGGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
    components=('X','Y','Z',))


EGGEOP_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
    components=('X','Y','Z','W',))


ENGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))


CTEMPSR  = LocatedComponents(phys=PHY.INST_R, type='ELEM',
    components=('INST',))


EGNEUT_F = LocatedComponents(phys=PHY.NEUT_F, type='ELGA', location='RIGI',
    components=('X[30]',))


EGNEUT_R = LocatedComponents(phys=PHY.NEUT_R, type='ELGA', location='RIGI',
    components=('X[30]',))


EREFCO   = LocatedComponents(phys=PHY.PREC, type='ELEM',
    components=('SIGM','EFFORT','MOMENT','DEPL',))


ECONTNC  = LocatedComponents(phys=PHY.SIEF_C, type='ELNO',
    components=('N','CONT_X','CONT_Y',))


ECONTPG  = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='RIGI',
    components=('N','CONT_X','CONT_Y',))


ECONTNO  = LocatedComponents(phys=PHY.SIEF_R, type='ELNO',
    components=('N','CONT_X','CONT_Y',))


ZVARIPG  = LocatedComponents(phys=PHY.VARI_R, type='ELGA', location='RIGI',
    components=('VARI',))


MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

MMATUUR  = ArrayOfComponents(phys=PHY.MDEP_R, locatedComponents=DDL_MECA)

MMATUNS  = ArrayOfComponents(phys=PHY.MDNS_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class MECGSEG3(Element):
    """Please document this element"""
    meshType = MT.SEG3
    nodes = (
            SetOfNodes('EN1', (1,2,)),
            SetOfNodes('EN2', (3,)),
        )
    elrefe =(
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG2','MASS=FPG2','NOEU=NOEU','FPG1=FPG1','GANO=FPG2',), mater=('RIGI','GANO','FPG1',),),
            ElrefeLoc(MT.SE2, gauss = ('RIGI=FPG2',),),
        )
    calculs = (

        OP.ADD_SIGM(te=581,
            para_in=((SP.PEPCON1, ECONTPG), (SP.PEPCON2, ECONTPG),
                     ),
            para_out=((SP.PEPCON3, ECONTPG), ),
        ),

        OP.CHAR_MECA_HYDR_R(te=312,
                            para_in=(
                            (SP.PMATERC, LC.CMATERC), (
                            OP.CHAR_MECA_HYDR_R.PVARCPR, LC.ZVARCPG),
                            ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),
        
        OP.CHAR_MECA_SECH_R(te=312,
                            para_in=(
                            (SP.PMATERC, LC.CMATERC), (
                            OP.CHAR_MECA_HYDR_R.PVARCPR, LC.ZVARCPG),
                            ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),
        
        OP.CHAR_MECA_TEMP_R(te=312,
                            para_in=(
                            (SP.PMATERC, LC.CMATERC), (
                            OP.CHAR_MECA_HYDR_R.PVARCPR, LC.ZVARCPG),
                            ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),
        
        OP.CHAR_MECA_PESA_R(te=345,
            para_in=((SP.PCAGNBA, LC.CCAGNBA), (SP.PGEOMER, NGEOMER),
                     (SP.PMATERC, LC.CMATERC), (SP.PPESANR, LC.CPESANR),
                     (OP.CHAR_MECA_PESA_R.PVARCPR, LC.ZVARCPG), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.COOR_ELGA(te=478,
            para_in=((SP.PGEOMER, NGEOMER), ),
            para_out=((OP.COOR_ELGA.PCOORPG, EGGEOP_R), ),
        ),

        OP.EPSI_ELGA(te=438,
            para_in=((SP.PDEPLAR, DDL_MECA), (SP.PGEOMER, NGEOMER),
                     ),
            para_out=((OP.EPSI_ELGA.PDEFOPG, EDEFOPG), ),
        ),

        OP.EPSI_ELNO(te=4,
            para_in=((OP.EPSI_ELNO.PDEFOPG, EDEFOPG), ),
            para_out=((SP.PDEFONC, EDEFONC), (SP.PDEFONO, EDEFONO),
                     ),
        ),

        OP.FORC_NODA(te=341,
            para_in=((OP.FORC_NODA.PCOMPOR, LC.CCOMPOR), (OP.FORC_NODA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PGEOMER, NGEOMER),
                     (OP.FORC_NODA.PVARCPR, LC.ZVARCPG), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.FULL_MECA(te=340,
            para_in=((SP.PCAGNBA, LC.CCAGNBA), (SP.PCARCRI, LC.CCARCRI),
                     (OP.FULL_MECA.PCOMPOR, LC.CCOMPOR), (OP.FULL_MECA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (SP.PMATERC, LC.CMATERC),
                     (SP.PVARCMR, LC.ZVARCPG), (OP.FULL_MECA.PVARCPR, LC.ZVARCPG),
                     (SP.PVARCRR, LC.ZVARCPG), (SP.PVARIMP, ZVARIPG),
                     (OP.FULL_MECA.PVARIMR, ZVARIPG), ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.FULL_MECA.PCONTPR, ECONTPG),
                     (SP.PMATUNS, MMATUNS), (SP.PMATUUR, MMATUUR),
                     (OP.FULL_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTUR),
                     ),
        ),

        OP.FULL_MECA_ELAS(te=340,
            para_in=((SP.PCARCRI, LC.CCARCRI), (OP.FULL_MECA_ELAS.PCOMPOR, LC.CCOMPOR),
                     (OP.FULL_MECA_ELAS.PCONTMR, ECONTPG), (SP.PDEPLMR, DDL_MECA),
                     (SP.PDEPLPR, DDL_MECA), (SP.PGEOMER, NGEOMER),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                     (SP.PMATERC, LC.CMATERC), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.FULL_MECA_ELAS.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (SP.PVARIMP, ZVARIPG), (OP.FULL_MECA_ELAS.PVARIMR, ZVARIPG),
                     ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.FULL_MECA_ELAS.PCONTPR, ECONTPG),
                     (SP.PMATUNS, MMATUNS), (SP.PMATUUR, MMATUUR),
                     (OP.FULL_MECA_ELAS.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTUR),
                     ),
        ),

        OP.INIT_VARC(te=99,
            para_out=((OP.INIT_VARC.PVARCPR, LC.ZVARCPG), ),
        ),

        OP.NSPG_NBVA(te=496,
            para_in=((OP.NSPG_NBVA.PCOMPOR, LC.CCOMPO2), ),
            para_out=((SP.PDCEL_I, LC.EDCEL_I), ),
        ),

        OP.RAPH_MECA(te=340,
            para_in=((SP.PCAGNBA, LC.CCAGNBA), (SP.PCARCRI, LC.CCARCRI),
                     (OP.RAPH_MECA.PCOMPOR, LC.CCOMPOR), (OP.RAPH_MECA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (SP.PMATERC, LC.CMATERC),
                     (SP.PVARCMR, LC.ZVARCPG), (OP.RAPH_MECA.PVARCPR, LC.ZVARCPG),
                     (SP.PVARCRR, LC.ZVARCPG), (SP.PVARIMP, ZVARIPG),
                     (OP.RAPH_MECA.PVARIMR, ZVARIPG), ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.RAPH_MECA.PCONTPR, ECONTPG),
                     (OP.RAPH_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTUR),
                     ),
        ),

        OP.REFE_FORC_NODA(te=341,
            para_in=((SP.PCAGNBA, LC.CCAGNBA), (SP.PGEOMER, NGEOMER),
                     (SP.PREFCO, EREFCO), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.RIGI_MECA_ELAS(te=340,
            para_in=((SP.PCARCRI, LC.CCARCRI), (OP.RIGI_MECA_ELAS.PCOMPOR, LC.CCOMPOR),
                     (OP.RIGI_MECA_ELAS.PCONTMR, ECONTPG), (SP.PDEPLMR, DDL_MECA),
                     (SP.PDEPLPR, DDL_MECA), (SP.PGEOMER, NGEOMER),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                     (SP.PMATERC, LC.CMATERC), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.RIGI_MECA_ELAS.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (OP.RIGI_MECA_ELAS.PVARIMR, ZVARIPG), ),
            para_out=((SP.PMATUNS, MMATUNS), (SP.PMATUUR, MMATUUR),
                     ),
        ),

        OP.RIGI_MECA_TANG(te=340,
            para_in=((SP.PCAGNBA, LC.CCAGNBA), (SP.PCARCRI, LC.CCARCRI),
                     (OP.RIGI_MECA_TANG.PCOMPOR, LC.CCOMPOR), (OP.RIGI_MECA_TANG.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (SP.PMATERC, LC.CMATERC),
                     (SP.PVARCMR, LC.ZVARCPG), (OP.RIGI_MECA_TANG.PVARCPR, LC.ZVARCPG),
                     (SP.PVARCRR, LC.ZVARCPG), (OP.RIGI_MECA_TANG.PVARIMR, ZVARIPG),
                     ),
            para_out=((SP.PMATUNS, MMATUNS), (SP.PMATUUR, MMATUUR),
                     ),
        ),

        OP.SIEF_ELNO(te=4,
            para_in=((OP.SIEF_ELNO.PCONTRR, ECONTPG), (OP.SIEF_ELNO.PVARCPR, LC.ZVARCPG),
                     ),
            para_out=((SP.PSIEFNOC, ECONTNC), (OP.SIEF_ELNO.PSIEFNOR, ECONTNO),
                     ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM3D), ),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out=((OP.TOU_INI_ELGA.PGEOM_R, EGGEOM_R), (OP.TOU_INI_ELGA.PINST_R, LC.EGINST_R),
                     (OP.TOU_INI_ELGA.PNEUT_F, EGNEUT_F), (OP.TOU_INI_ELGA.PNEUT_R, EGNEUT_R),
                     (OP.TOU_INI_ELGA.PSIEF_R, ECONTPG), (OP.TOU_INI_ELGA.PVARI_R, ZVARIPG),
                     ),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PGEOM_R, ENGEOM_R), (OP.TOU_INI_ELNO.PINST_R, LC.ENINST_R),
                     (OP.TOU_INI_ELNO.PNEUT_F, LC.ENNEUT_F), (OP.TOU_INI_ELNO.PNEUT_R, LC.ENNEUT_R),
                     (OP.TOU_INI_ELNO.PSIEF_R, ECONTNO), (OP.TOU_INI_ELNO.PVARI_R, LC.ZVARINO),
                     ),
        ),

    )
