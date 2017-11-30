# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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


CABSCUR = LocatedComponents(phys=PHY.ABSC_R, type='ELEM',
                            components=('ABSC[2]',))


CCAGEPO = LocatedComponents(phys=PHY.CAGEPO, type='ELEM',
                            components=('R1', 'EP1',))


CCAGNPO = LocatedComponents(phys=PHY.CAGNPO, type='ELEM',
                            components=('A1', 'IY1', 'IZ1', 'AY1', 'AZ1',
                                        'EY1', 'EZ1', 'JX1', 'RY1', 'RZ1',
                                        'RT1', 'JG1', 'A2', 'IY2', 'IZ2',
                                        'AY2', 'AZ2', 'EY2', 'EZ2', 'JX2',
                                        'RY2', 'RZ2', 'RT2', 'JG2', 'TVAR',))


CCAGNP2 = LocatedComponents(phys=PHY.CAGNPO, type='ELEM',
                            components=('A1', 'IY1', 'IZ1', 'AY1', 'AZ1',
                                        'EY1', 'EZ1', 'JX1', 'RY1', 'RZ1',
                                        'RT1', 'JG1', 'IYR21', 'IZR21', 'IY2',
                                        'IZ2', 'AY2', 'AZ2', 'EY2', 'EZ2',
                                        'JX2', 'RY2', 'RZ2', 'RT2', 'TVAR',))


CCAORIE = LocatedComponents(phys=PHY.CAORIE, type='ELEM',
                            components=('ALPHA', 'BETA', 'GAMMA',))


CCARCRI = LocatedComponents(phys=PHY.CARCRI, type='ELEM',
                            components=('ITECREL', 'MACOMP', 'RESCREL', 'THETA',
                                         'ITEDEC', 'INTLOC', 'PERTURB', 'TOLDEBO',
                                         'ITEDEBO', 'RESIRADI', 'VARIEXT1', 'THETATHM',
                                         'POSTITER', 'LC_EXT[3]', 'MATRNSYM', 'ALPHATHM',
                                         'LC_EXT2[2]', 'POSTINCR', 'STRAIN','VARIEXT2'))


DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
                             components=('DX', 'DY', 'DZ', 'DRX', 'DRY',
                                         'DRZ', 'DRGX', 'DRGY', 'DRGZ',))


NVITER = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
                           components=('DX', 'DY', 'DZ',))


CEPSINR = LocatedComponents(phys=PHY.EPSI_R, type='ELEM',
                            components=('EPX', 'KY', 'KZ',))


CEPSINF  = LocatedComponents(phys=PHY.EPSI_F, type='ELEM',
                             components=('EPX', 'KY', 'KZ',))


EDEFGNO = LocatedComponents(phys=PHY.EPSI_R, type='ELNO',
                            components=('EPXX', 'GAXY', 'GAXZ', 'GAT', 'KY',
                                        'KZ', 'GAX',))


EDFVCPG = LocatedComponents(phys=PHY.EPSI_R, type='ELGA', location='RIGI',
                            components=('EPTHER_L',))


EDFVCNO = LocatedComponents(phys=PHY.EPSI_R, type='ELNO',
                            components=('EPTHER_L',))


CFORCEF = LocatedComponents(phys=PHY.FORC_F, type='ELEM',
                            components=('FX', 'FY', 'FZ', 'MX', 'MY',
                                        'MZ', 'REP','MGX','MGY','MGZ',))

CFORCER = LocatedComponents(phys=PHY.FORC_R, type='ELEM',
                            components=('FX','FY', 'FZ', 'MX', 'MY',
                                        'MZ','REP','MGX','MGY','MGZ',))

EGGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
                             components=('X', 'Y', 'Z',))


NGEOMER = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
                            components=('X', 'Y', 'Z',))


EGGEOP_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
                             components=('X', 'Y', 'Z', 'W',))


CTEMPSR = LocatedComponents(phys=PHY.INST_R, type='ELEM',
                            components=('INST',))


ENBSP_I = LocatedComponents(phys=PHY.NBSP_I, type='ELEM',
                            components=('NBFIBR', 'NBGRFI', 'TYGRFI', 'NBCARMAX', 'NUG[10]',))


