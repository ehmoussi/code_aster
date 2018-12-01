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

# person_in_charge: ayaovi-dzifa.kudawoo at edf.fr

from cataelem.Tools.base_objects import LocatedComponents, ArrayOfComponents, SetOfNodes, ElrefeLoc
from cataelem.Tools.base_objects import Calcul, Element
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.located_components as LC
import cataelem.Commons.parameters as SP
import cataelem.Commons.mesh_types as MT
from cataelem.Options.options import OP

# ELEMENTARY TREATMENT OF 2D FRICTIONLESS ELEMENT WITH DEFI_CONTACT OPERATOR
# MORTAR LAC METHOD

#----------------
# Modes locaux :
#----------------

DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO', diff=True,
    components=(
    ('EN1',('DX','DY','LAGS_C',)),
    ('EN2',('DX','DY',)),))

NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y',))

MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

MMATUUR  = ArrayOfComponents(phys=PHY.MDEP_R, locatedComponents=DDL_MECA)

MMATUNS  = ArrayOfComponents(phys=PHY.MDNS_R, locatedComponents=DDL_MECA)

#---------------------------------------------------------------------------------------------------
class LCS2S2C(Element):
    """
      The main 2D class element for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   :
          PSNO    - Parameter of Smoothed Normal at T0
          PDEPL_P - DEPDEL (DISPL. at T+) - (DISPL. at T-)
          PDEPL_M - DISPL. at T-
          PGEOMER - INITIAL GEOMETRY 
          PCONFR  - FRICTIONAL CONTACT PARAMETERS                   
      Output parameters  :    
          PMMATUR : SYMMETRIC MATRIX (te=567)
          PVECTUR : VECTOR OF CONTACT LOAD (te=568)
      Options            : RIGI_CONT / CHAR_MECA_CONT / EXISTE_DDL
      Geometry           : SEG22 (SEG2 with SEG2)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 2     (DX,DY,LAGS_C) - Geom. Slave: LACS22D
          SEG2 MASTER ELEMENT : 1-3-4 (DX,DY)
    """
    meshType = MT.SEG22
    nodes = (
            SetOfNodes('EN1', (2,)),
            SetOfNodes('EN2', (1,3,4,)),
        )
    calculs = (
        OP.RIGI_CONT(te=567,
            para_in=((SP.PCONFR , LC.CCONFR),(SP.PDEPL_M, DDL_MECA),
                     (SP.PDEPL_P, DDL_MECA ),(SP.PGEOMER, NGEOMER),
                     (SP.PSNO   , NGEOMER  ), (SP.PDDEPLA, DDL_MECA ),),
            para_out=((SP.PMATUUR, MMATUUR),),        
        ),       
        OP.CHAR_MECA_CONT(te=568,
            para_in=((SP.PCONFR, LC.CCONFR),(SP.PDEPL_M, DDL_MECA),
                     (SP.PDEPL_P, DDL_MECA),(SP.PGEOMER, NGEOMER),
                     (SP.PSNO, NGEOMER), (SP.PDDEPLA, DDL_MECA ),),
            para_out=((SP.PVECTCR, MVECTUR), (SP.PVECTFR, MVECTUR),),
        ),
        OP.EXISTE_DDL(te=99,
            para_out=((OP.EXISTE_DDL.PDEPL_R, DDL_MECA), ),
        ),
    )
