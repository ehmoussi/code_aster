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


CCAMASS  = LocatedComponents(phys=PHY.CAMASS, type='ELEM',
    components=('C','ALPHA',))


DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO', diff=True,
    components=(
    ('EN1',('HHO_U[2]','HHO_V[2]',)),
    ('EN2', ()),
    ('EN3', ()),
    )
)

HHO_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO', diff=True,
    components=(
    ('EN1',('HHO_U[2]','HHO_V[2]',)),
    ('EN2',()),
    ('EN3',('HHO[12]')),
    )
)

EDEPLPG  = LocatedComponents(phys=PHY.DEPL_R, type='ELGA', location='RIGI',
    components=('DX','DY',))


EENERR   = LocatedComponents(phys=PHY.ENER_R, type='ELEM',
    components=('TOTALE',))


EENERPG  = LocatedComponents(phys=PHY.ENER_R, type='ELGA', location='RIGI',
    components=('TOTALE',))


EENERNO  = LocatedComponents(phys=PHY.ENER_R, type='ELNO',
    components=('TOTALE',))


EDEFOPC  = LocatedComponents(phys=PHY.EPSI_C, type='ELGA', location='RIGI',
    components=('EPXX','EPYY','EPZZ','EPXY',))


EDEFONC  = LocatedComponents(phys=PHY.EPSI_C, type='ELNO',
    components=('EPXX','EPYY','EPZZ','EPXY','EPXZ',
          'EPYZ',))


CEPSINF  = LocatedComponents(phys=PHY.EPSI_F, type='ELEM',
    components=('EPXX','EPYY','EPZZ','EPXY',))


EDEFOPG  = LocatedComponents(phys=PHY.EPSI_R, type='ELGA', location='RIGI',
    components=('EPXX','EPYY','EPZZ','EPXY',))


EDEFONO  = LocatedComponents(phys=PHY.EPSI_R, type='ELNO',
    components=('EPXX','EPYY','EPZZ','EPXY',))


CEPSINR  = LocatedComponents(phys=PHY.EPSI_R, type='ELEM',
    components=('EPXX','EPYY','EPZZ','EPXY',))


EDFEQPG  = LocatedComponents(phys=PHY.EPSI_R, type='ELGA', location='RIGI',
    components=('INVA_2','PRIN_[3]','INVA_2SG','VECT_1_X','VECT_1_Y',
          'VECT_1_Z','VECT_2_X','VECT_2_Y','VECT_2_Z','VECT_3_X',
          'VECT_3_Y','VECT_3_Z',))


EDFVCPG  = LocatedComponents(phys=PHY.EPSI_R, type='ELGA', location='RIGI',
    components=('EPTHER_L','EPTHER_T','EPTHER_N','EPSECH','EPHYDR',
          'EPPTOT',))


EDFVCNO  = LocatedComponents(phys=PHY.EPSI_R, type='ELNO',
    components=('EPTHER_L','EPTHER_T','EPTHER_N','EPSECH','EPHYDR',
          'EPPTOT',))


EERREUR  = LocatedComponents(phys=PHY.ERRE_R, type='ELEM',
    components=('ERREST','NUEST','SIGCAL','TERMRE','TERMR2',
          'TERMNO','TERMN2','TERMSA','TERMS2','TAILLE',))


EERRENO  = LocatedComponents(phys=PHY.ERRE_R, type='ELNO',
    components=('ERREST','NUEST','SIGCAL','TERMRE','TERMR2',
          'TERMNO','TERMN2','TERMSA','TERMS2','TAILLE',))


CFORCEF  = LocatedComponents(phys=PHY.FORC_F, type='ELEM',
    components=('FX','FY',))


NFORCER  = LocatedComponents(phys=PHY.FORC_R, type='ELNO',
    components=('FX','FY',))


EFORCER  = LocatedComponents(phys=PHY.FORC_R, type='ELGA', location='RIGI',
    components=('FX','FY',))

