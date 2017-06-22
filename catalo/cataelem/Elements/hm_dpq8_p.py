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

# person_in_charge: sylvie.granet at edf.fr


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


CCAMASS = LocatedComponents(phys=PHY.CAMASS, type='ELEM',
                            components=('C', 'ALPHA',))


CCARCRI = LocatedComponents(phys=PHY.CARCRI, type='ELEM',
                            components=(
                                'ITECREL', 'MACOMP', 'RESCREL', 'THETA', 'ITEDEC',
                            'INTLOC', 'PERTURB', 'TOLDEBO', 'ITEDEBO', 'TSSEUIL',
                            'TSAMPL', 'TSRETOUR', 'POSTITER', 'LC_EXT[3]', 'MODECALC',
                            'ALPHA', 'LC_EXT2[2]',))


CCOMPOR = LocatedComponents(phys=PHY.COMPOR, type='ELEM',
                            components=(
                                'RELCOM', 'NBVARI', 'DEFORM', 'INCELA', 'C_PLAN',
                            'NUME_LC', 'SD_COMP', 'KIT[9]', 'NVI_C', 'NVI_T',
                            'NVI_H', 'NVI_M',))


DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO', diff=True,
                             components=(
                             ('EN1', ('DX', 'DY', 'PRE1',)),
                             ('EN2', ('DX', 'DY',)),))


EDEFOPC = LocatedComponents(phys=PHY.EPSI_C, type='ELGA', location='RIGI',
                            components=('EPXX', 'EPYY', 'EPZZ', 'EPXY', 'EPXZ',
                                        'EPYZ',))


EDEFONC = LocatedComponents(phys=PHY.EPSI_C, type='ELNO',
                            components=('EPXX', 'EPYY', 'EPZZ', 'EPXY', 'EPXZ',
                                        'EPYZ',))


EDEFOPG = LocatedComponents(phys=PHY.EPSI_R, type='ELGA', location='RIGI',
                            components=('EPXX', 'EPYY', 'EPZZ', 'EPXY', 'EPXZ',
                                        'EPYZ',))


EDEFONO = LocatedComponents(phys=PHY.EPSI_R, type='ELNO',
                            components=('EPXX', 'EPYY', 'EPZZ', 'EPXY', 'EPXZ',
                                        'EPYZ',))


EDFEQPG = LocatedComponents(phys=PHY.EPSI_R, type='ELGA', location='RIGI',
                            components=(
                                'INVA_2', 'PRIN_[3]', 'INVA_2SG', 'VECT_1_X', 'VECT_1_Y',
                            'VECT_1_Z', 'VECT_2_X', 'VECT_2_Y', 'VECT_2_Z', 'VECT_3_X',
                            'VECT_3_Y', 'VECT_3_Z',))


EERREUR = LocatedComponents(phys=PHY.ERRE_R, type='ELEM',
                            components=('ESTERG[2]', 'ERHMHY_L', 'ERHMME_G', 'ERHMHY_G',))


EERRENO = LocatedComponents(phys=PHY.ERRE_R, type='ELNO',
                            components=('ESTERG[2]', 'ERHMHY_L', 'ERHMME_G', 'ERHMHY_G',))


CFORCEF = LocatedComponents(phys=PHY.FORC_F, type='ELEM',
                            components=('FX', 'FY',))


EFORCER = LocatedComponents(phys=PHY.FORC_R, type='ELGA', location='RIGI',
                            components=('FX', 'FY',))


NFORCER = LocatedComponents(phys=PHY.FORC_R, type='ELNO',
                            components=('FX', 'FY',))


NGEOMER = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
                            components=('X', 'Y',))


EGGEOP_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
                             components=('X', 'Y', 'W',))


EGGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
                             components=('X', 'Y',))


ENGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
                             components=('X', 'Y',))


CTEMPSR = LocatedComponents(phys=PHY.INST_R, type='ELEM',
                            components=('INST',))


EGNEUT_F = LocatedComponents(phys=PHY.NEUT_F, type='ELGA', location='RIGI',
                             components=('X[30]',))


E1NEUTK = LocatedComponents(phys=PHY.NEUT_K24, type='ELEM',
                            components=('Z1',))


EGNEUT_R = LocatedComponents(phys=PHY.NEUT_R, type='ELGA', location='RIGI',
                             components=('X[30]',))


EREFCO = LocatedComponents(phys=PHY.PREC, type='ELEM',
                           components=('SIGM', 'FHYDR[2]', 'FTHERM',))