EGNEUT_F = LocatedComponents(phys=PHY.NEUT_F, type='ELGA', location='RIGI',
                             components=('X[30]',))


EGNEUT_R = LocatedComponents(phys=PHY.NEUT_R, type='ELGA', location='RIGI',
                             components=('X[30]',))


EMNEUT_R = LocatedComponents(phys=PHY.NEUT_R, type='ELGA', location='MATER',
                             components=('X1',))


EREFCO = LocatedComponents(phys=PHY.PREC, type='ELEM',
                           components=('EFFORT', 'MOMENT',))


EEFGENC = LocatedComponents(phys=PHY.SIEF_C, type='ELNO',
                            components=('N', 'VY', 'VZ', 'MT', 'MFY',
                                        'MFZ', 'MGX','MGY','MGZ',))


ECONTPC = LocatedComponents(phys=PHY.SIEF_C, type='ELGA', location='RIGI',
                            components=('SIXX',))


ECONTNC = LocatedComponents(phys=PHY.SIEF_C, type='ELNO',
                            components=('SIXX',))


EEFGENO = LocatedComponents(phys=PHY.SIEF_R, type='ELNO',
                            components=('N', 'VY', 'VZ', 'MT', 'MFY',
                                        'MFZ', 'MGX','MGY','MGZ',))


ECONTPG = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='RIGI',
                            components=('SIXX',))


ECONTNO = LocatedComponents(phys=PHY.SIEF_R, type='ELNO',
                            components=('SIXX',))


ECOEQPG = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='RIGI',
                            components=(
                                'VMIS', 'TRESCA', 'PRIN_[3]', 'VMIS_SG', 'VECT_1_X',
                            'VECT_1_Y', 'VECT_1_Z', 'VECT_2_X', 'VECT_2_Y', 'VECT_2_Z',
                            'VECT_3_X', 'VECT_3_Y', 'VECT_3_Z', 'TRSIG', 'TRIAX',))


EGAMIMA = LocatedComponents(phys=PHY.SPMX_R, type='ELGA', location='RIGI',
                            components=(
                                'VAL', 'NUCOU', 'NUSECT', 'NUFIBR', 'POSIC',
                            'POSIS',))


ESTRAUX = LocatedComponents(phys=PHY.STRX_R, type='ELGA', location='RIGI',
                            components=('N', 'VY', 'VZ', 'MT', 'MFY',
                                        'MFZ', 'BX', 'EPXX', 'GAXY', 'GAXZ',
                                        'GAT', 'KY', 'KZ', 'GAX', 'DXINT',
                                        'ALPHA', 'BETA', 'GAMMA','MGX','MGY','MGZ'))


ZVARIPG = LocatedComponents(phys=PHY.VARI_R, type='ELGA', location='RIGI',
                            components=('VARI',))

MVECTUR = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

MMATUUR = ArrayOfComponents(
    phys=PHY.MDEP_R, locatedComponents=DDL_MECA)

