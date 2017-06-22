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

subroutine mmnorm(ndim, tau1, tau2, norm, noor_)
!
implicit none
!
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/normev.h"
#include "asterfort/provec.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: ndim
    real(kind=8), intent(in) :: tau1(3)
    real(kind=8), intent(in) :: tau2(3)
    real(kind=8), intent(out) :: norm(3)
    real(kind=8), optional, intent(out) :: noor_
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCULE LA NORMALE VERS INTERIEUR A PARTIR DES TANGENTES
!
! ----------------------------------------------------------------------
!
!
! CETTE ROUTINE CALCULE LA NORMALE INTERIEURE A PARTIR DES
! TANGENTES EXTERIEURES
!
! IN  NDIM   : DIMENSION DE LA MAILLE DE CONTACT
! IN  TAU1   : PREMIERE TANGENTE EXTERIEURE
! IN  TAU2   : SECONDE TANGENTE EXTERIEURE
! OUT NORM   : NORMALE INTERIEURE
! OUT NOOR   : NORME DE LA NORMALE
!
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: noor
!
! ----------------------------------------------------------------------
!
    norm(1:3) = 0.d0
    noor = r8prem()
    if (ndim .eq. 2) then
        norm(1) = -tau1(2)
        norm(2) = tau1(1)
        norm(3) = 0.d0
    else if (ndim.eq.3) then
        call provec(tau2, tau1, norm)
    else
        ASSERT(.false.)
    endif
!
    call normev(norm, noor)
    if (present(noor_)) then
        noor_ = noor
    endif
!
end subroutine