ESIGMPC = LocatedComponents(phys=PHY.SIEF_C, type='ELGA', location='RIGI',
                            components=('SIXX', 'SIYY', 'SIZZ', 'SIXY', 'SIXZ',
                                        'SIYZ',))


ESIGMNC = LocatedComponents(phys=PHY.SIEF_C, type='ELNO',
                            components=('SIXX', 'SIYY', 'SIZZ', 'SIXY', 'SIXZ',
                                        'SIYZ',))


ECONTNC = LocatedComponents(phys=PHY.SIEF_C, type='ELNO',
                            components=('SIXX', 'SIYY', 'SIZZ', 'SIXY', 'SIXZ',
                                        'SIYZ', 'SIPXX', 'SIPYY', 'SIPZZ', 'SIPXY',
                                        'SIPXZ', 'SIPYZ', 'FH11X', 'FH11Y',))


ESIGMPG = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='RIGI',
                            components=('SIXX', 'SIYY', 'SIZZ', 'SIXY', 'SIXZ',
                                        'SIYZ',))


ESIGMNO = LocatedComponents(phys=PHY.SIEF_R, type='ELNO',
                            components=('SIXX', 'SIYY', 'SIZZ', 'SIXY', 'SIXZ',
                                        'SIYZ',))


ECONTPG = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='RIGI',
                            components=('SIXX', 'SIYY', 'SIZZ', 'SIXY', 'SIXZ',
                                        'SIYZ', 'SIPXX', 'SIPYY', 'SIPZZ', 'SIPXY',
                                        'SIPXZ', 'SIPYZ', 'FH11X', 'FH11Y',))


ECONTNO = LocatedComponents(phys=PHY.SIEF_R, type='ELNO',
                            components=('SIXX', 'SIYY', 'SIZZ', 'SIXY', 'SIXZ',
                                        'SIYZ', 'SIPXX', 'SIPYY', 'SIPZZ', 'SIPXY',
                                        'SIPXZ', 'SIPYZ', 'FH11X', 'FH11Y',))


ECOEQPG = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='RIGI',
                            components=(
                                'VMIS', 'TRESCA', 'PRIN_[3]', 'VMIS_SG', 'VECT_1_X',
                            'VECT_1_Y', 'VECT_1_Z', 'VECT_2_X', 'VECT_2_Y', 'VECT_2_Z',
                            'VECT_3_X', 'VECT_3_Y', 'VECT_3_Z', 'TRSIG', 'TRIAX',))


ZVARIPG = LocatedComponents(phys=PHY.VARI_R, type='ELGA', location='RIGI',
                            components=('VARI',))


MVECTUR = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

MMATUUR = ArrayOfComponents(
    phys=PHY.MDEP_R, locatedComponents=DDL_MECA)