NREACR  = LocatedComponents(phys=PHY.REAC_R, type='ELNO',
    components=('DX','DY',))

EKTHETA  = LocatedComponents(phys=PHY.G, type='ELEM',
    components=('GTHETA','FIC[2]','K[2]',))


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y',))


EGGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
    components=('X','Y',))


EGGEOP_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
    components=('X','Y','W',))


ENGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y',))


CTEMPSR  = LocatedComponents(phys=PHY.INST_R, type='ELEM',
    components=('INST',))


EGNEUT_F = LocatedComponents(phys=PHY.NEUT_F, type='ELGA', location='RIGI',
    components=('X[30]',))


EGNEUT_R = LocatedComponents(phys=PHY.NEUT_R, type='ELGA', location='RIGI',
    components=('X[30]',))


EMNEUT_R = LocatedComponents(phys=PHY.NEUT_R, type='ELEM',
    components=('X[30]',))


ECOPILO  = LocatedComponents(phys=PHY.PILO_R, type='ELGA', location='RIGI',
    components=('A0','A[3]','ETA',))


EREFCO   = LocatedComponents(phys=PHY.PREC, type='ELEM',
    components=('SIGM',))


ECONTNC  = LocatedComponents(phys=PHY.SIEF_C, type='ELNO',
    components=('SIXX','SIYY','SIZZ','SIXY',))


ECONTPC  = LocatedComponents(phys=PHY.SIEF_C, type='ELGA', location='RIGI',
    components=('SIXX','SIYY','SIZZ','SIXY',))


ECONTNO  = LocatedComponents(phys=PHY.SIEF_R, type='ELNO',
    components=('SIXX','SIYY','SIZZ','SIXY',))


ECONTPG  = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='RIGI',
    components=('SIXX','SIYY','SIZZ','SIXY',))


ECOEQPG  = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='RIGI',
    components=('VMIS','TRESCA','PRIN_[3]','VMIS_SG','VECT_1_X',
          'VECT_1_Y','VECT_1_Z','VECT_2_X','VECT_2_Y','VECT_2_Z',
          'VECT_3_X','VECT_3_Y','VECT_3_Z','TRSIG','TRIAX',))


ESOURCR  = LocatedComponents(phys=PHY.SOUR_R, type='ELGA', location='RIGI',
    components=('SOUR',))


ZVARIPG  = LocatedComponents(phys=PHY.VARI_R, type='ELGA', location='RIGI',
    components=('VARI',))


CCELLMR  = LocatedComponents(phys=PHY.CELL_R, type='ELEM',
    components=('HHO_U[6]','HHO_V[6]'))

CCELLIM  = LocatedComponents(phys=PHY.CELL_R, type='ELEM',
    components=('HHO_U[6]','HHO_V[6]'))

CCELLIR  = LocatedComponents(phys=PHY.CELL_R, type='ELEM',
    components=('HHO_U[6]','HHO_V[6]'))

CCELLPR  = LocatedComponents(phys=PHY.CELL_R, type='ELEM',
    components=('HHO_U[6]','HHO_V[6]'))

CCSMTIR  = LocatedComponents(phys=PHY.N3240R, type='ELEM',
    components=('X[192]',))

CCSRTIR  = LocatedComponents(phys=PHY.CELL_R, type='ELEM',
    components=('HHO_U[6]','HHO_V[6]'))

CHHOGTQ  = LocatedComponents(phys=PHY.N1920R, type='ELEM',
    components=('X[336]',))

CHHOGTT  = LocatedComponents(phys=PHY.N1920R, type='ELEM',
    components=('X[288]',))

CHHOSTQ  = LocatedComponents(phys=PHY.N2448R, type='ELEM',
    components=('X[196]',))

CHHOSTT  = LocatedComponents(phys=PHY.N2448R, type='ELEM',
    components=('X[144]',))