MMATUNS = ArrayOfComponents(
    phys=PHY.MDNS_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class MECA_POU_D_SQUE(Element):

    """Please document this element"""
    meshType = MT.SEG2
    elrefe = (
        ElrefeLoc(
            MT.SE2, gauss=(
                'RIGI=FPG2', 'FPG1=FPG1',), mater=('RIGI', 'FPG1',),),
    )
    calculs = (


        OP.CHAR_MECA_FF1D1D(te=150,
                            para_in=(
                            (SP.PCAGNPO, CCAGNPO), (
                                OP.CHAR_MECA_FF1D1D.PCAORIE, CCAORIE),
                            (SP.PFF1D1D, CFORCEF), (SP.PGEOMER, NGEOMER),
                            (SP.PTEMPSR, CTEMPSR), ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.CHAR_MECA_FR1D1D(te=150,
                            para_in=(
                            (SP.PCAGNPO, CCAGNPO), (
                                OP.CHAR_MECA_FR1D1D.PCAORIE, CCAORIE),
                            (SP.PFR1D1D, CFORCER), (SP.PGEOMER, NGEOMER),
                            ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.CHAR_MECA_PESA_R(te=150,
                            para_in=(
                            (SP.PCAGNPO, CCAGNPO), (
                                OP.CHAR_MECA_PESA_R.PCAORIE, CCAORIE),
                            (OP.CHAR_MECA_PESA_R.PCOMPOR, LC.CCOMPOR), (
                            SP.PFIBRES, LC.ECAFIEL),
                            (SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                            (OP.CHAR_MECA_PESA_R.PNBSP_I, ENBSP_I), (
                            SP.PPESANR, LC.CPESANR),
                            (OP.CHAR_MECA_PESA_R.PVARCPR, LC.ZVARCPG), ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.CHAR_MECA_TEMP_R(te=150,
                            para_in=(
                            (SP.PCAGNPO, CCAGNPO), (
                                OP.CHAR_MECA_TEMP_R.PCAORIE, CCAORIE),
                            (OP.CHAR_MECA_TEMP_R.PCOMPOR, LC.CCOMPOR), (
                            SP.PFIBRES, LC.ECAFIEL),
                            (SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                            (OP.CHAR_MECA_TEMP_R.PNBSP_I, ENBSP_I), (
                            OP.CHAR_MECA_TEMP_R.PVARCPR, LC.ZVARCPG),
                            (SP.PVARCRR, LC.ZVARCPG), ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.COOR_ELGA(te=478,
                     para_in=(
                     (OP.COOR_ELGA.PCAORIE, CCAORIE), (SP.PFIBRES, LC.ECAFIEL),
                     (SP.PGEOMER, NGEOMER), (OP.COOR_ELGA.PNBSP_I, ENBSP_I),
                     ),
                     para_out=((OP.COOR_ELGA.PCOORPG, EGGEOP_R), ),
                     ),

        OP.COOR_ELGA_MATER(te=463,
                           para_in=(
                           (OP.COOR_ELGA_MATER.PCAORIE, CCAORIE), (
                           SP.PFIBRES, LC.ECAFIEL),
                           (SP.PGEOMER, NGEOMER), (
                           OP.COOR_ELGA_MATER.PNBSP_I, ENBSP_I),
                           ),
                           para_out=((SP.PCOOPGM, LC.EGGEMA_R), ),
                           ),

        OP.DEGE_ELNO(te=158,
                     para_in=(
                         (SP.PCAGNPO, CCAGNPO), (
                             OP.DEGE_ELNO.PCAORIE, CCAORIE),
                     (OP.DEGE_ELNO.PCOMPOR, LC.CCOMPOR), (SP.PDEPLAR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                     (OP.DEGE_ELNO.PVARCPR, LC.ZVARCPG), (
                         SP.PVARCRR, LC.ZVARCPG),
                     ),
                     para_out=((SP.PDEFOGR, EDEFGNO), ),
                     ),

        OP.EFGE_ELNO(te=185,
                     para_in=(
                         (SP.PCAGNPO, CCAGNPO), (
                             OP.EFGE_ELNO.PCAORIE, CCAORIE),
                     (OP.EFGE_ELNO.PCOMPOR, LC.CCOMPOR), (
                     OP.EFGE_ELNO.PCONTRR, ECONTPG),
                     (SP.PDEPLAR, DDL_MECA), (SP.PFIBRES, LC.ECAFIEL),
                     (SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                     (OP.EFGE_ELNO.PNBSP_I, ENBSP_I), (SP.PNONLIN, LC.ENONLIN),
                     (OP.EFGE_ELNO.PSTRXRR, ESTRAUX), (
                         OP.EFGE_ELNO.PVARCPR, LC.ZVARCPG),
                     ),
                     para_out=(
                         (SP.PEFFORC, EEFGENC), (
                             OP.EFGE_ELNO.PEFFORR, EEFGENO),
                     ),
                     ),

        OP.FORC_NODA(te=517,
                     para_in=(
                         (SP.PCAGNPO, CCAGNPO), (
                             OP.FORC_NODA.PCAORIE, CCAORIE),
                     (OP.FORC_NODA.PCOMPOR, LC.CCOMPOR), (
                     OP.FORC_NODA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PFIBRES, LC.ECAFIEL), (SP.PGEOMER, NGEOMER),
                     (SP.PMATERC, LC.CMATERC), (OP.FORC_NODA.PNBSP_I, ENBSP_I),
                     (SP.PSTRXMR, ESTRAUX), (OP.FORC_NODA.PVARCPR, LC.ZVARCPG),
                     ),
                     para_out=((SP.PVECTUR, MVECTUR), ),
                     ),

        OP.FULL_MECA(te=540,
                     para_in=(
                         (SP.PCAGNPO, CCAGNP2), (
                             OP.FULL_MECA.PCAORIE, CCAORIE),
                     (SP.PCARCRI, CCARCRI), (OP.FULL_MECA.PCOMPOR, LC.CCOMPOR),
                     (OP.FULL_MECA.PCONTMR, ECONTPG), (SP.PDDEPLA, DDL_MECA),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PFIBRES, LC.ECAFIEL), (SP.PGEOMER, NGEOMER),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                     (SP.PITERAT, LC.CITERAT), (SP.PMATERC, LC.CMATERC),
                     (OP.FULL_MECA.PNBSP_I, ENBSP_I), (SP.PSTRXMP, ESTRAUX),
                     (SP.PSTRXMR, ESTRAUX), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.FULL_MECA.PVARCPR, LC.ZVARCPG), (
                         SP.PVARCRR, LC.ZVARCPG),
                     (SP.PVARIMP, ZVARIPG), (OP.FULL_MECA.PVARIMR, ZVARIPG),
                     ),
                     para_out=(
                     (SP.PCODRET, LC.ECODRET), (OP.FULL_MECA.PCONTPR, ECONTPG),
                     (SP.PMATUUR, MMATUUR), (SP.PSTRXPR, ESTRAUX),
                     (OP.FULL_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTUR),
                     ),
                     ),

        OP.INIT_VARC(te=99,
                     para_out=((OP.INIT_VARC.PVARCPR, LC.ZVARCPG), ),
                     ),

        OP.INI_SP_MATER(te=99,
                        para_out=(
                            (SP.PHYDMAT, LC.EHYDRMA), (SP.PNEUMAT, EMNEUT_R),
                        (SP.PTEMMAT, LC.ETEMPMA), ),
                        ),

        OP.INI_STRX(te=23,
                    para_in=((OP.INI_STRX.PCAORIE, CCAORIE), ),
                    para_out=((SP.PSTRX_R, ESTRAUX), ),
                    ),

        OP.MINMAX_SP(te=99,
                     para_out=((SP.PGAMIMA, EGAMIMA), (SP.PNOMIMA, LC.ENOMIMA),
                               ),
                     ),

        OP.NSPG_NBVA(te=496,
                     para_in=(
                     (OP.NSPG_NBVA.PCOMPOR, LC.CCOMPO2), (
                     OP.NSPG_NBVA.PNBSP_I, ENBSP_I),
                     ),
                     para_out=((SP.PDCEL_I, LC.EDCEL_I), ),
                     ),

        OP.RAPH_MECA(te=540,
                     para_in=(
                         (SP.PCAGNPO, CCAGNP2), (
                             OP.RAPH_MECA.PCAORIE, CCAORIE),
                     (SP.PCARCRI, CCARCRI), (OP.RAPH_MECA.PCOMPOR, LC.CCOMPOR),
                     (OP.RAPH_MECA.PCONTMR, ECONTPG), (SP.PDDEPLA, DDL_MECA),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PFIBRES, LC.ECAFIEL), (SP.PGEOMER, NGEOMER),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                     (SP.PITERAT, LC.CITERAT), (SP.PMATERC, LC.CMATERC),
                     (OP.RAPH_MECA.PNBSP_I, ENBSP_I), (SP.PSTRXMP, ESTRAUX),
                     (SP.PSTRXMR, ESTRAUX), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.RAPH_MECA.PVARCPR, LC.ZVARCPG), (
                         SP.PVARCRR, LC.ZVARCPG),
                     (SP.PVARIMP, ZVARIPG), (OP.RAPH_MECA.PVARIMR, ZVARIPG),
                     ),
                     para_out=(
                     (SP.PCODRET, LC.ECODRET), (OP.RAPH_MECA.PCONTPR, ECONTPG),
                     (SP.PSTRXPR, ESTRAUX), (OP.RAPH_MECA.PVARIPR, ZVARIPG),
                     (SP.PVECTUR, MVECTUR), ),
                     ),

        OP.REFE_FORC_NODA(te=517,
                          para_in=((SP.PREFCO, EREFCO), ),
                          para_out=((SP.PVECTUR, MVECTUR), ),
                          ),

        OP.REPERE_LOCAL(te=135,
                        para_in=((OP.REPERE_LOCAL.PCAORIE, CCAORIE), ),
                        para_out=((SP.PREPLO1, LC.CGEOM3D), (SP.PREPLO2, LC.CGEOM3D),
                                  (SP.PREPLO3, LC.CGEOM3D), ),
                        ),

        OP.RIGI_MECA_TANG(te=540,
                          para_in=(
                          (SP.PCAGNPO, CCAGNP2), (
                              OP.RIGI_MECA_TANG.PCAORIE, CCAORIE),
                          (SP.PCARCRI, CCARCRI), (
                          OP.RIGI_MECA_TANG.PCOMPOR, LC.CCOMPOR),
                          (OP.RIGI_MECA_TANG.PCONTMR, ECONTPG), (
                          SP.PDDEPLA, DDL_MECA),
                          (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                          (SP.PFIBRES, LC.ECAFIEL), (SP.PGEOMER, NGEOMER),
                          (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                          (SP.PITERAT, LC.CITERAT), (SP.PMATERC, LC.CMATERC),
                          (OP.RIGI_MECA_TANG.PNBSP_I, ENBSP_I), (
                          SP.PSTRXMR, ESTRAUX),
                          (SP.PVARCMR, LC.ZVARCPG), (
                          OP.RIGI_MECA_TANG.PVARCPR, LC.ZVARCPG),
                          (SP.PVARCRR, LC.ZVARCPG), (
                          OP.RIGI_MECA_TANG.PVARIMR, ZVARIPG),
                          ),
                          para_out=((SP.PMATUUR, MMATUUR), ),
                          ),

        OP.SIEF_ELNO(te=4,
                     para_in=(
                     (OP.SIEF_ELNO.PCONTRR, ECONTPG), (
                     OP.SIEF_ELNO.PVARCPR, LC.ZVARCPG),
                     ),
                     para_out=(
                     (SP.PSIEFNOC, ECONTNC), (OP.SIEF_ELNO.PSIEFNOR, ECONTNO),
                     ),
                     ),

        OP.SIEQ_ELGA(te=335,
                     para_in=((OP.SIEQ_ELGA.PCONTRR, ECONTPG), ),
                     para_out=((OP.SIEQ_ELGA.PCONTEQ, ECOEQPG), ),
                     ),

        OP.SIEQ_ELNO(te=335,
                     para_in=((OP.SIEQ_ELNO.PCONTRR, ECONTNO), ),
                     para_out=((OP.SIEQ_ELNO.PCONTEQ, LC.ECOEQNO), ),
                     ),

        OP.SIGM_ELGA(te=546,
                     para_in=((SP.PSIEFR, ECONTPG), ),
                     para_out=((SP.PSIGMC, ECONTPC), (SP.PSIGMR, ECONTPG),
                               ),
                     ),

        OP.SIGM_ELNO(te=4,
                     para_in=((OP.SIGM_ELNO.PCONTRR, ECONTPG), ),
                     para_out=(
                     (SP.PSIEFNOC, ECONTNC), (OP.SIGM_ELNO.PSIEFNOR, ECONTNO),
                     ),
                     ),

        OP.TOU_INI_ELEM(te=99,
                        para_out=(
                        (SP.PCAFI_R, LC.ECAFIEL), (
                            OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM3D),
                        (OP.TOU_INI_ELEM.PNBSP_I, ENBSP_I), ),
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

        OP.TOU_INI_ELNO(te=99,
                        para_out=(
                        (OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), (
                        OP.TOU_INI_ELNO.PINST_R, LC.EEINST_R),
                        (OP.TOU_INI_ELNO.PNEUT_F, LC.EENEUT_F), (
                        OP.TOU_INI_ELNO.PNEUT_R, LC.EENEUT_R),
                        (OP.TOU_INI_ELNO.PSIEF_R, EEFGENO), (
                        OP.TOU_INI_ELNO.PVARI_R, LC.ZVARINO),
                        ),
                        ),

    )