#---------------------------------------------------------------------------------------------------
class LCS3S3C(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element 
      Geometry           : SEG33 (SEG3 with SEG3)
      Local Numerotation :
          SEG3 SLAVE  ELEMENT : 3         (DX,DY,LAGS_C) - Geom. Slave: LACS32D
          SEG3 MASTER ELEMENT : 1-2-4-5-6 (DX,DY)
    """
    meshType = MT.SEG33
    nodes = (
            SetOfNodes('EN2', (1,2,4,5,6,)),
            SetOfNodes('EN1', (3,)),
        )
#---------------------------------------------------------------------------------------------------
class LCS2S3C(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element
      Geometry           : SEG23 (SEG2 with SEG3)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 2         (DX,DY,LAGS_C) - Geom. Slave: LACS22D
          SEG3 MASTER ELEMENT : 1-3-4-5   (DX,DY)              
      
    """
    meshType = MT.SEG23
    nodes = (
            SetOfNodes('EN1', (2,)),
            SetOfNodes('EN2', (1,3,4,5,)),      
        )
#---------------------------------------------------------------------------------------------------
class LCS3S2C(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element
      Geometry           : SEG32 (SEG3 with SEG2)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 3         (DX,DY,LAGS_C) - Geom. Slave: LACS22D
          SEG3 MASTER ELEMENT : 1-2-4-5   (DX,DY)     
      
    """
    meshType = MT.SEG32
    nodes = (
            SetOfNodes('EN1', (3,)),
            SetOfNodes('EN2', (1,2,4,5,)),      
        )
#---------------------------------------------------------------------------------------------------
class LCS2S2D(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element    
      Geometry           : SEG22 (SEG2 with SEG2)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 1         (DX,DY,LAGS_C) - Geom. Slave: LACS22DB
          SEG2 MASTER ELEMENT : 2,3,4     (DX,DY)   
    """
    meshType = MT.SEG22
    nodes = (
            SetOfNodes('EN1', (1,)),            
            SetOfNodes('EN2', (2,3,4,)),     
        )
#---------------------------------------------------------------------------------------------------
class LCS2S3D(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element    
      Geometry           : SEG23 (SEG2 with SEG3)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 1         (DX,DY,LAGS_C) - Geom. Slave: LACS22DB
          SEG3 MASTER ELEMENT : 2,3,4,5   (DX,DY)   
    """
    meshType = MT.SEG23
    nodes = (
            SetOfNodes('EN1', (1,)),
            SetOfNodes('EN2', (2,3,4,5,)),     
        )
#---------------------------------------------------------------------------------------------------
class LCS2S2E(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element    
      Geometry           : SEG22 (SEG2 with SEG2)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 1,2       (DX,DY,LAGS_C) - Geom. Slave: LACS22DT
          SEG2 MASTER ELEMENT : 3,4       (DX,DY)   
    """
    meshType = MT.SEG22
    nodes = (
            SetOfNodes('EN1', (1,2,)),
            SetOfNodes('EN2', (3,4,)),     
        )
#---------------------------------------------------------------------------------------------------
class LCS2S3E(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element    
      Geometry           : SEG23 (SEG2 with SEG3)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 1,2       (DX,DY,LAGS_C) - Geom. Slave: LACS22DT
          SEG3 MASTER ELEMENT : 3,4,5     (DX,DY)   
    """
    meshType = MT.SEG23
    nodes = (
            SetOfNodes('EN1', (1,2,)),
            SetOfNodes('EN2', (3,4,5,)),    
        )
#---------------------------------------------------------------------------------------------------
class LCS2S2CA(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element 
      Geometry           : SEG22 (SEG2 with SEG2)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 2     (DX,DY,LAGS_C) - Geom. Slave: LACS22D
          SEG2 MASTER ELEMENT : 1-3-4 (DX,DY)
    """
    meshType = MT.SEG22
    nodes = (
            SetOfNodes('EN1', (2,)),
            SetOfNodes('EN2', (1,3,4,)),
        )
#---------------------------------------------------------------------------------------------------
class LCS3S3CA(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element 
      Geometry           : SEG33 (SEG3 with SEG3)
      Local Numerotation :
          SEG3 SLAVE  ELEMENT : 3         (DX,DY,LAGS_C) - Geom. Slave: LACS32D
          SEG3 MASTER ELEMENT : 1-2-4-5-6 (DX,DY)
    """
    meshType = MT.SEG33
    nodes = (
            SetOfNodes('EN2', (1,2,4,5,6,)),
            SetOfNodes('EN1', (3,)),
        )
#---------------------------------------------------------------------------------------------------
class LCS2S3CA(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element
      Geometry           : SEG23 (SEG2 with SEG3)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 2         (DX,DY,LAGS_C) - Geom. Slave: LACS22D
          SEG3 MASTER ELEMENT : 1-3-4-5   (DX,DY)              
      
    """
    meshType = MT.SEG23
    nodes = (
            SetOfNodes('EN1', (2,)),
            SetOfNodes('EN2', (1,3,4,5,)),      
        )
#---------------------------------------------------------------------------------------------------
class LCS3S2CA(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element
      Geometry           : SEG32 (SEG3 with SEG2)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 3         (DX,DY,LAGS_C) - Geom. Slave: LACS22D
          SEG3 MASTER ELEMENT : 1-2-4-5   (DX,DY)     
      
    """
    meshType = MT.SEG32
    nodes = (
            SetOfNodes('EN1', (3,)),
            SetOfNodes('EN2', (1,2,4,5,)),      
        )
#---------------------------------------------------------------------------------------------------
class LCS2S2DA(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element    
      Geometry           : SEG22 (SEG2 with SEG2)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 1         (DX,DY,LAGS_C) - Geom. Slave: LACS22DB
          SEG2 MASTER ELEMENT : 2,3,4     (DX,DY)   
    """
    meshType = MT.SEG22
    nodes = (
            SetOfNodes('EN1', (1,)),            
            SetOfNodes('EN2', (2,3,4,)),     
        )
#---------------------------------------------------------------------------------------------------
class LCS2S3DA(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element    
      Geometry           : SEG23 (SEG2 with SEG3)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 1         (DX,DY,LAGS_C) - Geom. Slave: LACS22DB
          SEG3 MASTER ELEMENT : 2,3,4,5   (DX,DY)   
    """
    meshType = MT.SEG23
    nodes = (
            SetOfNodes('EN1', (1,)),
            SetOfNodes('EN2', (2,3,4,5,)),     
        )
#---------------------------------------------------------------------------------------------------
class LCS2S2EA(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element    
      Geometry           : SEG22 (SEG2 with SEG2)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 1,2       (DX,DY,LAGS_C) - Geom. Slave: LACS22DT
          SEG2 MASTER ELEMENT : 3,4       (DX,DY)   
    """
    meshType = MT.SEG22
    nodes = (
            SetOfNodes('EN1', (1,2,)),
            SetOfNodes('EN2', (3,4,)),     
        )
#---------------------------------------------------------------------------------------------------
class LCS2S3EA(LCS2S2C):
    """
      Derived from the main 2D class element LACS2S2C for DEFI_CONTACT/LAC - Frictionless 
      Input parameters   : same as the parent element               
      Output parameters  : same as the parent element 
      Options            : same as the parent element    
      Geometry           : SEG23 (SEG2 with SEG3)
      Local Numerotation :
          SEG2 SLAVE  ELEMENT : 1,2       (DX,DY,LAGS_C) - Geom. Slave: LACS22DT
          SEG3 MASTER ELEMENT : 3,4,5     (DX,DY)   
    """
    meshType = MT.SEG23
    nodes = (
            SetOfNodes('EN1', (1,2,)),
            SetOfNodes('EN2', (3,4,5,)),    
        )
#---------------------------------------------------------------------------------------------------
