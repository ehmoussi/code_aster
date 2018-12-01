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
subroutine mngliss(ndim     , kappa    ,&
                   tau1     , tau2     ,&
                   taujeu1  , taujeu2  ,&
                   dnepmait1, dnepmait2,&
                   djeut)
!
implicit none
!
#include "asterfort/assert.h"
!
integer, intent(in) :: ndim
real(kind=8), intent(in):: kappa(2,2)
real(kind=8), intent(in) :: tau1(3), tau2(3)
real(kind=8), intent(in) :: taujeu1, taujeu2
real(kind=8), intent(in) :: dnepmait1, dnepmait2
real(kind=8), intent(out) ::  djeut(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Update tangential gap
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  kappa            : MATRICE DE SCALAIRES LIEES A LA CINEMATIQUE DU GLISSEMENT
!                        KAPPA(i,j) = INVERSE[tau_i.tau_j-JEU*(ddFFM*geomm)](matrice 2*2)
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  dnepmait1        :
! In  dnepmait2        :
! In  taujeu1          :
! In  taujeu2          :
! Out djeut            : increment of tangent gaps
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, idim
    real(kind=8) :: dxi1,dxi2
!
! --------------------------------------------------------------------------------------------------
!
    djeut = 0.d0
    dxi1  = 0.d0
    dxi2  = 0.d0
!
    if (ndim .eq. 2) then
        dxi1 = kappa(1,1)*(taujeu1 + dnepmait1)
        do i = 1, ndim
            djeut(i) = tau1(i)*dxi1
        end do
    else if (ndim.eq.3) then
        dxi1 = kappa(1,1)*(taujeu1 + dnepmait1)+kappa(1,2)*(taujeu2 + dnepmait2)
        dxi2 = kappa(2,1)*(taujeu1 + dnepmait1)+kappa(2,2)*(taujeu2 + dnepmait2)
        do idim =1,ndim
            djeut(idim) = (tau1(idim)*dxi1+tau2(idim)*dxi2)
        end do
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
