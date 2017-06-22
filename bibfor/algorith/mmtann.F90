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

subroutine mmtann(ndim, tau1, tau2, iret)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/normev.h"
    integer :: ndim, iret
    real(kind=8) :: tau1(3), tau2(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT)
!
! NORMALISATION DES VECTEURS TANGENTS
!
! ----------------------------------------------------------------------
!
!
! IN  NDIM   : DIMENSION DE LA MAILLE (2 OU 3)
! OUT TAU1   : PREMIER VECTEUR TANGENT EN XI,YI
! OUT TAU2   : SECOND VECTEUR TANGENT EN XI,YI
! OUT IRET   : VAUT 1 SI TANGENTES NULLES, 0 SINON
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: nta1, nta2
!
! ----------------------------------------------------------------------
!
    iret = 0
!
    call normev(tau1, nta1)
!
    if (ndim .eq. 2) then
        call normev(tau1, nta1)
        nta2 = 1.d0
    else if (ndim.eq.3) then
        call normev(tau1, nta1)
        call normev(tau2, nta2)
    else
        ASSERT(.false.)
    endif
!
! --- VERIFICATION DES TANGENTES
!
    if (abs(nta1) .le. r8prem()) then
        iret = 1
    endif
    if (abs(nta2) .le. r8prem()) then
        iret = 2
    endif
!
end subroutine
