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

subroutine cfnorm(ndim, tau1, tau2, norm, noor)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "asterfort/assert.h"
#include "asterfort/normev.h"
#include "asterfort/provec.h"
    integer :: ndim
    real(kind=8) :: tau1(3)
    real(kind=8) :: tau2(3)
    real(kind=8) :: norm(3)
    real(kind=8) :: noor
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT)
!
! CALCULE LA NORMALE VERS L'EXTERIEUR A PARTIR DES TANGENTES
!
! ----------------------------------------------------------------------
!
!
! CETTE ROUTINE CALCULE LA NORMALE EXTERIEURE A PARTIR DES
! TANGENTES EXTERIEURES
!
! IN  NDIM   : DIMENSION DE LA MAILLE DE CONTACT
! IN  TAU1   : PREMIERE TANGENTE
! IN  TAU2   : SECONDE TANGENTE
! OUT NORM   : NORMALE RESULTANTE
! OUT NOOR   : NORME DE LA NORMALE
!
! ----------------------------------------------------------------------
!
    if (ndim .eq. 2) then
        norm(1) = tau1(2)
        norm(2) = -tau1(1)
        norm(3) = 0.d0
    else if (ndim.eq.3) then
        call provec(tau1, tau2, norm)
    else
        ASSERT(.false.)
    endif
    call normev(norm, noor)
!
end subroutine
