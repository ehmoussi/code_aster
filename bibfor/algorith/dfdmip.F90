! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine dfdmip(ndim, nno, axi, geom, g,&
                  iw, vff, idfde, r, w,&
                  dfdi)
!
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/dfdm3d.h"
#include "blas/ddot.h"
    aster_logical :: axi
    integer :: ndim, nno, g, iw, idfde
    real(kind=8) :: geom(ndim, nno), vff(nno), r, w, dfdi(nno, ndim)
!
! ----------------------------------------------------------------------
!     CALCUL DES DERIVEES DES FONCTIONS DE FORME ET DU JACOBIEN
!
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  NNO     : NOMBRE DE NOEUDS (FAMILLE E-BARRE)
! IN  AXI     : .TRUE. SI AXISYMETRIQUE
! IN  GEOM    : COORDONNEES DES NOEUDS
! IN  G       : NUMERO DU POINT DE GAUSS COURANT
! IN  IW      : ACCES AUX POIDS DES POINTS DE GAUSS DE REFERENCE
! IN  VFF     : VALEURS DES FONCTIONS DE FORME (POINT DE GAUSS COURANT)
! IN  IDFDE   : DERIVEES DES FONCTIONS DE FORME DE REFERENCE
! OUT R       : RAYON DU POINT DE GAUSS COURANT (EN AXI)
! OUT W       : POIDS DU POINT DE GAUSS COURANT (Y COMPRIS R EN AXI)
! OUT DFDI    : DERIVEE DES FONCTIONS DE FORME (POINT DE GAUSS COURANT)
! ----------------------------------------------------------------------
!
! ----------------------------------------------------------------------
!
!
!
! - CALCUL DES DERIVEES DES FONCTIONS DE FORME ET JACOBIEN
    if (ndim .eq. 3) then
        call dfdm3d(nno, g, iw, idfde, geom,&
                    w, dfdi(1, 1), dfdi(1, 2), dfdi(1, 3))
    else
        call dfdm2d(nno, g, iw, idfde, geom,&
                    w, dfdi(1, 1), dfdi(1, 2))
    endif
!
!
! - CALCUL DE LA DISTANCE A L'AXE EN AXI
    if (axi) then
        r = ddot(nno,vff,1,geom,2)
        w = w*r
    endif
!
end subroutine
