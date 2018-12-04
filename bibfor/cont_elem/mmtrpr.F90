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
subroutine mmtrpr(ndim, lpenaf, djeut, dlagrf, coefaf,&
                  tau1, tau2  , ladhe, rese  , nrese)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
integer, intent(in) :: ndim
aster_logical, intent(in):: lpenaf
real(kind=8), intent(in) :: djeut(3), dlagrf(2), coefaf
real(kind=8), intent(in) :: tau1(3), tau2(3)
real(kind=8), intent(out) :: rese(3), nrese
aster_logical, intent(out):: ladhe
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute state of friction
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  lpenaf           : flag for penalized friction
! In  djeut            : increment of tangent gaps
! In  dlagrf           : increment of friction Lagrange from beginning of time step
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! Out ladhe            : .true. if stick
! Out rese             : Lagrange (semi) multiplier for friction
! Out nrese            : norm of Lagrange (semi) multiplier for friction
!
! --------------------------------------------------------------------------------------------------
!
    integer :: idim
!
! --------------------------------------------------------------------------------------------------
!
    nrese   = 0.d0
    rese(:) = 0.d0
!
! - Compute Lagrange (semi) multiplier for friction
!
    if (lpenaf) then
        do idim = 1, 3
            rese(idim) = coefaf*djeut(idim)
        end do
    else
        if (ndim .eq. 2) then
            do idim = 1, 2
                rese(idim) = dlagrf(1)*tau1(idim)+coefaf*djeut(idim)
            end do
        else if (ndim.eq.3) then
            do idim = 1, 3
                rese(idim) = dlagrf(1)*tau1(idim)+dlagrf(2)*tau2(idim)+coefaf*djeut(idim)
            end do
        else
            ASSERT(ASTER_FALSE)
        endif
    endif
!
! - Compute norm of Lagrange (semi) multiplier for friction
!
    do idim = 1, 3
        nrese = rese(idim)*rese(idim) + nrese
    end do
    nrese = sqrt(nrese)
!
! - Stick of slip ?
!
    if (nrese .le. 1.d0) then
        ladhe = ASTER_TRUE
    else
        ladhe = ASTER_FALSE
    endif
!
end subroutine