DEPLHHO  = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
    components=('DX','DY',))

PFONC = LocatedComponents(phys=PHY.NEUT_K8, type='ELEM',
    components=('Z[8]',))

HHOCINE  = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
    components=('HHO_U[2]','HHO_V[2]'))

MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

MVEFORC  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DEPLHHO)

MMATUUR  = ArrayOfComponents(phys=PHY.MDEP_R, locatedComponents=DDL_MECA)

MMATUNS  = ArrayOfComponents(phys=PHY.MDNS_R, locatedComponents=DDL_MECA)

MVECTHR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=HHO_MECA)

MMATUHR  = ArrayOfComponents(phys=PHY.MDEP_R, locatedComponents=HHO_MECA)

MMATUHS=ArrayOfComponents(phys=PHY.MDNS_R, locatedComponents=HHO_MECA)

#------------------------------------------------------------
class MECA_DPQ8_HHO121(Element):
    """Please document this element"""
    meshType = MT.QUAD8
    nodes = (
            SetOfNodes('EN1', (5,6,7,8,)),
            SetOfNodes('EN2', (2, 3, 4,)),
            SetOfNodes('EN3', (1,)),
        )
    elrefe =(
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG4','FPG1=FPG1',), mater=('RIGI', 'FPG1',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG2',),),
        )
    calculs = (


        OP.COOR_ELGA(te=479,
            para_in=((SP.PGEOMER, NGEOMER), ),
            para_out=((OP.COOR_ELGA.PCOORPG, EGGEOP_R), ),
        ),

        OP.FULL_MECA(te=455,
            para_in=((SP.PCAMASS, CCAMASS), (SP.PCARCRI, LC.CCARCRI), (SP.PMULCOM, LC.CMLCOMP),
                     (OP.FULL_MECA.PCOMPOR, LC.CCOMPOR), (OP.FULL_MECA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (SP.PITERAT, LC.CITERAT),
                     (SP.PMATERC, LC.CMATERC), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.FULL_MECA.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (SP.PVARIMP, ZVARIPG), (OP.FULL_MECA.PVARIMR, ZVARIPG),
                     (OP.FULL_MECA.PCELLMR, CCELLMR), (OP.FULL_MECA.PCELLIR, CCELLIR),
                     (OP.FULL_MECA.PCHHOGT, CHHOGTQ), (OP.FULL_MECA.PCHHOST, CHHOSTQ),
                     ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.FULL_MECA.PCONTPR, ECONTPG),
                     (SP.PMATUNS, MMATUHS), (SP.PMATUUR, MMATUHR),
                     (OP.FULL_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTHR),
                     ),
        ),

        OP.HHO_COMB(te=448,
            para_in=(
                     (SP.PMATERC, LC.CMATERC),
                     (OP.HHO_COMB.PCMBHHO, LC.CCMBHHO),
                     (OP.HHO_COMB.PMAELS1, MMATUHR),
                     ((OP.HHO_COMB.PMAELS2, MMATUHR)),
                     (OP.HHO_COMB.PMAELNS1, MMATUHS),
                     (OP.HHO_COMB.PMAELNS2, MMATUHS),
                     (OP.HHO_COMB.PVEELE1, MVECTHR),
                     (OP.HHO_COMB.PVEELE2, MVECTHR),
                     (OP.HHO_COMB.PVEELE3, MVECTHR),
                     (OP.HHO_COMB.PVEELE4, MVECTHR),
                    ),
            para_out=(
                      (OP.HHO_COMB.PMATUNS, MMATUHS),
                      (OP.HHO_COMB.PMATUUR, MMATUHR),
                      (OP.HHO_COMB.PVECTUR, MVECTHR),
                    ),
        ),

        OP.HHO_COND_MECA(te=449,
            para_in=(
                     (SP.PGEOMER, NGEOMER),
                     (OP.HHO_COND_MECA.PMAELS1, MMATUHR),
                     (OP.HHO_COND_MECA.PMAELNS1, MMATUHS),
                     (OP.HHO_COND_MECA.PVEELE1, MVECTHR),
                    ),
            para_out=(
                      (OP.HHO_COND_MECA.PCSMTIR, CCSMTIR),
                      (OP.HHO_COND_MECA.PCSRTIR, CCSRTIR),
                      (OP.HHO_COND_MECA.PMATUNS, MMATUNS),
                      (OP.HHO_COND_MECA.PMATUUR, MMATUUR),
                      (OP.HHO_COND_MECA.PVECTUR, MVECTUR),
                      (SP.PCODRET, LC.ECODRET),
                    ),
        ),

        OP.HHO_DECOND_MECA(te=450,
            para_in=(
                     (SP.PGEOMER, NGEOMER),
                     (SP.PDEPLPR, DDL_MECA),
                     (OP.HHO_DECOND_MECA.PCSMTIR, CCSMTIR),
                     (OP.HHO_DECOND_MECA.PCSRTIR, CCSRTIR),
                     (OP.HHO_DECOND_MECA.PCELLIM, CCELLIM),
                    ),
            para_out=(
                      (OP.HHO_DECOND_MECA.PCELLIR, CCELLIR),
                    ),
        ),

        OP.HHO_PRECALC_MECA(te=460,
            para_in=(
                     (SP.PGEOMER, NGEOMER),
                     (OP.HHO_PRECALC_MECA.PCOMPOR, LC.CCOMPOR),
            ),
            para_out=(
                      (OP.HHO_PRECALC_MECA.PCHHOGT, CHHOGTQ),
                      (OP.HHO_PRECALC_MECA.PCHHOST, CHHOSTQ),
            ),
        ),

        OP.HHO_DEPL_MECA(te=456,
            para_in=((SP.PGEOMER, NGEOMER),
                     (SP.PDEPLPR, DDL_MECA),
                     (OP.HHO_DEPL_MECA.PCELLPR, CCELLPR),
                     (OP.HHO_DEPL_MECA.PCOMPOR, LC.CCOMPOR),
            ),
            para_out=((OP.HHO_DEPL_MECA.PDEPL_R, DEPLHHO),),
        ),

        OP.HHO_CINE_F_MECA(te=458,
            para_in=((SP.PGEOMER, NGEOMER),
                     (SP.PINSTPR, CTEMPSR),
                     (OP.HHO_CINE_F_MECA.PFONC, PFONC),
            ),
            para_out=((OP.HHO_CINE_F_MECA.PCINE, HHOCINE),),
        ),

        OP.INIT_MAIL_VOIS(te=99,
            para_out=((OP.INIT_MAIL_VOIS.PVOISIN, LC.EVOISIN), ),
        ),

        OP.INIT_VARC(te=99,
            para_out=((OP.INIT_VARC.PVARCPR, LC.ZVARCPG), (OP.INIT_VARC.PVARCNO, LC.ZVARCNO),),
        ),

        OP.MATE_ELGA(te=142,
            para_in=((SP.PMATERC, LC.CMATERC),
                     (OP.MATE_ELGA.PVARCPR, LC.ZVARCPG), ),
            para_out=((OP.MATE_ELGA.PMATERR, LC.EGMATE_R), ),
        ),

        OP.MATE_ELEM(te=142,
            para_in=((SP.PMATERC, LC.CMATERC),
                     (OP.MATE_ELEM.PVARCPR, LC.ZVARCPG), ),
            para_out=((OP.MATE_ELEM.PMATERR, LC.EEMATE_R), ),
        ),

        OP.NSPG_NBVA(te=496,
            para_in=((OP.NSPG_NBVA.PCOMPOR, LC.CCOMPO2), ),
            para_out=((SP.PDCEL_I, LC.EDCEL_I), ),
        ),

        OP.PAS_COURANT(te=404,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                     (OP.PAS_COURANT.PVARCPR, LC.ZVARCPG),),
            para_out=((SP.PCOURAN, LC.ECOURAN), ),
        ),

        OP.RAPH_MECA(te=455,
            para_in=((SP.PCAMASS, CCAMASS), (SP.PCARCRI, LC.CCARCRI), (SP.PMULCOM, LC.CMLCOMP),
                     (OP.RAPH_MECA.PCOMPOR, LC.CCOMPOR), (OP.RAPH_MECA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (SP.PITERAT, LC.CITERAT),
                     (SP.PMATERC, LC.CMATERC), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.RAPH_MECA.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (SP.PVARIMP, ZVARIPG), (OP.RAPH_MECA.PVARIMR, ZVARIPG),
                     (OP.RAPH_MECA.PCELLMR, CCELLMR), (OP.RAPH_MECA.PCELLIR, CCELLIR),
                     (OP.RAPH_MECA.PCHHOGT, CHHOGTQ), (OP.RAPH_MECA.PCHHOST, CHHOSTQ),
                     ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.RAPH_MECA.PCONTPR, ECONTPG),
                     (OP.RAPH_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTHR),
                     ),
        ),

        OP.RIGI_MECA(te=455,
            para_in=((SP.PCAMASS, CCAMASS), (SP.PCARCRI, LC.CCARCRI),(SP.PMULCOM, LC.CMLCOMP),
                     (OP.RIGI_MECA.PCOMPOR, LC.CCOMPOR), (OP.RIGI_MECA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (SP.PITERAT, LC.CITERAT),
                     (SP.PMATERC, LC.CMATERC), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.RIGI_MECA.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (OP.RIGI_MECA.PVARIMR, ZVARIPG),
                     (OP.RIGI_MECA.PCELLMR, CCELLMR), (OP.RIGI_MECA.PCELLIR, CCELLIR),
                     (OP.RIGI_MECA.PCHHOGT, CHHOGTQ), (OP.RIGI_MECA.PCHHOST, CHHOSTQ),
                     ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.RIGI_MECA.PCONTPR, ECONTPG),
                     (OP.RIGI_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTHR),
                     ),
        ),

        OP.RIGI_MECA_TANG(te=455,
            para_in=((SP.PCAMASS, CCAMASS), (SP.PCARCRI, LC.CCARCRI), (SP.PMULCOM, LC.CMLCOMP),
                     (OP.RIGI_MECA_TANG.PCOMPOR, LC.CCOMPOR), (OP.RIGI_MECA_TANG.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (SP.PITERAT, LC.CITERAT),
                     (SP.PMATERC, LC.CMATERC), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.RIGI_MECA_TANG.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (OP.RIGI_MECA_TANG.PVARIMR, ZVARIPG),
                     (OP.RIGI_MECA_TANG.PCELLMR, CCELLMR), (OP.RIGI_MECA_TANG.PCELLIR, CCELLIR),
                     (OP.RIGI_MECA_TANG.PCHHOGT, CHHOGTQ), (OP.RIGI_MECA_TANG.PCHHOST, CHHOSTQ),
                     ),
            para_out=((SP.PMATUNS, MMATUHS), (SP.PMATUUR, MMATUHR), (SP.PVECTUR, MVECTHR),
                     (OP.RIGI_MECA_TANG.PCONTPR, ECONTPG), (OP.RIGI_MECA_TANG.PVARIPR, ZVARIPG),
                     (SP.PCODRET, LC.ECODRET),
                     ),
        ),

        OP.SIEF_ELNO(te=4,
            para_in=((OP.SIEF_ELNO.PCONTRR, ECONTPG), (OP.SIEF_ELNO.PVARCPR, LC.ZVARCPG),
                     ),
            para_out=((SP.PSIEFNOC, ECONTNC), (OP.SIEF_ELNO.PSIEFNOR, ECONTNO),
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
            para_out=((SP.PSIEFNOC, ECONTNC), (OP.SIGM_ELNO.PSIEFNOR, ECONTNO),
                     ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PERREUR, EERREUR), (OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM2D),
                     ),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out=((OP.TOU_INI_ELGA.PDEPL_R, EDEPLPG), (OP.TOU_INI_ELGA.PDOMMAG, LC.EDOMGGA),
                     (OP.TOU_INI_ELGA.PEPSI_R, EDEFOPG), (OP.TOU_INI_ELGA.PGEOM_R, EGGEOM_R),
                     (OP.TOU_INI_ELGA.PINST_R, LC.EGINST_R), (OP.TOU_INI_ELGA.PNEUT_F, EGNEUT_F),
                     (OP.TOU_INI_ELGA.PNEUT_R, EGNEUT_R), (OP.TOU_INI_ELGA.PSIEF_R, ECONTPG),
                     (OP.TOU_INI_ELGA.PSOUR_R, ESOURCR), (OP.TOU_INI_ELGA.PVARI_R, ZVARIPG),
                     ),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PDOMMAG, LC.EDOMGNO), (OP.TOU_INI_ELNO.PEPSI_R, EDEFONO),
                     (OP.TOU_INI_ELNO.PGEOM_R, ENGEOM_R), (OP.TOU_INI_ELNO.PINST_R, LC.ENINST_R),
                     (OP.TOU_INI_ELNO.PNEUT_F, LC.ENNEUT_F), (OP.TOU_INI_ELNO.PNEUT_R, LC.ENNEUT_R),
                     (OP.TOU_INI_ELNO.PSIEF_R, ECONTNO), (OP.TOU_INI_ELNO.PVARI_R, LC.ZVARINO),
                     ),
        ),

        OP.VARC_ELGA(te=530,
            para_in=((OP.VARC_ELGA.PVARCPR, LC.ZVARCPG), ),
            para_out=((SP.PVARC_R, LC.EVARC_R), ),
        ),

        OP.VARI_ELNO(te=4,
            para_in=((SP.PVARIGR, ZVARIPG), ),
            para_out=((OP.VARI_ELNO.PVARINR, LC.ZVARINO), ),
        ),

        OP.VERI_JACOBIEN(te=328,
            para_in=((SP.PGEOMER, NGEOMER), ),
            para_out=((SP.PCODRET, LC.ECODRET), ),
        ),
    )
