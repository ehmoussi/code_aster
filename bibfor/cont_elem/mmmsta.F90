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
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
subroutine mmmsta(ndim         , loptf         , indco ,&
                  ialgoc       , ialgof        ,&
                  lpenaf       , coefaf        ,&
                  lambda       , djeut         , dlagrf,&
                  tau1         , tau2          ,&
                  lcont        , ladhe         ,&
                  rese         , nrese         ,&
                  l_previous_  , indco_prev_   ,&
                  indadhe_prev_, indadhe2_prev_)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/mmtrpr.h"
!
integer, intent(in) :: ndim
aster_logical, intent(in) :: loptf
integer, intent(in) :: indco
integer, intent(in) :: ialgoc, ialgof
aster_logical, intent(in) :: lpenaf
real(kind=8), intent(in) :: coefaf, lambda
real(kind=8), intent(in) :: djeut(3), dlagrf(2)
real(kind=8), intent(in)  :: tau1(3), tau2(3)
aster_logical, intent(out) :: lcont, ladhe
real(kind=8), intent(out) :: rese(3), nrese
aster_logical, optional, intent(in) :: l_previous_
integer, optional, intent(in) :: indco_prev_, indadhe_prev_, indadhe2_prev_
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
! In  l_previous       : flag to manage cycling (previous iteration)
! In  ialgoc           : formulation for contact
!                        1 - Standard
!                        3 - Penalization
!                        5 - LAC
! In  ialgof           : formulation for friction
!                        1 - Standard
!                        3 - Penalization
! In  lpenaf           : flag for penalized friction
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  lambda           : contact pressure
! In  djeut            : increment of tangent gaps
! In  dlagrf           : increment of friction Lagrange from beginning of time step
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  indco            : flag for contact status
! In  indco_prev       : flag for contact status (previous iteration)
! In  indadhe_prev
! In  indadhe2_prev
! Out lcont            : .true. if contact
! Out ladhe            : .true. if stick
! Out rese             : Lagrange (semi) multiplier for friction
! Out nrese            : norm of Lagrange (semi) multiplier for friction
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_previous
    integer :: indco_prev, indadhe_prev, indadhe2_prev
!
! --------------------------------------------------------------------------------------------------
!
    lcont   = ASTER_FALSE
    ladhe   = ASTER_FALSE
    nrese   = 0.d0
    rese(:) = 0.d0
!
    if (present(l_previous_)) then
        l_previous    = l_previous_
        indco_prev    = indco_prev_
        indadhe_prev  = indadhe_prev_
        indadhe2_prev = indadhe2_prev_
        ASSERT(l_previous)
    else
        l_previous    = ASTER_FALSE
        indco_prev    = 0
        indadhe_prev  = 0
        indadhe2_prev = 0
    endif
!
! - Contact state of contact
!
    if (l_previous) then
        lcont = (indco_prev .eq. 1)
    else
        lcont = (indco .eq. 1)
    endif
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
                    tau1, tau2  , ladhe, rese, nrese)
! On est en penalisatio  ou en algo_cont=penalisation, algo_frot=standard/penalisation
        if (indadhe_prev .eq. 1 .and. l_previous) then
            ladhe = ASTER_TRUE
        endif
        if (indadhe2_prev .eq. 1 .and. (ialgoc.eq.3) .and. .not. (ialgof.eq.3)  ) then
            ladhe = ASTER_TRUE
        endif
    endif
!
end subroutine
