! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmGetCoefficients(coefff, coefac, coefaf, alpha_cont)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jevech.h"
!
real(kind=8), intent(out) :: coefff, coefac, coefaf
real(kind=8), intent(out) :: alpha_cont
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Get coefficients
!
! --------------------------------------------------------------------------------------------------
!
! Out coefff           : friction coefficient (Coulomb)
! Out coefac           : coefficient for updated Lagrangian method (contact)
! Out coefaf           : coefficient for updated Lagrangian method (friction)
! Out alpha_cont       : ratio for linear combination of matrix (contact)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jpcf
    real(kind=8) :: alpha_fric
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PCONFR', 'L', jpcf)
!
    coefac     = zr(jpcf-1+16)
    coefaf     = zr(jpcf-1+19)
    coefff     = zr(jpcf-1+20)
    alpha_cont = zr(jpcf-1+28)
    alpha_fric = zr(jpcf-1+42)
!
end subroutine
