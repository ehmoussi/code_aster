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

subroutine pidegv(neps, tau, epsm, epsp, epsd,&
                  copilo)
!
!
    implicit none
#include "asterc/r8gaem.h"
#include "asterfort/zerop2.h"
#include "blas/ddot.h"
#include "blas/dnrm2.h"
    integer :: neps
    real(kind=8) :: tau, epsm(neps), epsd(neps), epsp(neps)
    real(kind=8) :: copilo(2, 2)
! ----------------------------------------------------------------------
!     PILOTAGE DEFORMATION POUR MODELISATION GRAD_VARI
! ----------------------------------------------------------------------
! IN  NEPS    DIMENSION DES DEFORMATIONS (3*NDIM+2)
! IN  TAU     INCREMENT DE PILOTAGE
! IN  EPSM    CHAMP DE DEFORMATION EN T-
! IN  EPSP    INCREMENT FIXE
! IN  EPSD    INCREMENT PILOTE
! OUT COPILO  COEFFICIENTS DE PILOTAGE :
!               F := COPILO(1,1)+COPILO(2,1)*ETA = TAU
!               F := COPILO(1,2)+COPILO(2,2)*ETA = TAU
! ----------------------------------------------------------------------
    integer :: ndim, ndimsi, nrac, i
    real(kind=8) :: epsmno, p0, p1, p2, rac(2)
! ----------------------------------------------------------------------
!
! -- INITIALISATION
!
    ndim = (neps-2)/3
    ndimsi = 2*ndim
!
!
! -- COEFFICIENTS DE PILOTAGE
!
    epsmno = dnrm2(ndimsi,epsm,1)
!
    if (epsmno .gt. 1.d0/r8gaem()) then
        copilo(1,1) = ddot(ndimsi, epsm,1, epsp,1)/epsmno
        copilo(2,1) = ddot(ndimsi, epsm,1, epsd,1)/epsmno
!
    else
!
!      PREMIER PAS : PILOTAGE PAR LA NORME DE L'INCREMENT
        p2=ddot(ndimsi,epsd,1,epsd,1)
        p1=ddot(ndimsi,epsd,1,epsp,1)*2
        p0=ddot(ndimsi,epsp,1,epsp,1)
        call zerop2(p1/p2, (p0-tau**2)/p2, rac, nrac)
!
        do 10 i = 1, nrac
            copilo(2,i) = 0.5d0*(2*p2*rac(i)+p1)/tau
            copilo(1,i) = tau**2-rac(i)*copilo(2,i)
10      continue
!
    endif
end subroutine
