
# ======================================================================
# COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
# (AT YOUR OPTION) ANY LATER VERSION.
#
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.
#
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
# ======================================================================

from cataelem.Tools.base_objects import LocatedComponents, ArrayOfComponents, SetOfNodes, ElrefeLoc
from cataelem.Tools.base_objects import Calcul, Element, AbstractElement
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.located_components as LC
import cataelem.Commons.parameters as SP
import cataelem.Commons.mesh_types as MT
from cataelem.Options.options import OP

#----------------
# Modes locaux :
#----------------


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))


EGGEOP_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
    components=('X','Y','Z','W',))


DDL_ACOU = LocatedComponents(phys=PHY.PRES_C, type='ELNO',
    components=('PRES',))


MVECTTC  = ArrayOfComponents(phys=PHY.VPRE_C, locatedComponents=(DDL_ACOU,))

MMATTTC  = ArrayOfComponents(phys=PHY.MPRE_C, locatedComponents=(DDL_ACOU,DDL_ACOU))


#------------------------------------------------------------
abstractElement = AbstractElement()
ele = abstractElement

ele.addCalcul(OP.AMOR_ACOU, te=182,
    para_in=((SP.PGEOMER, NGEOMER), (SP.PIMPEDC, LC.CIMPEDC),
             (SP.PMATERC, LC.CMATERC), ),
    para_out=((SP.PMATTTC, MMATTTC), ),
)

ele.addCalcul(OP.CHAR_ACOU_VNOR_C, te=183,
    para_in=((SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
             (SP.PVITENC, LC.EVITENC), ),
    para_out=((SP.PVECTTC, MVECTTC), ),
)

ele.addCalcul(OP.COOR_ELGA, te=488,
    para_in=((SP.PGEOMER, NGEOMER), ),
    para_out=((OP.COOR_ELGA.PCOORPG, EGGEOP_R), ),
)

ele.addCalcul(OP.TOU_INI_ELGA, te=99,
    para_out=((OP.TOU_INI_ELGA.PGEOM_R, EGGEOP_R), ),
)

ele.addCalcul(OP.TOU_INI_ELNO, te=99,
    para_out=((OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), ),
)


#------------------------------------------------------------
ACOU_FACE3 = Element(modele=abstractElement)
ele = ACOU_FACE3
ele.meshType = MT.TRIA3
ele.elrefe=(
        ElrefeLoc(MT.TR3, gauss = ('RIGI=COT3','FPG1=FPG1',), mater=('FPG1',),),
    )


#------------------------------------------------------------
ACOU_FACE4 = Element(modele=abstractElement)
ele = ACOU_FACE4
ele.meshType = MT.QUAD4
ele.elrefe=(
        ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG4','FPG1=FPG1',), mater=('FPG1',),),
    )


#------------------------------------------------------------
ACOU_FACE6 = Element(modele=abstractElement)
ele = ACOU_FACE6
ele.meshType = MT.TRIA6
ele.elrefe=(
        ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG4','FPG1=FPG1',), mater=('FPG1',),),
    )


#------------------------------------------------------------
ACOU_FACE8 = Element(modele=abstractElement)
ele = ACOU_FACE8
ele.meshType = MT.QUAD8
ele.elrefe=(
        ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9','FPG1=FPG1',), mater=('FPG1',),),
    )


#------------------------------------------------------------
ACOU_FACE9 = Element(modele=abstractElement)
ele = ACOU_FACE9
ele.meshType = MT.QUAD9
ele.elrefe=(
        ElrefeLoc(MT.QU9, gauss = ('RIGI=FPG9','FPG1=FPG1',), mater=('FPG1',),),
    )