MMATUNS = ArrayOfComponents(
    phys=PHY.MDNS_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class HM_DPQ8_P(Element):

    """Please document this element"""
    meshType = MT.QUAD8
    nodes = (
        SetOfNodes('EN2', (5, 6, 7, 8,)),
        SetOfNodes('EN1', (1, 2, 3, 4,)),
    )
    elrefe = (
        ElrefeLoc(
            MT.QU8, gauss=(
                'RIGI=FPG9', 'MASS=FPG9', 'FPG1=FPG1',), mater=('RIGI', 'FPG1',),),
        ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG9',),),
        ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4',),),
    )
    calculs = (

        OP.ADD_SIGM(te=581,
                    para_in=((SP.PEPCON1, ECONTPG), (SP.PEPCON2, ECONTPG),
                             ),
                    para_out=((SP.PEPCON3, ECONTPG), ),
                    ),

        OP.CARA_GEOM(te=285,
                     para_in=((SP.PGEOMER, NGEOMER), ),
                     para_out=((SP.PCARAGE, LC.ECARAGE), ),
                     ),

        OP.CHAR_MECA_FR2D2D(te=600,
                            para_in=(
                                (SP.PFR2D2D, NFORCER), (SP.PGEOMER, NGEOMER),
                            ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.CHAR_MECA_PESA_R(te=600,
                            para_in=(
                                (SP.PGEOMER, NGEOMER), (
                                    SP.PMATERC, LC.CMATERC),
                            (SP.PPESANR, LC.CPESANR), (
                            OP.CHAR_MECA_PESA_R.PVARCPR, LC.ZVARCPG),
                            ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.COOR_ELGA(te=479,
                     para_in=((SP.PGEOMER, NGEOMER), ),
                     para_out=((OP.COOR_ELGA.PCOORPG, EGGEOP_R), ),
                     ),

        OP.EPEQ_ELGA(te=335,
                     para_in=((OP.EPEQ_ELGA.PDEFORR, EDEFOPG), ),
                     para_out=((OP.EPEQ_ELGA.PDEFOEQ, EDFEQPG), ),
                     ),

        OP.EPEQ_ELNO(te=335,
                     para_in=((OP.EPEQ_ELNO.PDEFORR, EDEFONO), ),
                     para_out=((OP.EPEQ_ELNO.PDEFOEQ, LC.EDFEQNO), ),
                     ),

        OP.EPSI_ELGA(te=600,
                     para_in=((SP.PDEPLAR, DDL_MECA), (SP.PGEOMER, NGEOMER),
                              (OP.EPSI_ELGA.PVARCPR, LC.ZVARCPG), ),
                     para_out=(
                         (SP.PDEFOPC, EDEFOPC), (
                             OP.EPSI_ELGA.PDEFOPG, EDEFOPG),
                     ),
                     ),

        OP.EPSI_ELNO(te=4,
                     para_in=((OP.EPSI_ELNO.PDEFOPG, EDEFOPG), ),
                     para_out=((SP.PDEFONC, EDEFONC), (SP.PDEFONO, EDEFONO),
                               ),
                     ),

        OP.ERME_ELEM(te=497,
                     para_in=((SP.PCONTNO, ECONTNO), (SP.PDEPLAR, DDL_MECA),
                              (SP.PFFVOLU, CFORCEF), (SP.PFORCE, LC.CREFERI),
                              (SP.PFRVOLU, EFORCER), (SP.PGEOMER, NGEOMER),
                              (SP.PGRDCA, LC.E2NEUTR), (
                                  SP.PMATERC, LC.CMATERC),
                              (SP.PPESANR, LC.CPESANR), (
                                  SP.PPRESS, LC.CREFERI),
                              (SP.PROTATR, LC.CROTATR), (SP.PTEMPSR, CTEMPSR),
                              (OP.ERME_ELEM.PVOISIN, LC.EVOISIN), ),
                     para_out=((OP.ERME_ELEM.PERREUR, EERREUR), ),
                     ),

        OP.ERME_ELNO(te=379,
                     para_in=((OP.ERME_ELNO.PERREUR, EERREUR), ),
                     para_out=((SP.PERRENO, EERRENO), ),
                     ),

        OP.FORC_NODA(te=600,
                     para_in=(
                         (OP.FORC_NODA.PCONTMR, ECONTPG), (
                             SP.PGEOMER, NGEOMER),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                     (SP.PMATERC, LC.CMATERC), (
                         OP.FORC_NODA.PVARCPR, LC.ZVARCPG),
                     ),
                     para_out=((SP.PVECTUR, MVECTUR), ),
                     ),

        OP.FULL_MECA(te=600,
                     para_in=((SP.PCAMASS, CCAMASS), (SP.PCARCRI, CCARCRI),
                              (OP.FULL_MECA.PCOMPOR, CCOMPOR), (
                              OP.FULL_MECA.PCONTMR, ECONTPG),
                              (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                              (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                              (SP.PINSTPR, CTEMPSR), (SP.PMATERC, LC.CMATERC),
                              (SP.PVARCMR, LC.ZVARCPG), (
                              OP.FULL_MECA.PVARCPR, LC.ZVARCPG),
                              (SP.PVARCRR, LC.ZVARCPG), (
                              OP.FULL_MECA.PVARIMR, ZVARIPG),
                              ),
                     para_out=(
                     (SP.PCODRET, LC.ECODRET), (OP.FULL_MECA.PCONTPR, ECONTPG),
                     (SP.PMATUNS, MMATUNS), (OP.FULL_MECA.PVARIPR, ZVARIPG),
                     (SP.PVECTUR, MVECTUR), ),
                     ),

        OP.FULL_MECA_ELAS(te=600,
                          para_in=(
                              (SP.PCAMASS, CCAMASS), (SP.PCARCRI, CCARCRI),
                          (OP.FULL_MECA_ELAS.PCOMPOR, CCOMPOR), (
                          OP.FULL_MECA_ELAS.PCONTMR, ECONTPG),
                              (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                          (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                          (SP.PINSTPR, CTEMPSR), (SP.PMATERC, LC.CMATERC),
                          (SP.PVARCMR, LC.ZVARCPG), (
                          OP.FULL_MECA_ELAS.PVARCPR, LC.ZVARCPG),
                          (SP.PVARCRR, LC.ZVARCPG), (
                          OP.FULL_MECA_ELAS.PVARIMR, ZVARIPG),
                          ),
                          para_out=(
                          (SP.PCODRET, LC.ECODRET), (
                              OP.FULL_MECA_ELAS.PCONTPR, ECONTPG),
                          (SP.PMATUNS, MMATUNS), (
                          OP.FULL_MECA_ELAS.PVARIPR, ZVARIPG),
                          (SP.PVECTUR, MVECTUR), ),
                          ),

        OP.INDL_ELGA(te=30,
                     para_in=(
                     (OP.INDL_ELGA.PCOMPOR, CCOMPOR), (
                     OP.INDL_ELGA.PCONTPR, ESIGMPG),
                     (SP.PMATERC, LC.CMATERC), (OP.INDL_ELGA.PVARIPR, ZVARIPG),
                     ),
                     para_out=((SP.PINDLOC, LC.EGINDLO), ),
                     ),

        OP.INIT_MAIL_VOIS(te=99,
                          para_out=((OP.INIT_MAIL_VOIS.PVOISIN, LC.EVOISIN), ),
                          ),

        OP.INIT_VARC(te=99,
                     para_out=((OP.INIT_VARC.PVARCPR, LC.ZVARCPG), ),
                     ),

        OP.MASS_INER(te=285,
                     para_in=((SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                              (OP.MASS_INER.PVARCPR, LC.ZVARCPG), ),
                     para_out=((SP.PMASSINE, LC.EMASSINE), ),
                     ),

        OP.MASS_MECA(te=82,
                     para_in=((SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                              (OP.MASS_MECA.PVARCPR, LC.ZVARCPG), ),
                     para_out=((SP.PMATUUR, MMATUUR), ),
                     ),

        OP.M_GAMMA(te=82,
                   para_in=((SP.PACCELR, DDL_MECA), (SP.PGEOMER, NGEOMER),
                            (SP.PMATERC, LC.CMATERC), (
                            OP.M_GAMMA.PVARCPR, LC.ZVARCPG),
                            ),
                   para_out=((SP.PVECTUR, MVECTUR), ),
                   ),

        OP.NSPG_NBVA(te=496,
                     para_in=((OP.NSPG_NBVA.PCOMPOR, LC.CCOMPO2), ),
                     para_out=((SP.PDCEL_I, LC.EDCEL_I), ),
                     ),

        OP.PAS_COURANT(te=404,
                       para_in=(
                           (SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                       (OP.PAS_COURANT.PVARCPR, LC.ZVARCPG),),
                       para_out=((SP.PCOURAN, LC.ECOURAN), ),
                       ),

        OP.RAPH_MECA(te=600,
                     para_in=((SP.PCAMASS, CCAMASS), (SP.PCARCRI, CCARCRI),
                              (OP.RAPH_MECA.PCOMPOR, CCOMPOR), (
                              OP.RAPH_MECA.PCONTMR, ECONTPG),
                              (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                              (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                              (SP.PINSTPR, CTEMPSR), (SP.PMATERC, LC.CMATERC),
                              (SP.PVARCMR, LC.ZVARCPG), (
                              OP.RAPH_MECA.PVARCPR, LC.ZVARCPG),
                              (SP.PVARCRR, LC.ZVARCPG), (
                              OP.RAPH_MECA.PVARIMR, ZVARIPG),
                              ),
                     para_out=(
                     (SP.PCODRET, LC.ECODRET), (OP.RAPH_MECA.PCONTPR, ECONTPG),
                     (OP.RAPH_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTUR),
                     ),
                     ),

        OP.REFE_FORC_NODA(te=600,
                          para_in=(
                              (SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                          (SP.PREFCO, EREFCO), ),
                          para_out=((SP.PVECTUR, MVECTUR), ),
                          ),

        OP.RIGI_MECA_ELAS(te=600,
                          para_in=(
                              (SP.PCAMASS, CCAMASS), (SP.PCARCRI, CCARCRI),
                          (OP.RIGI_MECA_ELAS.PCOMPOR, CCOMPOR), (
                          OP.RIGI_MECA_ELAS.PCONTMR, ECONTPG),
                              (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                          (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                          (SP.PINSTPR, CTEMPSR), (SP.PMATERC, LC.CMATERC),
                          (SP.PVARCMR, LC.ZVARCPG), (
                          OP.RIGI_MECA_ELAS.PVARCPR, LC.ZVARCPG),
                          (SP.PVARCRR, LC.ZVARCPG), (
                          OP.RIGI_MECA_ELAS.PVARIMR, ZVARIPG),
                          ),
                          para_out=((SP.PMATUNS, MMATUNS), ),
                          ),

        OP.RIGI_MECA_TANG(te=600,
                          para_in=(
                              (SP.PCAMASS, CCAMASS), (SP.PCARCRI, CCARCRI),
                          (OP.RIGI_MECA_TANG.PCOMPOR, CCOMPOR), (
                          OP.RIGI_MECA_TANG.PCONTMR, ECONTPG),
                              (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                          (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                          (SP.PINSTPR, CTEMPSR), (SP.PMATERC, LC.CMATERC),
                          (SP.PVARCMR, LC.ZVARCPG), (
                          OP.RIGI_MECA_TANG.PVARCPR, LC.ZVARCPG),
                          (SP.PVARCRR, LC.ZVARCPG), (
                          OP.RIGI_MECA_TANG.PVARIMR, ZVARIPG),
                          ),
                          para_out=((SP.PMATUNS, MMATUNS), ),
                          ),

        OP.SIEF_ELNO(te=600,
                     para_in=(
                     (OP.SIEF_ELNO.PCONTRR, ECONTPG), (
                     OP.SIEF_ELNO.PVARCPR, LC.ZVARCPG),
                     ),
                     para_out=(
                     (SP.PSIEFNOC, ECONTNC), (OP.SIEF_ELNO.PSIEFNOR, ECONTNO),
                     ),
                     ),

        OP.SIEQ_ELGA(te=335,
                     para_in=((OP.SIEQ_ELGA.PCONTRR, ESIGMPG), ),
                     para_out=((OP.SIEQ_ELGA.PCONTEQ, ECOEQPG), ),
                     ),

        OP.SIEQ_ELNO(te=335,
                     para_in=((OP.SIEQ_ELNO.PCONTRR, ESIGMNO), ),
                     para_out=((OP.SIEQ_ELNO.PCONTEQ, LC.ECOEQNO), ),
                     ),

        OP.SIGM_ELGA(te=546,
                     para_in=((SP.PSIEFR, ESIGMPG), ),
                     para_out=((SP.PSIGMC, ESIGMPC), (SP.PSIGMR, ESIGMPG),
                               ),
                     ),

        OP.SIGM_ELNO(te=4,
                     para_in=((OP.SIGM_ELNO.PCONTRR, ESIGMPG), ),
                     para_out=(
                     (SP.PSIEFNOC, ESIGMNC), (OP.SIGM_ELNO.PSIEFNOR, ESIGMNO),
                     ),
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

        OP.VAEX_ELGA(te=549,
                     para_in=(
                         (OP.VAEX_ELGA.PCOMPOR, CCOMPOR), (
                             SP.PNOVARI, E1NEUTK),
                     (SP.PVARIGR, ZVARIPG), ),
                     para_out=((SP.PVARIGS, LC.E1GNEUT), ),
                     ),

        OP.VAEX_ELNO(te=549,
                     para_in=(
                         (OP.VAEX_ELNO.PCOMPOR, CCOMPOR), (
                             SP.PNOVARI, E1NEUTK),
                     (OP.VAEX_ELNO.PVARINR, LC.ZVARINO), ),
                     para_out=((SP.PVARINS, LC.E1NNEUT), ),
                     ),

        OP.VARI_ELNO(te=600,
                     para_in=(
                         (OP.VARI_ELNO.PCOMPOR, CCOMPOR), (
                             SP.PVARIGR, ZVARIPG),
                     ),
                     para_out=((OP.VARI_ELNO.PVARINR, LC.ZVARINO), ),
                     ),

        OP.VERI_JACOBIEN(te=328,
                         para_in=((SP.PGEOMER, NGEOMER), ),
                         para_out=((SP.PCODRET, LC.ECODRET), ),
                         ),

    )


#------------------------------------------------------------
class HM_DPTR6_P(HM_DPQ8_P):

    """Please document this element"""
    meshType = MT.TRIA6
    nodes = (
        SetOfNodes('EN2', (4, 5, 6,)),
        SetOfNodes('EN1', (1, 2, 3,)),
    )
    elrefe = (
        ElrefeLoc(
            MT.TR6, gauss=(
                'RIGI=FPG6', 'MASS=FPG6', 'FPG1=FPG1',), mater=('RIGI', 'FPG1',),),
        ElrefeLoc(MT.TR3, gauss = ('RIGI=FPG6',),),
        ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4',),),
    )