#------------------------------------------------------------
class MECA_DPT6_HHO121(MECA_DPQ8_HHO121):
    """Please document this element"""
    meshType = MT.TRIA6
    nodes = (
            SetOfNodes('EN1', (4,5,6,)),
            SetOfNodes('EN2', (2, 3,)),
            SetOfNodes('EN3', (1,)),
        )
    elrefe =(
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG3','FPG1=FPG1',), mater=('RIGI', 'FPG1',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG2',),),
        )
    calculs = (

        OP.FULL_MECA(te=455,
            para_in=((SP.PCAMASS, CCAMASS), (SP.PCARCRI, LC.CCARCRI), (SP.PMULCOM, LC.CMLCOMP),
                     (OP.FULL_MECA.PCOMPOR, LC.CCOMPOR), (OP.FULL_MECA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (SP.PITERAT, LC.CITERAT),
                     (SP.PMATERC, LC.CMATERC), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.FULL_MECA.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (SP.PVARIMP, ZVARIPG), (OP.FULL_MECA.PVARIMR, ZVARIPG),
                     (OP.FULL_MECA.PCELLMR, CCELLMR), (OP.FULL_MECA.PCELLIR, CCELLIR),
                     (OP.FULL_MECA.PCHHOGT, CHHOGTT), (OP.FULL_MECA.PCHHOST, CHHOSTT),
                     ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.FULL_MECA.PCONTPR, ECONTPG),
                     (SP.PMATUNS, MMATUHS), (SP.PMATUUR, MMATUHR),
                     (OP.FULL_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTHR),
                     ),
        ),

        OP.HHO_PRECALC_MECA(te=460,
            para_in=(
                     (SP.PGEOMER, NGEOMER),
                     (OP.HHO_PRECALC_MECA.PCOMPOR, LC.CCOMPOR),
                    ),
            para_out=(
                      (OP.HHO_PRECALC_MECA.PCHHOGT, CHHOGTT),
                      (OP.HHO_PRECALC_MECA.PCHHOST, CHHOSTT),
                    ),
        ),

        OP.RAPH_MECA(te=455,
            para_in=((SP.PCAMASS, CCAMASS), (SP.PCARCRI, LC.CCARCRI), (SP.PMULCOM, LC.CMLCOMP),
                     (OP.RAPH_MECA.PCOMPOR, LC.CCOMPOR), (OP.RAPH_MECA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (SP.PITERAT, LC.CITERAT),
                     (SP.PMATERC, LC.CMATERC), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.RAPH_MECA.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (SP.PVARIMP, ZVARIPG), (OP.RAPH_MECA.PVARIMR, ZVARIPG),
                     (OP.RAPH_MECA.PCELLMR, CCELLMR), (OP.RAPH_MECA.PCELLIR, CCELLIR),
                     (OP.RAPH_MECA.PCHHOGT, CHHOGTT), (OP.RAPH_MECA.PCHHOST, CHHOSTT),
                     ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.RAPH_MECA.PCONTPR, ECONTPG),
                     (OP.RAPH_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTHR),
                     ),
        ),

        OP.RIGI_MECA(te=455,
            para_in=((SP.PCAMASS, CCAMASS), (SP.PCARCRI, LC.CCARCRI),(SP.PMULCOM, LC.CMLCOMP),
                     (OP.RIGI_MECA.PCOMPOR, LC.CCOMPOR), (OP.RIGI_MECA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (SP.PITERAT, LC.CITERAT),
                     (SP.PMATERC, LC.CMATERC), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.RIGI_MECA.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (OP.RIGI_MECA.PVARIMR, ZVARIPG),
                     (OP.RIGI_MECA.PCELLMR, CCELLMR), (OP.RIGI_MECA.PCELLIR, CCELLIR),
                     (OP.RIGI_MECA.PCHHOGT, CHHOGTT), (OP.RIGI_MECA.PCHHOST, CHHOSTT),
                     ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.RIGI_MECA.PCONTPR, ECONTPG),
                     (OP.RIGI_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTHR),
                     ),
        ),

        OP.RIGI_MECA_TANG(te=455,
            para_in=((SP.PCAMASS, CCAMASS), (SP.PCARCRI, LC.CCARCRI), (SP.PMULCOM, LC.CMLCOMP),
                     (OP.RIGI_MECA_TANG.PCOMPOR, LC.CCOMPOR), (OP.RIGI_MECA_TANG.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (SP.PITERAT, LC.CITERAT),
                     (SP.PMATERC, LC.CMATERC), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.RIGI_MECA_TANG.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (OP.RIGI_MECA_TANG.PVARIMR, ZVARIPG),
                     (OP.RIGI_MECA_TANG.PCELLMR, CCELLMR), (OP.RIGI_MECA_TANG.PCELLIR, CCELLIR),
                     (OP.RIGI_MECA_TANG.PCHHOGT, CHHOGTT), (OP.RIGI_MECA_TANG.PCHHOST, CHHOSTT),
                     ),
            para_out=((SP.PMATUNS, MMATUHS), (SP.PMATUUR, MMATUHR), (SP.PVECTUR, MVECTHR),
                     (OP.RIGI_MECA_TANG.PCONTPR, ECONTPG), (OP.RIGI_MECA_TANG.PVARIPR, ZVARIPG),
                     (SP.PCODRET, LC.ECODRET),
                     ),
        ),
    )
