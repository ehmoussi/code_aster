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
subroutine mmnsta(ndim  , loptf ,&
                  lpenaf, coefaf,&
                  indco ,&
                  lambda, djeut , dlagrf,&
                  tau1  , tau2  ,&
                  lcont , ladhe ,&
                  rese  , nrese)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/mmtrpr.h"
!
integer, intent(in) :: ndim
aster_logical, intent(in) :: loptf
aster_logical, intent(in) :: lpenaf
integer, intent(in) :: indco
real(kind=8), intent(in) :: coefaf, lambda
real(kind=8), intent(in) :: djeut(3), dlagrf(2)
real(kind=8), intent(in)  :: tau1(3), tau2(3)
aster_logical, intent(out) :: lcont, ladhe
real(kind=8), intent(out) :: rese(3), nrese
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute state of contact and friction
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  loptf            : flag if compute RIGI_FROT
! In  lpenaf           : flag for penalized friction
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  lambda           : contact pressure
! In  djeut            : increment of tangent gaps
! In  dlagrf           : increment of friction Lagrange from beginning of time step
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  indco            : flag for contact status
! In  indco_prev       : flag for contact status (previous iteration)
! Out lcont            : .true. if contact
! Out ladhe            : .true. if stick
! Out rese             : Lagrange (semi) multiplier for friction
! Out nrese            : norm of Lagrange (semi) multiplier for friction
!
! --------------------------------------------------------------------------------------------------
!
    lcont   = ASTER_FALSE
    ladhe   = ASTER_FALSE
    nrese   = 0.d0
    rese(:) = 0.d0
!
! - Contact state of contact
!
    lcont = (indco .eq. 1)
    if (loptf) then
! This test influence highly the NON_REGRESSION & CONVERGENCE
! ONE MUST HAVE ATTENTION WHEN MODIFYING
        if (lambda .eq. 0.d0) then
            lcont = ASTER_FALSE
        endif
    endif
!
! - Compute state of friction
!
    if (loptf .and. lcont) then
        call mmtrpr(ndim, lpenaf, djeut, dlagrf, coefaf,&
                    tau1, tau2  , ladhe, rese  , nrese)
    endif
!
end subroutine
